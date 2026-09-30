package manage.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "organizer")
@PrimaryKeyJoinColumn(name = "organizer_id")
@Getter @Setter @NoArgsConstructor
public class Organizer extends People {

    @Column(name = "tax_code", nullable = false, unique = true, length = 100)
    private String taxCode;

    @Column(name = "address", nullable = false, length = 200)
    private String address;
}
