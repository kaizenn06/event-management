package eventmanagement.repository;

import eventmanagement.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
public interface EventScheduleRepository extends JpaRepository<EventSchedule, String> {
    List<EventSchedule> findByEvent_EventId(String eventId);
}
