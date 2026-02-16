package tn.esprit.memberservice.service;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import tn.esprit.memberservice.dto.UserDTO;
import tn.esprit.memberservice.entity.Member;
import tn.esprit.memberservice.repository.MemberRepository;

import java.util.List;

@Service
public class MemberService {

    private final MemberRepository repo;
    private final RestTemplate restTemplate;

    // ✅ appel via API Gateway (8089)
    private static final String USER_URL = "http://localhost:8089/users/{id}";

    public MemberService(MemberRepository repo, RestTemplate restTemplate) {
        this.repo = repo;
        this.restTemplate = restTemplate;
    }
    public Member create(Member m) {

        if (m.getIdUser() == null) {
            throw new RuntimeException("idUser est obligatoire");
        }

        // ✅ MODE TEST : pas d'appel user-service
        m.setNom("Test");
        m.setPrenom("User");
        m.setEmail("test@mail.com");
        m.setTelephone("00000000");

        return repo.save(m);
    }

//    public Member create(Member m) {
//
//        if (m.getIdUser() == null) {
//            throw new RuntimeException("idUser est obligatoire");
//        }
//
//        UserDTO user;
//        try {
//            user = restTemplate.getForObject(USER_URL, UserDTO.class, m.getIdUser());
//        } catch (HttpClientErrorException e) {
//            if (e.getStatusCode() == HttpStatus.NOT_FOUND) {
//                throw new RuntimeException("User introuvable avec id = " + m.getIdUser());
//            }
//            throw new RuntimeException("Erreur appel User-Service: " + e.getMessage());
//        } catch (Exception e) {
//            throw new RuntimeException("User-Service inaccessible (Gateway 8089): " + e.getMessage());
//        }
//
//        if (user == null) {
//            throw new RuntimeException("User introuvable avec id = " + m.getIdUser());
//        }
//
//        // ✅ remplir automatiquement
//        m.setNom(user.getNom());
//        m.setPrenom(user.getPrenom());
//        m.setEmail(user.getEmail());
//        m.setTelephone(user.getTelephone());
//
//        return repo.save(m);
//    }

    public Member update(Long id, Member updated) {

        Member existing = repo.findById(id)
                .orElseThrow(() -> new RuntimeException("Member introuvable"));

        // on met à jour seulement ce que tu veux
        existing.setNiveauAnglais(updated.getNiveauAnglais());

        // (optionnel) resync user
        try {
            UserDTO user = restTemplate.getForObject(USER_URL, UserDTO.class, existing.getIdUser());
            if (user != null) {
                existing.setNom(user.getNom());
                existing.setPrenom(user.getPrenom());
                existing.setEmail(user.getEmail());
                existing.setTelephone(user.getTelephone());
            }
        } catch (Exception ignored) {
            // on ignore si user-service est down
        }

        return repo.save(existing);
    }

    public List<Member> getAll() {
        return repo.findAll();
    }

    public Member getById(Long id) {
        return repo.findById(id).orElseThrow(() -> new RuntimeException("Member introuvable"));
    }

    public List<Member> getByUser(Long idUser) {
        return repo.findByIdUser(idUser);
    }

    public void delete(Long id) {
        repo.deleteById(id);
    }
}
