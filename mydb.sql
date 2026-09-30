CREATE DATABASE IF NOT EXISTS event_tickets;
USE event_tickets;
DROP TABLE IF EXISTS order_detail;
DROP TABLE IF EXISTS `order`;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS ticket;
DROP TABLE IF EXISTS schedule_artist;
DROP TABLE IF EXISTS artist; 
DROP TABLE IF EXISTS event_schedule;
DROP TABLE IF EXISTS `event`;
DROP TABLE IF EXISTS venue;
DROP TABLE IF EXISTS ward;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS organizer;
DROP TABLE IF EXISTS `admin`;
DROP TABLE IF EXISTS people;

CREATE TABLE people (
    id VARCHAR(20) PRIMARY KEY,
    `name` VARCHAR(1000) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    phone_number VARCHAR(15) NOT NULL,
    password VARCHAR(255) DEFAULT 123456
);

CREATE TABLE `admin` (
    admin_id VARCHAR(20) PRIMARY KEY,
    FOREIGN KEY (admin_id) REFERENCES people(id)
);

CREATE TABLE organizer (
    organizer_id VARCHAR(20) PRIMARY KEY,
    tax_code VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(200) NOT NULL,
    FOREIGN KEY (organizer_id) REFERENCES people(id)
);

CREATE TABLE customer (
    customer_id VARCHAR(20) PRIMARY KEY,
    gender VARCHAR(10) NOT NULL,
    date_of_birth DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES people(id)
);

