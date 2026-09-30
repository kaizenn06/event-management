package eventmanagement.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "`order`")
@Getter @Setter @NoArgsConstructor
public class Order {

    @Id
    @Column(name = "order_id", length = 20)
    private String orderId;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

    @Column(name = "created_at", nullable = false, insertable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "total_amount", nullable = false, precision = 15, scale = 0)
    private BigDecimal totalAmount = BigDecimal.ZERO;

    @Column(name = "status", nullable = false, length = 100)
    private String status;

    @Column(name = "payment_method", length = 500)
    private String paymentMethod;

    @Column(name = "payment_at")
    private LocalDateTime paymentAt;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrderDetail> details = new ArrayList<>();
}
