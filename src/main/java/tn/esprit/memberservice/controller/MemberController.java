package tn.esprit.memberservice.controller;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import tn.esprit.memberservice.entity.Member;
import tn.esprit.memberservice.service.MemberService;

import java.util.List;

@RestController
@RequestMapping("/membres")
public class MemberController {

    private final MemberService service;

    public MemberController(MemberService service) {
        this.service = service;
    }

    @PostMapping
    public Member create(@Valid @RequestBody Member m) {
        return service.create(m);
    }
    @PutMapping("/{id}")
    public Member update(@PathVariable Long id, @RequestBody Member m) {
        return service.update(id, m);
    }

    @GetMapping
    public List<Member> getAll() {
        return service.getAll();
    }

    @GetMapping("/{id}")
    public Member getById(@PathVariable Long id) {
        return service.getById(id);
    }

    @GetMapping("/by-user/{idUser}")
    public List<Member> getByUser(@PathVariable Long idUser) {
        return service.getByUser(idUser);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<String> handle(RuntimeException ex) {
        return ResponseEntity.badRequest().body(ex.getMessage());
    }
}
