package manage.entity;

import jakarta.persistence.*;
import lombok.*;
import java.io.Serializable;

@Embeddable
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
@EqualsAndHashCode
public class ScheduleArtistId implements Serializable {

    @Column(name = "artist_id", length = 20)
    private String artistId;

    @Column(name = "schedule_id", length = 20)
    private String scheduleId;
}
