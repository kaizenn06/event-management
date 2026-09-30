package eventmanagement.repository;

import eventmanagement.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VenueRepository extends JpaRepository<Venue, String> {
}
