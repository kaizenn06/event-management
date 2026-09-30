package manage.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "`event`")
@Getter @Setter @NoArgsConstructor
public class Event {

    @Id
    @Column(name = "event_id", length = 20)
    private String eventId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "organizer_id", nullable = false)
    private Organizer organizer;

    @Column(name = "title", nullable = false, length = 1000)
    private String title;

    @Column(name = "image", nullable = false, length = 1000)
    private String image;

    @Column(name = "`desc`", nullable = false, length = 1000)
    private String desc;

    @Column(name = "create_type", length = 100)
    private String createType;
}
