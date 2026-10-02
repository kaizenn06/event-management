CREATE DATABASE IF NOT EXISTS event_tickets;
USE  event_tickets;
DROP TABLE IF EXISTS order_detail;
DROP TABLE IF EXISTS `order`;
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
    id 				VARCHAR(20) PRIMARY KEY,
    `name` 			VARCHAR(1000) NOT NULL,
    email 			VARCHAR(200) NOT NULL UNIQUE,
    phone_number 	VARCHAR(15) NOT NULL,
    `password` 		VARCHAR(255) NOT NULL
);

CREATE TABLE `admin` (
    admin_id 		VARCHAR(20) PRIMARY KEY,
    FOREIGN KEY (admin_id) REFERENCES people(id)
);

CREATE TABLE organizer (
    organizer_id 	VARCHAR(20) PRIMARY KEY,
    tax_code 		VARCHAR(100) NOT NULL UNIQUE,
    address 		VARCHAR(200) NOT NULL,
    FOREIGN KEY (organizer_id) REFERENCES people(id)
);

CREATE TABLE customer (
    customer_id 	VARCHAR(20) PRIMARY KEY,
    gender 			VARCHAR(10) NOT NULL,
    date_of_birth 	DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES people(id),
    CHECK (gender IN ('Male', 'Female', 'Other')) -- [SỬA] giới hạn giá trị giới tính
);

