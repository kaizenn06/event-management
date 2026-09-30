package eventmanagement.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;

@Entity
@Table(name = "customer")
@PrimaryKeyJoinColumn(name = "customer_id")
@Getter @Setter @NoArgsConstructor
public class Customer extends People {

    @Column(name = "gender", nullable = false, length = 10)
    private String gender;

    @Column(name = "date_of_birth", nullable = false)
    private LocalDate dateOfBirth;
}
