package manage.repository;

import manage.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrganizerRepository extends JpaRepository<Organizer, String> {
}
