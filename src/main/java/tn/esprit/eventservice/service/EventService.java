package tn.esprit.eventservice.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import tn.esprit.eventservice.entity.Event;
import tn.esprit.eventservice.repository.EventRepository;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class EventService {

    private final RestTemplate restTemplate;
    private final EventRepository eventRepository;

    // ✅ URL vers reservation-service (ou API Gateway)
    private static final String REGISTRATION_DELETE_BY_EVENT =
            "http://localhost:8089/registrations/by-event/{eventId}";

    public EventService(EventRepository eventRepository, RestTemplate restTemplate) {
        this.eventRepository = eventRepository;
        this.restTemplate = restTemplate;
    }

    public List<Event> getAllEvents() {
        return eventRepository.findAll();
    }

    public Optional<Event> getEventById(Long id) {
        return eventRepository.findById(id);
    }

    public Event createEvent(Event event) {
        return eventRepository.save(event);
    }

    public Optional<Event> updateEvent(Long id, Event updated) {
        return eventRepository.findById(id).map(existing -> {
            existing.setTitle(updated.getTitle());
            existing.setDescription(updated.getDescription());
            existing.setType(updated.getType());
            existing.setMode(updated.getMode());
            existing.setEventDate(updated.getEventDate());
            existing.setStartTime(updated.getStartTime());
            existing.setEndTime(updated.getEndTime());
            existing.setLocation(updated.getLocation());
            existing.setCapacity(updated.getCapacity());
            existing.setRequiredLevel(updated.getRequiredLevel());
            existing.setClubId(updated.getClubId());
            return eventRepository.save(existing);
        });
    }

    // ✅ DELETE EVENT + REGISTRATIONS
    @Transactional
    public boolean deleteEventById(Long id) {

        if (!eventRepository.existsById(id)) return false;

        try {
            restTemplate.delete(REGISTRATION_DELETE_BY_EVENT, id);
        } catch (RestClientException ex) {
            throw new RuntimeException("Suppression registrations impossible : " + ex.getMessage());
        }

        eventRepository.deleteById(id);
        return true;
    }

    // ✅ DELETE EVENTS (same date) + REGISTRATIONS
    @Transactional
    public boolean deleteEventByDate(Date eventDate) {

        List<Event> events = eventRepository.findByEventDate(eventDate);
        if (events == null || events.isEmpty()) return false;

        for (Event e : events) {
            try {
                restTemplate.delete(REGISTRATION_DELETE_BY_EVENT, e.getIdEvent());
            } catch (RestClientException ex) {
                throw new RuntimeException(
                        "Suppression registrations impossible pour eventId=" + e.getIdEvent() + " : " + ex.getMessage()
                );
            }
        }

        eventRepository.deleteAll(events);
        return true;
    }

    // ✅ DELETE EVENT (title) + REGISTRATIONS
    @Transactional
    public boolean deleteEventByTitle(String title) {

        Event event = eventRepository.findByTitle(title);
        if (event == null) return false;

        try {
            restTemplate.delete(REGISTRATION_DELETE_BY_EVENT, event.getIdEvent());
        } catch (RestClientException ex) {
            throw new RuntimeException("Suppression registrations impossible : " + ex.getMessage());
        }

        eventRepository.delete(event);
        return true;
    }

    @Transactional
    public Event decrementCapacity(Long id) {
        Event e = eventRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Event introuvable"));

        if (e.getCapacity() == null || e.getCapacity() <= 0) {
            throw new RuntimeException("Capacité insuffisante");
        }

        e.setCapacity(e.getCapacity() - 1);
        return eventRepository.save(e);
    }

    @Transactional
    public Event incrementCapacity(Long id) {
        Event e = eventRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Event introuvable"));

        if (e.getCapacity() == null) e.setCapacity(0);
        e.setCapacity(e.getCapacity() + 1);
        return eventRepository.save(e);
    }
}
