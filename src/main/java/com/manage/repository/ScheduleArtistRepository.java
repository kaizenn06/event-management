package manage.repository;

import manage.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
public interface ScheduleArtistRepository extends JpaRepository<ScheduleArtist, ScheduleArtistId> {
    List<ScheduleArtist> findBySchedule_ScheduleId(String scheduleId);
}
