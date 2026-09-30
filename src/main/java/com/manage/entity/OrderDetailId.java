package manage.entity;

import jakarta.persistence.*;
import lombok.*;
import java.io.Serializable;

@Embeddable
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
@EqualsAndHashCode
public class OrderDetailId implements Serializable {

    @Column(name = "order_id", length = 20)
    private String orderId;

    @Column(name = "ticket_id", length = 20)
    private String ticketId;
}
