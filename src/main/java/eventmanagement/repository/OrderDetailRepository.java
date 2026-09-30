package eventmanagement.repository;

import eventmanagement.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderDetailRepository extends JpaRepository<OrderDetail, OrderDetailId> {
}
