package tn.esprit.memberservice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import tn.esprit.memberservice.entity.Member;

import java.util.List;

public interface MemberRepository extends JpaRepository<Member, Long> {
    List<Member> findByIdUser(Long idUser);
}