CREATE TABLE ward (
    ward_id 		VARCHAR(20) PRIMARY KEY,
    ward_name 		VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE venue (
    venue_id 		VARCHAR(20) PRIMARY KEY,
    venue_name 		VARCHAR(1000) NOT NULL,
    address 		VARCHAR(200) NOT NULL,
    capacity 		INT NOT NULL,
    ward_id 		VARCHAR(20) NOT NULL,
    city 			VARCHAR(20) NOT NULL DEFAULT 'Hà Nội',
    FOREIGN KEY (ward_id) REFERENCES ward(ward_id),
    CHECK (capacity > 0)
);

CREATE TABLE `event` (
    event_id 		VARCHAR(20) PRIMARY KEY,
    organizer_id 	VARCHAR(20) NOT NULL,
    title 			VARCHAR(1000) NOT NULL,
    image 			VARCHAR(1000) NOT NULL,
    `desc` 			VARCHAR(1000) NOT NULL,
    create_type 	VARCHAR(100),
    `status` 		VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    FOREIGN KEY (organizer_id) REFERENCES organizer(organizer_id),
	CHECK (`status` IN ('PENDING', 'APPROVED', 'REJECTED')),
    CHECK (create_type IN ('WEEKLY', 'MONTHLY', 'YEARLY')) -- [SỬA] NULL = diễn ra 1 lần
);

CREATE TABLE event_schedule (
    schedule_id 	VARCHAR(20) PRIMARY KEY,
    event_id 		VARCHAR(20) NOT NULL,
    venue_id 		VARCHAR(20) NOT NULL,
    start_datetime 	DATETIME NOT NULL,
    end_datetime 	DATETIME NOT NULL,
    `status` 		VARCHAR(50) NOT NULL,
    FOREIGN KEY (event_id) REFERENCES `event`(event_id),
    FOREIGN KEY (venue_id) REFERENCES venue(venue_id),
    CHECK (end_datetime > start_datetime),
    CHECK (`status` IN ('Mở đặt vé sớm', 'Đang mở bán', 'Sắp diễn ra', 'Đã kết thúc')) -- [SỬA] giới hạn trạng thái suất diễn
);

CREATE TABLE artist (
    artist_id 		VARCHAR(20) PRIMARY KEY,
    artist_name 	VARCHAR(200) NOT NULL,
    nationality 	VARCHAR(100) NOT NULL,
    image 			VARCHAR(1000) NOT NULL,
    bio 			VARCHAR(1000)
);

CREATE TABLE schedule_artist (
    artist_id 		VARCHAR(20) NOT NULL,
    schedule_id 	VARCHAR(20) NOT NULL,
    `role` 			VARCHAR(100) NOT NULL,
    PRIMARY KEY (artist_id, schedule_id),
    FOREIGN KEY (artist_id) REFERENCES artist(artist_id),
    FOREIGN KEY (schedule_id) REFERENCES event_schedule(schedule_id)
);

CREATE TABLE ticket (
    ticket_id 			VARCHAR(20) PRIMARY KEY,
    schedule_id 		VARCHAR(20) NOT NULL,
    ticket_name 		VARCHAR(200) NOT NULL,
    price 				DECIMAL(15,0) NOT NULL,
    `desc`				VARCHAR(2000) NOT NULL,
    total_quantity 		INT NOT NULL,
    remaining_quantity 	INT NOT NULL,
    FOREIGN KEY (schedule_id) REFERENCES event_schedule(schedule_id),
    CHECK (price >= 0),
    UNIQUE (schedule_id, ticket_name),
    CHECK (total_quantity >= 0),
    CHECK (
        remaining_quantity >= 0
        AND remaining_quantity <= total_quantity
    )
);

CREATE TABLE `order` (
    order_id 		VARCHAR(20) PRIMARY KEY,
    customer_id 	VARCHAR(20) NOT NULL,
    created_at 		DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount 	DECIMAL(15,0) NOT NULL, -- [SỬA] bỏ DEFAULT 0 vì mâu thuẫn với CHECK (total_amount > 0)
    `status` 		VARCHAR(100) NOT NULL,
    payment_method 	VARCHAR(500),
    payment_at 		DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    CHECK (total_amount > 0),
    CHECK (`status` IN ('Chờ thanh toán', 'Đã thanh toán', 'Đã hủy', 'Đã hoàn tiền')),
    CHECK ( -- [SỬA] trạng thái phải khớp với payment_at
        (`status` IN ('Đã thanh toán', 'Đã hoàn tiền') AND payment_at IS NOT NULL)
        OR (`status` IN ('Chờ thanh toán', 'Đã hủy') AND payment_at IS NULL)
    )
);

CREATE TABLE order_detail (
    order_id 		VARCHAR(20) NOT NULL,
    ticket_id 		VARCHAR(20) NOT NULL,
    quantity 		INT NOT NULL,
    price 			DECIMAL(15,0) NOT NULL,
    PRIMARY KEY (order_id, ticket_id),
    FOREIGN KEY (order_id) REFERENCES `order`(order_id),
    FOREIGN KEY (ticket_id) REFERENCES ticket(ticket_id),
    CHECK (quantity > 0),
    CHECK (price >= 0)
);

INSERT INTO people (id, `name`, email, phone_number, `password`)
VALUES
('AD01', 'Bùi Ngọc Hải', 'admin01@event.vn', '0901000001', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),
('AD02', 'Phạm Hoàng Hiệp', 'admin02@event.vn', '0901000002', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),

('TC001', 'Công ty Cổ phần Triển lãm Việt Nam', 'contact@vietart.vn', '0902000001', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),
('TC002', 'SpaceSpeakers Group Entertainment', 'contact@spacespeakers.vn', '0902000002', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),
('TC003', 'Công ty Truyền thông Việt Show', 'booking@vietshow.vn', '0902000003', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),
('TC004', 'Tập đoàn X-Media', 'events@xmedia.vn', '0902000004', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),
('TC005', 'Công ty Sự kiện Sao Việt', 'contact@saoviet.vn', '0902000005', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),
('TC006', 'Hanoi Event Production', 'hello@hep.vn', '0902000006', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),

('KH001', 'Nguyễn Văn An', 'an.nguyen@gmail.com', '0911000001', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),
('KH002', 'Trần Thị Bình', 'binh.tran@gmail.com', '0911000002', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),
('KH003', 'Lê Hoàng Cường', 'cuong.le@gmail.com', '0911000003', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),
('KH004', 'Phạm Minh Đức', 'duc.pham@gmail.com', '0911000004', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),
('KH005', 'Vũ Ngọc Hà', 'ha.vu@gmail.com', '0911000005', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),
('KH006', 'Đỗ Quang Huy', 'huy.do@gmail.com', '0911000006', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),
('KH007', 'Nguyễn Thu Lan', 'lan.nguyen@gmail.com', '0911000007', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),
('KH008', 'Phan Anh Minh', 'minh.phan@gmail.com', '0911000008', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),
('KH009', 'Hoàng Thu Trang', 'trang.hoang@gmail.com', '0911000009', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),
('KH010', 'Bùi Quốc Việt', 'viet.bui@gmail.com', '0911000010', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),
('KH011', 'Nguyễn Khánh Linh', 'linh.nguyen@gmail.com', '0911000011', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK'),
('KH012', 'Trần Đức Long', 'long.tran@gmail.com', '0911000012', '$2b$12$fHd7KgQAy6YPgvHbmtaIEONbmRAoplerJ33TwvNWkC2QwwcaNhOJK');

INSERT INTO `admin` (admin_id)
VALUES
('AD01'),
('AD02');

INSERT INTO organizer (organizer_id, address, tax_code)
VALUES
('TC001', '63 Phạm Ngọc Thạch, Đống Đa, Hà Nội', '0101000001'),
('TC002', '12 Phan Đình Phùng, Ba Đình, Hà Nội', '0101000002'),
('TC003', '54 Liễu Giai, Ba Đình, Hà Nội', '0101000003'),
('TC004', '13 Hai Bà Trưng, Hoàn Kiếm, Hà Nội', '0101000004'),
('TC005', '25 Nguyễn Trãi, Thanh Xuân, Hà Nội', '0101000005'),
('TC006', '100 Trần Duy Hưng, Cầu Giấy, Hà Nội', '0101000006');

INSERT INTO customer (customer_id, gender, date_of_birth)
VALUES
('KH001', 'Male',   '2001-05-15'),
('KH002', 'Female', '1998-10-20'),
('KH003', 'Male',   '1995-03-12'),
('KH004', 'Male',   '2002-08-25'),
('KH005', 'Female', '1999-12-01'),
('KH006', 'Male',   '2000-07-18'),
('KH007', 'Female', '2001-11-22'),
('KH008', 'Male',   '1997-02-14'),
('KH009', 'Female', '2003-06-30'),
('KH010', 'Male',   '1996-09-09'),
('KH011', 'Female', '2002-01-27'),
('KH012', 'Male',   '1999-04-05');

INSERT INTO ward (ward_id, ward_name)
VALUES
('P001', 'Hoàn Kiếm'),
('P002', 'Cửa Nam'),
('P003', 'Ba Đình'),
('P004', 'Ngọc Hà'),
('P005', 'Giảng Võ'),
('P006', 'Hai Bà Trưng'),
('P007', 'Vĩnh Tuy'),
('P008', 'Bạch Mai'),
('P009', 'Đống Đa'),
('P010', 'Kim Liên'),
('P011', 'Văn Miếu - Quốc Tử Giám'),
('P012', 'Láng'),
('P013', 'Ô Chợ Dừa'),
('P014', 'Hồng Hà'),
('P015', 'Lĩnh Nam'),
('P016', 'Hoàng Mai'),
('P017', 'Vĩnh Hưng'),
('P018', 'Tương Mai'),
('P019', 'Định Công'),
('P020', 'Hoàng Liệt'),
('P021', 'Yên Sở'),
('P022', 'Thanh Xuân'),
('P023', 'Khương Đình'),
('P024', 'Phương Liệt'),
('P025', 'Cầu Giấy'),
('P026', 'Nghĩa Đô'),
('P027', 'Yên Hòa'),
('P028', 'Tây Hồ'),
('P029', 'Phú Thượng'),
('P030', 'Tây Tựu'),
('P031', 'Phú Diễn'),
('P032', 'Xuân Đỉnh'),
('P033', 'Đông Ngạc'),
('P034', 'Thượng Cát'),
('P035', 'Từ Liêm'),
('P036', 'Xuân Phương'),
('P037', 'Tây Mỗ'),
('P038', 'Đại Mỗ'),
('P039', 'Long Biên'),
('P040', 'Bồ Đề'),
('P041', 'Việt Hưng'),
('P042', 'Phúc Lợi'),
('P043', 'Hà Đông'),
('P044', 'Dương Nội'),
('P045', 'Yên Nghĩa'),
('P046', 'Phú Lương'),
('P047', 'Kiến Hưng'),
('P048', 'Thanh Liệt'),
('P049', 'Chương Mỹ'),
('P050', 'Sơn Tây'),
('P051', 'Tùng Thiện');

INSERT INTO venue
(venue_id, venue_name, address, capacity, ward_id, city)
VALUES
('DD01', 'Nhà hát Lớn Hà Nội', 'Số 1 Tràng Tiền', 600, 'P001', 'Hà Nội'),
('DD02', 'Cung Văn hóa Hữu nghị Việt Xô', 'Số 91 Trần Hưng Đạo', 1200, 'P001', 'Hà Nội'),
('DD03', 'Sân vận động Mỹ Đình', 'Số 1 Lê Đức Thọ', 40000, 'P035', 'Hà Nội'),
('DD04', 'Trung tâm Hội nghị Quốc gia', 'Số 57 Phạm Hùng', 3800, 'P035', 'Hà Nội'),
('DD05', 'JW Marriott Hà Nội', 'Số 8 Đỗ Đức Dục', 1000, 'P035', 'Hà Nội'),
('DD06', 'Bảo tàng Hà Nội', 'Đường Phạm Hùng', 2000, 'P035', 'Hà Nội'),
('DD07', 'Hà Nội Creative City', 'Số 1 Lương Yên', 3000, 'P007', 'Hà Nội'),
('DD08', 'Trung tâm Triển lãm Quốc gia', 'Đường Cổ Loa', 10000, 'P041', 'Hà Nội'),
('DD09', 'Cung Thể thao Quần Ngựa', 'Văn Cao', 5000, 'P003', 'Hà Nội'),
('DD10', 'Trung tâm Văn hóa Hà Nội', 'Đường Phúc Diễn', 2500, 'P031', 'Hà Nội');
 
 INSERT INTO `event`
(event_id, organizer_id, title, image, `desc`, create_type, `status`)
VALUES
('SK01', 'TC002',
 'Đại nhạc hội EDM 2026',
 'https://example.com/edm2026.jpg',
 'Đêm nhạc điện tử quy mô lớn với nhiều DJ quốc tế và Việt Nam.',
 'YEARLY', 'APPROVED'),

('SK02', 'TC001',
 'Triển lãm Mỹ thuật Đương đại',
 'https://example.com/art2026.jpg',
 'Triển lãm hội họa và điêu khắc của các nghệ sĩ đương đại.',
 NULL, 'APPROVED'),

('SK03', 'TC004',
 'Hội thảo Công nghệ AI 2026',
 'https://example.com/ai2026.jpg',
 'Hội thảo về ứng dụng trí tuệ nhân tạo trong doanh nghiệp.',
 NULL, 'APPROVED'),

('SK04', 'TC003',
 'Concert Những bài ca không quên',
 'https://example.com/concert2026.jpg',
 'Đêm nhạc trữ tình với nhiều ca sĩ nổi tiếng.',
 'YEARLY', 'APPROVED'),

('SK05', 'TC004',
 'Ra mắt sản phẩm Xphone 16',
 'https://example.com/xphone16.jpg',
 'Sự kiện giới thiệu sản phẩm công nghệ mới.',
 NULL, 'APPROVED'),

('SK06', 'TC005',
 'Vietnam Startup Summit 2026',
 'https://example.com/startup.jpg',
 'Sự kiện kết nối startup, nhà đầu tư và doanh nghiệp công nghệ.',
 'YEARLY', 'APPROVED'),

('SK07', 'TC006',
 'Hanoi Music Festival',
 'https://example.com/musicfest.jpg',
 'Lễ hội âm nhạc quy tụ nhiều nghệ sĩ trẻ.',
 'MONTHLY', 'APPROVED'),

('SK08', 'TC001',
 'Tuần lễ Nghệ thuật Hà Nội',
 'https://example.com/artweek.jpg',
 'Tuần lễ triển lãm nghệ thuật và giao lưu với nghệ sĩ.',
 'WEEKLY', 'APPROVED'),

('SK09', 'TC005',
 'Hội chợ Công nghệ Việt Nam',
 'https://example.com/techfair.jpg',
 'Hội chợ giới thiệu các sản phẩm công nghệ mới.',
 'MONTHLY', 'APPROVED'),

('SK10', 'TC003',
 'Live Show Giai điệu Mùa Thu',
 'https://example.com/autumn.jpg',
 'Chương trình âm nhạc đặc biệt dành cho khán giả yêu nhạc.',
 NULL, 'APPROVED'),

('SK11', 'TC006',
 'Tech Career Day 2026',
 'https://example.com/career.jpg',
 'Ngày hội tuyển dụng dành cho sinh viên công nghệ.',
 NULL, 'APPROVED'),

('SK12', 'TC002',
 'Summer EDM Festival 2027',
 'https://example.com/summer-edm.jpg',
 'Lễ hội EDM mùa hè với nhiều DJ trong nước và quốc tế.',
 NULL, 'APPROVED'),
 
 ('SK13', 'TC005',
 'Hội thảo AI dành cho sinh viên 2027',
 'https://example.com/ai-student.jpg',
 'Hội thảo chia sẻ kiến thức và ứng dụng AI cho sinh viên.',
 NULL, 'PENDING'),

('SK14', 'TC006',
 'Triển lãm Công nghệ tương lai 2027',
 'https://example.com/future-tech.jpg',
 'Triển lãm các sản phẩm và giải pháp công nghệ mới.',
 NULL, 'REJECTED');
 
 INSERT INTO event_schedule
(schedule_id, event_id, venue_id, start_datetime, end_datetime, `status`)
VALUES

('SCH01', 'SK01', 'DD08',
 '2026-10-15 19:00:00',
 '2026-10-15 23:00:00',
 'Đang mở bán'),

('SCH02', 'SK02', 'DD02',
 '2026-11-01 09:00:00',
 '2026-11-10 20:00:00',
 'Sắp diễn ra'),

('SCH03', 'SK03', 'DD05',
 '2026-09-20 08:30:00',
 '2026-09-20 17:00:00',
 'Đã kết thúc'),

('SCH04', 'SK04', 'DD09',
 '2026-12-20 20:00:00',
 '2026-12-20 22:30:00',
 'Đang mở bán'),

('SCH05', 'SK04', 'DD09',
 '2027-12-21 19:00:00',
 '2027-12-21 23:00:00',
 'Mở đặt vé sớm'),

('SCH06', 'SK05', 'DD03',
 '2026-08-25 10:00:00',
 '2026-08-25 12:00:00',
 'Đã kết thúc'),

('SCH07', 'SK06', 'DD03',
 '2026-10-05 08:00:00',
 '2026-10-05 18:00:00',
 'Đang mở bán'),

('SCH08', 'SK06', 'DD03',
 '2026-10-06 08:00:00',
 '2026-10-06 17:00:00',
 'Đang mở bán'),

('SCH09', 'SK07', 'DD08',
 '2026-11-15 16:00:00',
 '2026-11-15 23:00:00',
 'Sắp diễn ra'),

('SCH10', 'SK08', 'DD06',
 '2026-12-01 09:00:00',
 '2026-12-07 21:00:00',
 'Sắp diễn ra'),

('SCH11', 'SK09', 'DD10',
 '2026-12-10 09:00:00',
 '2026-12-12 18:00:00',
 'Sắp diễn ra'),

('SCH12', 'SK10', 'DD07',
 '2026-10-25 20:00:00',
 '2026-10-25 22:30:00',
 'Đang mở bán'),

('SCH13', 'SK10', 'DD07',
 '2027-04-20 20:00:00',
 '2027-04-20 22:30:00',
 'Mở đặt vé sớm'),

('SCH14', 'SK11', 'DD09',
 '2026-11-20 08:00:00',
 '2026-11-20 17:00:00',
 'Sắp diễn ra'),

('SCH15', 'SK12', 'DD08',
 '2027-06-15 18:00:00',
 '2027-06-15 23:00:00',
 'Mở đặt vé sớm'),

('SCH16', 'SK12', 'DD08',
 '2027-06-16 18:00:00',
 '2027-06-16 23:00:00',
 'Mở đặt vé sớm'),

('SCH17', 'SK02', 'DD06',
 '2026-11-12 09:00:00',
 '2026-11-15 20:00:00',
 'Sắp diễn ra'),

('SCH18', 'SK08', 'DD06',
 '2027-01-10 09:00:00',
 '2027-01-15 21:00:00',
 'Mở đặt vé sớm');
 
 INSERT INTO artist
(artist_id, artist_name, nationality, image, bio)
VALUES

('NS01', 'DJ Tiesto', 'Hà Lan',
 'https://example.com/tiesto.jpg',
 'DJ và nhà sản xuất âm nhạc điện tử quốc tế.'),

('NS02', 'Alan Walker', 'Na Uy',
 'https://example.com/alanwalker.jpg',
 'DJ và nhà sản xuất âm nhạc điện tử.'),

('NS03', 'Nguyễn Ngọc Anh', 'Việt Nam',
 'https://example.com/ngocanh.jpg',
 'Ca sĩ Việt Nam với phong cách âm nhạc giàu cảm xúc.'),

('NS04', 'Phạm Thu Hà', 'Việt Nam',
 'https://example.com/phamthuha.jpg',
 'Ca sĩ theo đuổi dòng nhạc bán cổ điển.'),

('NS05', 'Mỹ Tâm', 'Việt Nam',
 'https://example.com/mytam.jpg',
 'Ca sĩ nhạc pop Việt Nam.'),

('NS06', 'Huy Tuấn', 'Việt Nam',
 'https://example.com/huytuan.jpg',
 'Nhạc sĩ và giám đốc âm nhạc.'),

('NS07', 'Ngô Hồng Quang', 'Việt Nam',
 'https://example.com/hongquang.jpg',
 'Nghệ sĩ âm nhạc dân tộc đương đại.'),

('NS08', 'Lê Duy Ứng', 'Việt Nam',
 'https://example.com/leduyung.jpg',
 'Họa sĩ và nhà điêu khắc.'),

('NS09', 'Vương Văn Thạo', 'Việt Nam',
 'https://example.com/vuongvanthao.jpg',
 'Nghệ sĩ điêu khắc đương đại.'),

('NS10', 'Minh Phương', 'Việt Nam',
 'https://example.com/minhphuong.jpg',
 'MC chuyên nghiệp.'),

('NS11', 'Sơn Tùng M-TP', 'Việt Nam',
 'https://example.com/sontung.jpg',
 'Ca sĩ và nhà sản xuất âm nhạc.'),

('NS12', 'Đen Vâu', 'Việt Nam',
 'https://example.com/denvau.jpg',
 'Nghệ sĩ rap Việt Nam.'),

('NS13', 'JustaTee', 'Việt Nam',
 'https://example.com/justatee.jpg',
 'Ca sĩ và nhà sản xuất âm nhạc.'),

('NS14', 'Binz', 'Việt Nam',
 'https://example.com/binz.jpg',
 'Rapper và nghệ sĩ hip-hop.'),

('NS15', 'Touliver', 'Việt Nam',
 'https://example.com/touliver.jpg',
 'Nhà sản xuất âm nhạc và DJ.');
 
 INSERT INTO schedule_artist
(artist_id, schedule_id, `role`)
VALUES

('NS01', 'SCH01', 'DJ Headliner'),
('NS02', 'SCH01', 'DJ khách mời'),
('NS10', 'SCH01', 'MC'),

('NS08', 'SCH02', 'Họa sĩ'),
('NS09', 'SCH02', 'Nhà điêu khắc'),

('NS10', 'SCH03', 'MC'),
('NS06', 'SCH03', 'Diễn giả'),

('NS05', 'SCH04', 'Ca sĩ chính'),
('NS03', 'SCH04', 'Ca sĩ khách mời'),
('NS04', 'SCH04', 'Ca sĩ khách mời'),
('NS07', 'SCH04', 'Nhạc công'),

('NS05', 'SCH05', 'Ca sĩ chính'),
('NS03', 'SCH05', 'Ca sĩ khách mời'),
('NS06', 'SCH05', 'Giám đốc âm nhạc'),

('NS10', 'SCH06', 'MC'),
('NS06', 'SCH06', 'Đại diện sản phẩm'),

('NS11', 'SCH07', 'Diễn giả'),
('NS14', 'SCH07', 'Diễn giả'),
('NS15', 'SCH07', 'Giám đốc âm nhạc'),

('NS12', 'SCH08', 'Diễn giả'),
('NS13', 'SCH08', 'Diễn giả'),

('NS11', 'SCH09', 'Nghệ sĩ biểu diễn'),
('NS12', 'SCH09', 'Nghệ sĩ biểu diễn'),
('NS14', 'SCH09', 'Nghệ sĩ biểu diễn'),

('NS08', 'SCH10', 'Họa sĩ'),
('NS09', 'SCH10', 'Nhà điêu khắc'),

('NS10', 'SCH11', 'MC'),
('NS15', 'SCH11', 'Demo sản phẩm'),

('NS05', 'SCH12', 'Ca sĩ chính'),
('NS06', 'SCH12', 'Giám đốc âm nhạc'),

('NS05', 'SCH13', 'Ca sĩ chính'),
('NS03', 'SCH13', 'Ca sĩ khách mời'),

('NS10', 'SCH14', 'MC'),
('NS11', 'SCH14', 'Diễn giả'),

('NS01', 'SCH15', 'DJ Headliner'),
('NS02', 'SCH15', 'DJ khách mời'),
('NS15', 'SCH15', 'Producer'),

('NS01', 'SCH16', 'DJ Headliner'),
('NS02', 'SCH16', 'DJ khách mời'),

('NS08', 'SCH17', 'Họa sĩ'),
('NS09', 'SCH17', 'Nhà điêu khắc'),

('NS08', 'SCH18', 'Họa sĩ'),
('NS09', 'SCH18', 'Nhà điêu khắc');

INSERT INTO ticket
(schedule_id, ticket_id, ticket_name, price, `desc`,
 total_quantity, remaining_quantity)
VALUES

-- SCH01
('SCH01', 'V001', 'VVIP', 5000000,
 'Khu vực sát sân khấu và quà tặng đặc biệt',
 500, 300),

('SCH01', 'V002', 'VIP', 2500000,
 'Khu vực gần sân khấu',
 1500, 1000),

('SCH01', 'V003', 'GA - Phổ thông', 800000,
 'Khu vực khán giả chung',
 5000, 3000),

-- SCH02
('SCH02', 'V004', 'VIP All Access', 1500000,
 'Tham quan toàn bộ khu vực triển lãm',
 500, 350),

('SCH02', 'V005', 'Standard', 300000,
 'Vé tham quan tiêu chuẩn',
 2000, 1200),

-- SCH03
('SCH03', 'V006', 'VIP Business', 2000000,
 'Ghế hàng đầu và giao lưu diễn giả',
 100, 30),

('SCH03', 'V007', 'Standard', 500000,
 'Khu vực hội trường chính',
 900, 450),

-- SCH04
('SCH04', 'V008', 'VVIP', 3500000,
 'Hàng ghế đầu trung tâm sân khấu',
 100, 40),

('SCH04', 'V009', 'VIP', 1800000,
 'Khu vực khán đài tầng 1',
 1500, 700),

('SCH04', 'V010', 'Phổ thông', 400000,
 'Khu vực khán đài tầng 2',
 3000, 1700),

-- SCH05
('SCH05', 'V011', 'VVIP', 3500000,
 'Hàng ghế đầu trung tâm',
 100, 100),

('SCH05', 'V012', 'VIP', 1800000,
 'Khu vực VIP',
 1500, 1498),

('SCH05', 'V013', 'Phổ thông', 400000,
 'Khu vực khán giả chung',
 3000, 3000),

-- SCH06
('SCH06', 'V014', 'VIP Invite', 1200000,
 'Khu vực khách mời',
 200, 0),

('SCH06', 'V015', 'Standard', 200000,
 'Khu vực khán giả chung',
 1000, 0),

-- SCH07
('SCH07', 'V016', 'VIP', 2500000,
 'Khu vực VIP',
 500, 320),

('SCH07', 'V017', 'Standard', 700000,
 'Vé tham dự hội nghị',
 2000, 1400),

-- SCH08
('SCH08', 'V018', 'VIP', 2500000,
 'Khu vực VIP',
 500, 400),

('SCH08', 'V019', 'Standard', 700000,
 'Vé tham dự hội nghị',
 2000, 1800),

-- SCH09
('SCH09', 'V020', 'VIP', 1800000,
 'Khu vực gần sân khấu',
 1000, 600),

('SCH09', 'V021', 'Standard', 600000,
 'Khu vực phổ thông',
 5000, 3000),

-- SCH10
('SCH10', 'V022', 'VIP', 1000000,
 'Vé tham quan VIP',
 500, 400),

('SCH10', 'V023', 'Standard', 300000,
 'Vé tham quan thường',
 2500, 2000),

-- SCH11
('SCH11', 'V024', 'Business', 1000000,
 'Khu vực doanh nghiệp',
 500, 350),

('SCH11', 'V025', 'Student', 100000,
 'Vé dành cho sinh viên',
 2000, 1400),

-- SCH12
('SCH12', 'V026', 'VIP', 2000000,
 'Khu vực VIP',
 800, 300),

('SCH12', 'V027', 'Standard', 500000,
 'Khu vực phổ thông',
 2000, 900),

-- SCH13
('SCH13', 'V028', 'VIP', 2200000,
 'Khu vực VIP',
 800, 800),

('SCH13', 'V029', 'Standard', 500000,
 'Khu vực phổ thông',
 2000, 2000),

-- SCH14
('SCH14', 'V030', 'Business', 800000,
 'Khu vực doanh nghiệp',
 500, 400),

('SCH14', 'V031', 'Student', 100000,
 'Vé sinh viên',
 2000, 1500),

-- SCH15
('SCH15', 'V032', 'VVIP', 5000000,
 'Khu vực sát sân khấu',
 500, 500),

('SCH15', 'V033', 'VIP', 2500000,
 'Khu vực VIP',
 1500, 1499),

('SCH15', 'V034', 'Standard', 800000,
 'Khu vực phổ thông',
 5000, 5000),

-- SCH16
('SCH16', 'V035', 'VIP', 2500000,
 'Khu vực VIP',
 1500, 1500),

('SCH16', 'V036', 'Standard', 800000,
 'Khu vực phổ thông',
 5000, 5000),

-- SCH17
('SCH17', 'V037', 'VIP All Access', 1500000,
 'Tham quan toàn bộ triển lãm',
 500, 500),

('SCH17', 'V038', 'Standard', 300000,
 'Vé tham quan tiêu chuẩn',
 2000, 2000),

-- SCH18
('SCH18', 'V039', 'VIP All Access', 1500000,
 'Tham quan toàn bộ triển lãm',
 500, 500),

('SCH18', 'V040', 'Standard', 300000,
 'Vé tham quan tiêu chuẩn',
 2000, 2000);
 
 INSERT INTO `order`
(order_id, customer_id, created_at, total_amount,
 `status`, payment_method, payment_at)
VALUES

('DH001', 'KH001', '2026-09-01 08:30:00',
 3400000, 'Đã thanh toán', 'Momo',
 '2026-09-01 08:35:00'),

('DH002', 'KH002', '2026-09-02 14:15:00',
 300000, 'Chờ thanh toán', 'Chuyển khoản ngân hàng',
 NULL),

('DH003', 'KH003', '2026-09-03 20:00:00',
 2000000, 'Đã thanh toán', 'VNPay',
 '2026-09-03 20:05:00'),

('DH004', 'KH004', '2026-09-04 09:00:00',
 21300000, 'Đã hủy', 'Thẻ tín dụng',
 NULL),

('DH005', 'KH005', '2026-09-04 18:45:00',
 3600000, 'Đã thanh toán', 'Momo',
 '2026-09-04 18:50:00'),

('DH006', 'KH006', '2026-09-05 10:20:00',
 5000000, 'Đã thanh toán', 'VNPay',
 '2026-09-05 10:25:00'),

('DH007', 'KH007', '2026-09-05 15:30:00',
 1800000, 'Đã hoàn tiền', 'Momo',
 '2026-09-05 15:35:00'),

('DH008', 'KH008', '2026-09-06 11:00:00',
 2500000, 'Chờ thanh toán', 'Chuyển khoản ngân hàng',
 NULL),

('DH009', 'KH009', '2026-09-07 09:10:00',
 1400000, 'Đã thanh toán', 'VNPay',
 '2026-09-07 09:15:00'),

('DH010', 'KH010', '2026-09-07 16:00:00',
 1800000, 'Đã thanh toán', 'Momo',
 '2026-09-07 16:05:00'),

('DH011', 'KH011', '2026-09-08 12:30:00',
 300000, 'Đã hủy', 'Momo',
 NULL),

('DH012', 'KH012', '2026-09-08 19:20:00',
 2000000, 'Đã thanh toán', 'VNPay',
 '2026-09-08 19:25:00'),

('DH013', 'KH001', '2026-09-09 08:00:00',
 1600000, 'Đã thanh toán', 'Momo',
 '2026-09-09 08:05:00'),

('DH014', 'KH003', '2026-09-09 13:45:00',
 1000000, 'Chờ thanh toán', 'Chuyển khoản ngân hàng',
 NULL),

('DH015', 'KH005', '2026-09-10 21:00:00',
 2500000, 'Đã thanh toán', 'VNPay',
 '2026-09-10 21:05:00');
 
 INSERT INTO order_detail
(order_id, ticket_id, quantity, price)
VALUES

('DH001', 'V002', 1, 2500000),
('DH001', 'V005', 3, 300000),

('DH002', 'V005', 1, 300000),

('DH003', 'V006', 1, 2000000),

('DH004', 'V009', 6, 1800000),
('DH004', 'V011', 3, 3500000),

('DH005', 'V012', 2, 1800000),

('DH006', 'V001', 1, 5000000),

('DH007', 'V009', 1, 1800000),

('DH008', 'V016', 1, 2500000),

('DH009', 'V017', 2, 700000),

('DH010', 'V020', 1, 1800000),

('DH011', 'V023', 1, 300000),

('DH012', 'V026', 1, 2000000),

('DH013', 'V010', 4, 400000),

('DH014', 'V027', 2, 500000),

('DH015', 'V033', 1, 2500000);

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
