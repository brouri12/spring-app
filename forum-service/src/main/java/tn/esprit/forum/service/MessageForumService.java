package tn.esprit.forum.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import tn.esprit.forum.entity.Forum;
import tn.esprit.forum.entity.MessageForum;
import tn.esprit.forum.repository.ForumRepository;
import tn.esprit.forum.repository.MessageForumRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MessageForumService {
    
    private final MessageForumRepository messageRepository;
    private final ForumRepository forumRepository;
    
    public Optional<MessageForum> publierMessage(Long forumId, MessageForum message) {
        return forumRepository.findById(forumId).map(forum -> {
            message.setForum(forum);
            message.setDate_message(LocalDateTime.now());
            if (message.getStatut() == null) {
                message.setStatut("ACTIF");
            }
            return messageRepository.save(message);
        });
    }
    
    public Optional<MessageForum> modifierMessage(Long messageId, String nouveauContenu, Long auteurId) {
        return messageRepository.findById(messageId).map(message -> {
            if (!message.getAuteurId().equals(auteurId)) {
                throw new RuntimeException("Seul l'auteur peut modifier ce message");
            }
            message.setContenu(nouveauContenu);
            return messageRepository.save(message);
        });
    }
    
    public boolean supprimerMessage(Long messageId, Long auteurId) {
        return messageRepository.findById(messageId).map(message -> {
            if (!message.getAuteurId().equals(auteurId)) {
                throw new RuntimeException("Seul l'auteur peut supprimer ce message");
            }
            message.setStatut("SUPPRIME");
            messageRepository.save(message);
            return true;
        }).orElse(false);
    }
    
    public List<MessageForum> getMessagesByForum(Long forumId) {
        return messageRepository.findByForumId(forumId);
    }
    
    public Long compterMessagesParForum(Long forumId) {
        return messageRepository.compterMessagesParForum(forumId);
    }
    
    public List<MessageForum> getMessagesByAuteur(Long auteurId) {
        return messageRepository.findByAuteurId(auteurId);
    }
    
    public List<MessageForum> rechercherMessages(String keyword) {
        return messageRepository.rechercherParMotCle(keyword);
    }
}
