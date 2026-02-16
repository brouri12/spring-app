package tn.esprit.reservationservice.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import tn.esprit.reservationservice.entity.Registration;
import tn.esprit.reservationservice.repository.RegistrationRepository;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class RegistrationService {

    @Autowired
    private RegistrationRepository registrationRepository;

    @Autowired
    private RestTemplate restTemplate;

    private static final String USER_SERVICE_URL = "http://localhost:8089/users/{id}";
    private static final String EVENT_DECREMENT_URL = "http://localhost:8089/events/{id}/capacity/decrement";
    private static final String EVENT_INCREMENT_URL = "http://localhost:8089/events/{id}/capacity/increment";
    private static final String EVENT_SERVICE_URL = "http://localhost:8089/events/{id}";

    public List<Registration> getAllRegistrations() {
        return registrationRepository.findAll();
    }

    public List<Registration> getRegistrationsByEventId(Long eventId) {
        return registrationRepository.findByEventId(eventId);
    }

    public Optional<Registration> getRegistrationById(Long id) {
        return registrationRepository.findById(id);
    }

    @Transactional
    public Registration createRegistration(Registration registration) {

        Long eventId = registration.getEventId();
        if (eventId == null) throw new RuntimeException("eventId obligatoire");

        // 1) vérifier event existe
        Object event = restTemplate.getForObject(EVENT_SERVICE_URL, Object.class, eventId);
        if (event == null) throw new RuntimeException("Événement non trouvé");

        // 2) empêcher double inscription
        if (registrationRepository.existsByUserIdAndEventId(registration.getUserId(), eventId)) {
            throw new RuntimeException("Utilisateur déjà inscrit à cet événement");
        }

        // 3) diminuer capacity (-1) AVANT save
        restTemplate.put(EVENT_DECREMENT_URL, null, eventId);

        // 4) date today si null
        if (registration.getRegistrationDate() == null) {
            registration.setRegistrationDate(new Date());
        }

        // 5) save
        return registrationRepository.save(registration);
    }

    public Registration updateRegistration(Long id, Registration registrationDetails) {
        if (registrationRepository.existsById(id)) {
            registrationDetails.setIdRegistration(id);
            return registrationRepository.save(registrationDetails);
        }
        return null;
    }

    // ✅ utilisé par DELETE /registrations/{id}
    @Transactional
    public void deleteRegistration(Long id) {
        Registration reg = registrationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Registration introuvable"));

        // (optionnel) augmenter capacity (+1) après suppression
        restTemplate.put(EVENT_INCREMENT_URL, null, reg.getEventId());

        registrationRepository.deleteById(id);
    }

    // ✅ utilisé par DELETE /registrations/by-event/{eventId}
    @Transactional
    public int deleteByEventId(Long eventId) {
        return registrationRepository.deleteAllByEventId(eventId);
    }

    public Object getUserById(Long userId) {
        return restTemplate.getForObject(USER_SERVICE_URL, Object.class, userId);
    }

    public Object getEventById(Long eventId) {
        return restTemplate.getForObject(EVENT_SERVICE_URL, Object.class, eventId);
    }
}
