package eventmanagement.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "ward")
@Getter @Setter @NoArgsConstructor
public class Ward {

    @Id
    @Column(name = "ward_id", length = 20)
    private String wardId;

    @Column(name = "ward_name", nullable = false, unique = true, length = 100)
    private String wardName;
}
