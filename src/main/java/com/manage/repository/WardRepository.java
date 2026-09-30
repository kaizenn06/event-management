package manage.repository;

import manage.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WardRepository extends JpaRepository<Ward, String> {
}
