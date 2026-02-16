package tn.esprit.eventservice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;
import tn.esprit.eventservice.entity.Event;

import java.util.Date;
import java.util.List;

public interface EventRepository extends JpaRepository<Event, Long> {

    Event findByTitle(String title);

    List<Event> findByEventDate(Date eventDate);

    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Transactional
    @Query("UPDATE Event e SET e.capacity = e.capacity - 1 WHERE e.idEvent = :id AND e.capacity > 0")
    int decrementCapacity(@Param("id") Long id);

    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Transactional
    @Query("UPDATE Event e SET e.capacity = e.capacity + 1 WHERE e.idEvent = :id")
    int incrementCapacity(@Param("id") Long id);
}