CREATE TABLE ward (
    ward_id VARCHAR(20) PRIMARY KEY,
    ward_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE venue (
    venue_id VARCHAR(20) PRIMARY KEY,
    venue_name VARCHAR(1000) NOT NULL,
    address VARCHAR(200) NOT NULL,
    capacity INT NOT NULL,
    ward_id VARCHAR(20) NOT NULL,
    city VARCHAR(20) DEFAULT "Hà Nội",
    FOREIGN KEY (ward_id) REFERENCES ward(ward_id),
    CHECK (capacity > 0)
);

CREATE TABLE `event` (
    event_id VARCHAR(20) PRIMARY KEY,
    organizer_id VARCHAR(20) NOT NULL,
    title VARCHAR(1000) NOT NULL,
    image VARCHAR(1000) NOT NULL,
    `desc` VARCHAR(1000) NOT NULL,
    create_type VARCHAR(100),
    FOREIGN KEY (organizer_id)
        REFERENCES organizer(organizer_id)
);

CREATE TABLE event_schedule (
    schedule_id VARCHAR(20) PRIMARY KEY,
    event_id VARCHAR(20) NOT NULL,
    venue_id VARCHAR(20) NOT NULL,
    start_datetime DATETIME NOT NULL,
    end_datetime DATETIME NOT NULL,
    `status` VARCHAR(50) NOT NULL,
    FOREIGN KEY (event_id) REFERENCES `event`(event_id),
    FOREIGN KEY (venue_id) REFERENCES venue(venue_id),
    CHECK (end_datetime > start_datetime)
);

CREATE TABLE artist (
    artist_id VARCHAR(20) PRIMARY KEY,
    artist_name VARCHAR(200) NOT NULL,
    nationality VARCHAR(100) NOT NULL,
    image VARCHAR(1000) NOT NULL,
    bio VARCHAR(1000)
);

CREATE TABLE schedule_artist (
    artist_id VARCHAR(20) NOT NULL,
    schedule_id VARCHAR(20) NOT NULL,
    `role` VARCHAR(100) NOT NULL,
    PRIMARY KEY (artist_id, schedule_id),
    FOREIGN KEY (artist_id) REFERENCES artist(artist_id),
    FOREIGN KEY (schedule_id)
        REFERENCES event_schedule(schedule_id)
);

CREATE TABLE ticket (
    ticket_id VARCHAR(20) PRIMARY KEY,
    schedule_id VARCHAR(20) NOT NULL,
    ticket_name VARCHAR(200) NOT NULL,
    price DECIMAL(15,0) NOT NULL,
    `desc` VARCHAR(2000) NOT NULL,
    total_quantity INT NOT NULL,
    remaining_quantity INT NOT NULL,
    FOREIGN KEY (schedule_id)
        REFERENCES event_schedule(schedule_id),
    CHECK (price >= 0),
    CHECK (total_quantity >= 0),
    CHECK (
        remaining_quantity >= 0
        AND remaining_quantity <= total_quantity
    )
);

CREATE TABLE `order` (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(15,0) NOT NULL DEFAULT 0,
    `status` VARCHAR(100) NOT NULL,
    payment_method VARCHAR(500),
    payment_at DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    CHECK (total_amount >= 0),
    CHECK (`status` IN (
        'Chờ thanh toán',
        'Đã thanh toán',
        'Đã hủy',
        'Đã hoàn tiền'
    ))
);

CREATE TABLE order_detail (
    order_id VARCHAR(20) NOT NULL,
    ticket_id VARCHAR(20) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(15,0) NOT NULL,
    PRIMARY KEY (order_id, ticket_id),
    FOREIGN KEY (order_id) REFERENCES `order`(order_id),
    FOREIGN KEY (ticket_id) REFERENCES ticket(ticket_id),
    CHECK (quantity > 0),
    CHECK (price >= 0)
);

INSERT INTO people (id, `name`, email, phone_number)
VALUES  ('AD01', 'Bùi Ngọc Hải', 'hai.bn@event.vn', '0912345678'),
		('AD02', 'Phạm Hoàng Hiệp', 'hiep.ph@event.vn', '0987654321'),
		('TC001', 'Công ty Triển lãm Việt Nam', 'contact@vietart.vn', '02838999999'),
		('TC002', 'SpaceSpeakers Group', 'contact@spacespeakers.vn', '0912345678'),
		('TC003', 'Việt Show', 'booking@vietshow.vn', '0988888888'),
		('TC004', 'X-Media', 'events@xmedia.com.vn', '02439393399'),
		('KH001', 'Nguyễn Văn Anh', 'nguyenvana@gmail.com', '0933112233'),
		('KH002', 'Trần Thị Bình', 'tranthibinh@gmail.com', '0944223344'),
		('KH003', 'Lê Hoàng Cường', 'cuonglh@gmail.com', '0966334455'),
		('KH004', 'Phạm Minh Đức', 'ducpm@gmail.com', '0977445566'),
		('KH005', 'Vũ Thị Phương Thảo', 'thaovtp@gmail.com', '0988556677');

INSERT INTO `admin` 
VALUES	('AD01'), ('AD02');
INSERT INTO organizer 
VALUES	('TC001', '0101234567', 'Hà Nội'),
		('TC002', '0309876543', 'Hà Nội'),
		('TC003', '0108888888', 'Hà Nội'),
		('TC004', '0109999999', 'Hà Nội');

INSERT INTO customer
VALUES	('KH001', 'Male', '2001-05-15'),
		('KH002', 'Female', '1998-10-20'),
		('KH003', 'Male', '1995-03-12'),
		('KH004', 'Male', '2002-08-25'),
		('KH005', 'Female', '1999-12-01');

INSERT INTO ward 
VALUES 	('W01', 'Từ Liêm'),
		('W02', 'Mỹ Đình'),
		('W03', 'Cửa Nam'),
		('W04', 'Hà Đông');

INSERT INTO venue (venue_id, venue_name, address, capacity, ward_id)
VALUES	('DD01', 'Sân vận động Quốc gia Mỹ Đình', 'Số 1 đường Lê Đức Thọ', 40000, 'W02'),
		('DD02', 'Bảo tàng Hà Nội', 'Đường Phạm Hùng', 2000, 'W01'),
		('DD03', 'Khách sạn JW Marriott Hà Nội', 'Số 8 đường Đỗ Đức Dục', 1000, 'W01'),
		('DD04', 'Trung tâm Hội nghị Quốc gia', 'Số 57 đường Phạm Hùng', 3800, 'W01'),
		('DD05', 'Cung Văn hóa Hữu nghị Việt Xô','Số 91 đường Trần Hưng Đạo', 1200, 'W03');

INSERT INTO `event`
(event_id, organizer_id, title, image, `desc`, create_type)
VALUES	('SK01', 'TC002', 'Đại nhạc hội EDM 2026', 'https://example.com/edm.jpg', 'Đêm nhạc điện tử với nhiều DJ', 'YEARLY'),
		('SK02', 'TC001', 'Triển lãm Mỹ thuật Đương đại', 'https://example.com/art.jpg', 'Triển lãm hội họa và điêu khắc', NULL),
		('SK03', 'TC004', 'Hội thảo Công nghệ AI 2026', 'https://example.com/ai.jpg', 'Hội thảo ứng dụng AI trong doanh nghiệp', NULL),
		('SK04', 'TC003', 'Concert Những bài ca không quên', 'https://example.com/concert.jpg', 'Đêm nhạc trữ tình', 'YEARLY'),
		('SK05', 'TC004', 'Ra mắt sản phẩm Xphone 16', 'https://example.com/xphone.jpg', 'Sự kiện giới thiệu sản phẩm mới', NULL);

INSERT INTO event_schedule (schedule_id, event_id, venue_id, start_datetime, end_datetime, `status`)
VALUES	('SCH01', 'SK01', 'DD01', '2026-10-15 19:00:00', '2026-10-15 23:00:00', 'Đang mở bán'),
		('SCH02', 'SK02', 'DD02', '2026-11-01 09:00:00', '2026-11-10 20:00:00', 'Sắp diễn ra'),
		('SCH03', 'SK03', 'DD03', '2026-09-20 08:30:00', '2026-09-20 17:00:00', 'Đã kết thúc'),
		('SCH04', 'SK04', 'DD01', '2026-12-20 20:00:00', '2026-12-20 22:30:00', 'Đang mở bán'),
		('SCH05', 'SK05', 'DD04', '2026-08-25 10:00:00', '2026-08-25 12:00:00', 'Đã kết thúc'),
		('SCH06', 'SK04', 'DD01', '2027-12-21 20:00:00', '2027-12-21 22:30:00', 'Mở đặt vé sớm');

INSERT INTO artist (artist_id, artist_name, nationality, image, bio)
VALUES	('NS01', 'DJ Tiesto', 'Hà Lan', '', 'DJ'),
		('NS02', 'Nguyễn Ngọc Anh', 'Việt Nam', '', 'Ca sĩ'),
		('NS03', 'Phạm Thu Hà', 'Việt Nam', '', 'Ca sĩ'),
		('NS04', 'Ngô Hồng Quang', 'Việt Nam', '', 'Nghệ sĩ'),
		('NS05', 'MC Minh Phương', 'Việt Nam', '', 'MC'),
		('NS06', 'Lê Duy Ứng', 'Việt Nam', '', 'Họa sĩ'),
		('NS07', 'Vương Văn Thạo', 'Việt Nam', '', 'Nhà điêu khắc'),
		('NS08', 'DJ Alan Walker', 'Anh', '', 'DJ'),
		('NS09', 'Mỹ Tâm', 'Việt Nam', '', 'Ca sĩ'),
		('NS10', 'Huy Tuấn', 'Việt Nam', '', 'Nhạc sĩ');

INSERT INTO schedule_artist 
VALUES	('NS01', 'SCH01', 'DJ chính'),
		('NS08', 'SCH01', 'DJ khách mời'),
		('NS05', 'SCH01', 'MC'),
		('NS06', 'SCH02', 'Họa sĩ'),
		('NS07', 'SCH02', 'Nhà điêu khắc'),
		('NS05', 'SCH03', 'MC'),
		('NS02', 'SCH04', 'Ca sĩ'),
		('NS03', 'SCH04', 'Ca sĩ'),
		('NS04', 'SCH04', 'Nhạc công'),
		('NS09', 'SCH04', 'Ca sĩ'),
		('NS05', 'SCH05', 'MC'),
		('NS10', 'SCH05', 'Cố vấn âm nhạc');

INSERT INTO ticket (schedule_id, ticket_id, ticket_name, price, `desc`, total_quantity, remaining_quantity)
VALUES	('SCH01', 'V001', 'VVIP', 5000000, 'Sát sân khấu', 500, 300),
		('SCH01', 'V002', 'VIP', 2500000, 'Gần sân khấu', 1500, 1199),
		('SCH01', 'V003', 'GA', 800000, 'Khu vực đứng', 2000, 900),
		('SCH02', 'V004', 'VIP All Access', 1500000, 'Vé tham quan VIP', 500, 30),
		('SCH02', 'V005', 'Standard', 300000, 'Vé tham quan tiêu chuẩn', 1500, 300),
		('SCH03', 'V006', 'VIP Business', 2000000, 'Ghế VIP', 100, 10),
		('SCH03', 'V007', 'Standard', 500000, 'Ghế tiêu chuẩn', 900, 30),
		('SCH04', 'V008', 'VVIP', 3500000, 'Hàng ghế đầu', 100, 10),
		('SCH04', 'V009', 'VIP', 1800000, 'Khán đài tầng 1', 1500, 150),
		('SCH04', 'V010', 'Phổ thông', 400000, 'Khán đài tầng 2', 2200, 1000),
		('SCH05', 'V011', 'VIP Invite', 1200000, 'Vé VIP', 200, 0),
		('SCH05', 'V012', 'Standard', 200000, 'Vé tiêu chuẩn', 1000, 30),
		('SCH06', 'V013', 'VIP', 1800000, 'Khán đài tầng 1', 1500, 1500),
		('SCH06', 'V014', 'Phổ thông', 400000, 'Khán đài tầng 2', 2200, 2200);

INSERT INTO `order` (order_id, customer_id, created_at, total_amount, `status`, payment_method, payment_at)
VALUES	('DH001', 'KH001', '2026-09-01 08:30:00', 3400000, 'Đã thanh toán', 'Momo', '2026-09-01 08:35:00'),
		('DH002', 'KH002', '2026-09-02 14:15:00', 300000, 'Chờ thanh toán', 'Chuyển khoản', NULL),
		('DH003', 'KH003', '2026-09-03 20:00:00', 2000000, 'Đã thanh toán', 'VNPay', '2026-09-03 20:05:00'),
		('DH004', 'KH004', '2026-09-04 09:00:00', 14400000, 'Đã hủy', 'Thẻ tín dụng', '2026-09-04 10:00:00'),
		('DH005', 'KH005', '2026-09-04 18:45:00', 400000, 'Đã thanh toán', 'Momo', '2026-09-04 18:50:00');

INSERT INTO order_detail (order_id, ticket_id, quantity, price)
VALUES	('DH001', 'V002', 1, 2500000),
		('DH001', 'V005', 3, 300000),
		('DH002', 'V005', 1, 300000),
		('DH003', 'V006', 1, 2000000),
		('DH004', 'V009', 6, 1800000),
		('DH004', 'V011', 3, 1200000),
		('DH005', 'V012', 2, 200000);

SELECT * FROM people;
SELECT p.*
FROM people p
JOIN `admin` a ON p.id = a.admin_id;
SELECT p.*, o.address, o.tax_code
FROM people p
JOIN organizer o ON p.id = o.organizer_id;
SELECT p.*, c.gender, c.date_of_birth
FROM people p
JOIN customer c ON p.id = c.customer_id;
SELECT * FROM ward;
SELECT v.venue_id, v.venue_name, v.address, w.ward_name, city, v.capacity
FROM venue v
JOIN ward w ON v.ward_id = w.ward_id;
SELECT * FROM `event`;
SELECT * FROM event_schedule;
SELECT * FROM artist;
SELECT * FROM schedule_artist;
SELECT * FROM ticket;
SELECT * FROM `order`;
SELECT * FROM order_detail;
