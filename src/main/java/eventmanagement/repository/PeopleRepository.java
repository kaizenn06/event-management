package eventmanagement.repository;

import eventmanagement.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PeopleRepository extends JpaRepository<People, String> {
}
