package manage.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "artist")
@Getter @Setter @NoArgsConstructor
public class Artist {

    @Id
    @Column(name = "artist_id", length = 20)
    private String artistId;

    @Column(name = "artist_name", nullable = false, length = 200)
    private String artistName;

    @Column(name = "nationality", nullable = false, length = 100)
    private String nationality;

    @Column(name = "image", nullable = false, length = 1000)
    private String image;

    @Column(name = "bio", length = 1000)
    private String bio;
}
