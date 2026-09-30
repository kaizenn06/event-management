package eventmanagement.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "`admin`")
@PrimaryKeyJoinColumn(name = "admin_id")
@Getter @Setter @NoArgsConstructor
public class Admin extends People {
}
