package eventmanagement.service;

import eventmanagement.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Kiểm tra nhanh: app đã kết nối được DB chưa, entity map đúng bảng chưa,
 * và mydb.sql đã được chạy chưa (đếm số dòng của từng bảng).
 */
@Service
@RequiredArgsConstructor
public class CheckService {

    private final PeopleRepository peopleRepo;
    private final AdminRepository adminRepo;
    private final OrganizerRepository organizerRepo;
    private final CustomerRepository customerRepo;
    private final WardRepository wardRepo;
    private final VenueRepository venueRepo;
    private final EventRepository eventRepo;
    private final EventScheduleRepository scheduleRepo;
    private final ArtistRepository artistRepo;
    private final ScheduleArtistRepository scheduleArtistRepo;
    private final TicketRepository ticketRepo;
    private final OrderRepository orderRepo;
    private final OrderDetailRepository orderDetailRepo;

    @Transactional(readOnly = true)
    public Map<String, Long> countAllTables() {
        Map<String, Long> counts = new LinkedHashMap<>();
        counts.put("people", peopleRepo.count());
        counts.put("admin", adminRepo.count());
        counts.put("organizer", organizerRepo.count());
        counts.put("customer", customerRepo.count());
        counts.put("ward", wardRepo.count());
        counts.put("venue", venueRepo.count());
        counts.put("event", eventRepo.count());
        counts.put("event_schedule", scheduleRepo.count());
        counts.put("artist", artistRepo.count());
        counts.put("schedule_artist", scheduleArtistRepo.count());
        counts.put("ticket", ticketRepo.count());
        counts.put("order", orderRepo.count());
        counts.put("order_detail", orderDetailRepo.count());
        return counts;
    }
}