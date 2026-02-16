package tn.esprit.eventservice.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import com.fasterxml.jackson.annotation.JsonFormat;

import java.text.SimpleDateFormat;
import java.util.Date;

@Entity
@Table(name = "events")
public class Event {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idEvent;

    @NotNull(message = "The title of the event cannot be empty.")
    private String title;

    @NotNull(message = "The description cannot be empty.")
    private String description;

    @Enumerated(EnumType.STRING)
    @NotNull(message = "The type of the event cannot be empty.")
    private EventType type;

    @Enumerated(EnumType.STRING)
    @NotNull(message = "The mode of the event cannot be empty.")
    private EventMode mode;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    @Temporal(TemporalType.DATE)
    private Date eventDate;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm:ss")
    @Temporal(TemporalType.TIME)
    private Date startTime;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm:ss")
    @Temporal(TemporalType.TIME)
    private Date endTime;

    @NotNull(message = "The location of the event cannot be empty.")
    private String location;

    @NotNull(message = "The capacity of the event cannot be empty.")
    private Integer capacity;

    @Enumerated(EnumType.STRING)
    @NotNull(message = "The required level of the event cannot be empty.")
    private EventLevel requiredLevel;

    // ✅ Au lieu de OneToMany Registration, on met un champ simple :
    // exemple: le club organisateur
    private Long clubId;

    @PrePersist
    @PreUpdate
    private void validateEventTimes() {

        if (startTime != null && endTime != null && startTime.after(endTime)) {
            throw new IllegalArgumentException("The start time cannot be after the end time.");
        }

        Date currentDate = new Date();
        if (eventDate != null && eventDate.before(currentDate)) {
            throw new IllegalArgumentException("The event date must be in the future.");
        }

        if (capacity != null && capacity <= 0) {
            throw new IllegalArgumentException("The capacity of the event must be a positive number.");
        }

        if (eventDate != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String formattedDate = sdf.format(eventDate);
            try {
                sdf.parse(formattedDate);
            } catch (Exception e) {
                throw new IllegalArgumentException("The event date must be in the format YYYY-MM-DD.");
            }
        }
    }

    // Getters and Setters
    public Long getIdEvent() { return idEvent; }
    public void setIdEvent(Long idEvent) { this.idEvent = idEvent; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public EventType getType() { return type; }
    public void setType(EventType type) { this.type = type; }

    public EventMode getMode() { return mode; }
    public void setMode(EventMode mode) { this.mode = mode; }

    public Date getEventDate() { return eventDate; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }

    public Date getStartTime() { return startTime; }
    public void setStartTime(Date startTime) { this.startTime = startTime; }

    public Date getEndTime() { return endTime; }
    public void setEndTime(Date endTime) { this.endTime = endTime; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }

    public EventLevel getRequiredLevel() { return requiredLevel; }
    public void setRequiredLevel(EventLevel requiredLevel) { this.requiredLevel = requiredLevel; }

    public Long getClubId() { return clubId; }
    public void setClubId(Long clubId) { this.clubId = clubId; }
}
