package eventmanagement.repository;

import eventmanagement.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CustomerRepository extends JpaRepository<Customer, String> {
}
