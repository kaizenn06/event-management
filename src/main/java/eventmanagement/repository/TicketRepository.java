package eventmanagement.repository;

import eventmanagement.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.Lock;
import java.util.List;
import java.util.Optional;
public interface TicketRepository extends JpaRepository<Ticket, String> {
    List<Ticket> findBySchedule_ScheduleId(String scheduleId);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    Optional<Ticket> findByTicketId(String ticketId);
}
