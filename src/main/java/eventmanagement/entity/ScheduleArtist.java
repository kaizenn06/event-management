package eventmanagement.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "schedule_artist")
@Getter @Setter @NoArgsConstructor
public class ScheduleArtist {

    @EmbeddedId
    private ScheduleArtistId id = new ScheduleArtistId();

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("artistId")
    @JoinColumn(name = "artist_id")
    private Artist artist;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("scheduleId")
    @JoinColumn(name = "schedule_id")
    private EventSchedule schedule;

    @Column(name = "role", nullable = false, length = 100)
    private String role;
}
