package tn.esprit.eventservice.controller;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import tn.esprit.eventservice.entity.Event;
import tn.esprit.eventservice.service.EventService;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/events")
public class EventController {

    private final EventService eventService;

    public EventController(EventService eventService) {
        this.eventService = eventService;
    }

    // ✅ GET /events
    @GetMapping
    public List<Event> getAllEvents() {
        return eventService.getAllEvents();
    }

    // ✅ GET /events/{id}
    @GetMapping("/{id}")
    public ResponseEntity<Event> getEventById(@PathVariable Long id) {
        Optional<Event> event = eventService.getEventById(id);
        return event.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    // ✅ POST /events
    @PostMapping
    public ResponseEntity<Event> createEvent(@Valid @RequestBody Event event) {
        Event created = eventService.createEvent(event);
        return ResponseEntity.ok(created);
    }

    // ✅ PUT /events/{id}
    @PutMapping("/{id}")
    public ResponseEntity<Event> updateEvent(@PathVariable Long id, @Valid @RequestBody Event event) {
        Optional<Event> updated = eventService.updateEvent(id, event);
        return updated.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    // ✅ DELETE /events/{id}
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteEventById(@PathVariable Long id) {
        boolean isDeleted = eventService.deleteEventById(id);
        return isDeleted ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
    }

    // ✅ DELETE /events/by-title?title=xxx
    @DeleteMapping("/by-title")
    public ResponseEntity<Void> deleteEventByTitle(@RequestParam String title) {
        boolean isDeleted = eventService.deleteEventByTitle(title);
        return isDeleted ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
    }

    // ✅ DELETE /events/by-date?eventDate=2026-02-15
    @DeleteMapping("/by-date")
    public ResponseEntity<Void> deleteEventByDate(@RequestParam String eventDate) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // ✅ même format que ton entity
            Date parsedDate = sdf.parse(eventDate);

            boolean isDeleted = eventService.deleteEventByDate(parsedDate);
            return isDeleted ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();

        } catch (Exception e) {
            return ResponseEntity.badRequest().build(); // date mal formatée
        }
    }
    @PutMapping("/{id}/capacity/decrement")
    public ResponseEntity<Event> decrement(@PathVariable Long id) {
        return ResponseEntity.ok(eventService.decrementCapacity(id));
    }

    @PutMapping("/{id}/capacity/increment")
    public ResponseEntity<Event> increment(@PathVariable Long id) {
        return ResponseEntity.ok(eventService.incrementCapacity(id));
    }


}
