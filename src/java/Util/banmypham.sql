-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 29, 2025 lúc 08:48 AM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `banmypham`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `brands`
--

CREATE TABLE `brands` (
  `brand_id` int(11) NOT NULL,
  `brand_name` varchar(100) NOT NULL,
  `country` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `brands`
--

INSERT INTO `brands` (`brand_id`, `brand_name`, `country`) VALUES
(1, 'Innisfree', 'Hàn Quốc'),
(2, 'La Roche-Posay', 'Pháp'),
(3, 'M.A.C', 'Canada'),
(4, 'Maybelline', 'Mỹ'),
(5, 'The Ordinary', 'Canada'),
(6, 'L\'Oreal Paris', 'Pháp'),
(7, 'Shiseido', 'Nhật Bản'),
(8, 'Paula\'s Choice', 'Mỹ'),
(9, 'Vichy', 'Pháp');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `carts`
--

CREATE TABLE `carts` (
  `cart_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `session_id` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cart_items`
--

CREATE TABLE `cart_items` (
  `cart_item_id` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL CHECK (`quantity` > 0),
  `unit_price` decimal(10,2) NOT NULL,
  `added_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`, `slug`, `description`) VALUES
(1, 'make', 'cham-soc-sac-dep', NULL),
(2, 'skincare', 'cham-soc-da-mat', NULL),
(3, 'haircare', 'cham-soc-toc', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `guest_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`guest_info`)),
  `order_date` datetime DEFAULT current_timestamp(),
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('pending','processing','shipped','delivered','canceled') DEFAULT 'pending',
  `shipping_address` varchar(255) NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_items`
--

CREATE TABLE `order_items` (
  `order_item_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock_quantity` int(11) DEFAULT 0,
  `category_id` int(11) DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `is_featured` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `products`
--

INSERT INTO `products` (`product_id`, `name`, `slug`, `description`, `price`, `stock_quantity`, `category_id`, `brand_id`, `is_active`, `created_at`, `is_featured`) VALUES
(1, 'Bộ sản phẩm dưỡng da 3 món -Sữa rửa mặt Bija 20g, Retinol 10ml, Kem dưỡng bija 20ml', 'cham-soc-da', 'Bộ sản phẩm Trouble Care For Clear Skin Set\r\nGồm:\r\n1/ Sữa rửa mặt dành cho da mụn innisfree Bija Trouble Facial Foam 20g\r\n- Hạt Bija tăng sức đề kháng cho da.\r\n- Sạch thoáng lỗ chân lông và tế bào chết.\r\n- An toàn cho da mụn và dầu mụn.\r\n \r\n2/ Sáp dưỡng làm dịu da innisfree Bija Cica Balm EX 15ml\r\n- Hạt Bija tăng sức đề kháng cho da.\r\n- Làm dịu và tăng sức đề kháng cho làn da mụn nhạy cảm.\r\n- Mỏng nhẹ, thấm nhanh.\r\n- Cica Care - An toàn cho da mụn.\r\n\r\n3/ Tinh chất dưỡng phục hồi da innisfree Retinol Cica Repair Ampoule 10ml\r\n- Làm dịu làn da bị kích ứng & nhạy cảm: *Giúp giảm 86% màu da đỏ tạm thời do đeo khẩu trang.\r\n- Cải thiện hàng rào bảo vệ da bị tổn thương đến 102% giúp cải thiện hàng rào bảo vệ da bị tổn thương, do đó giúp da khỏe mạnh hơn để chống lại các yếu tố có hại bên ngoài.\r\n- Tẩy tế bào chết nhẹ nhàng hàng ngày để cải thiện tình trạng da xỉn màu đến 79%', 350000.00, 300, 2, 1, 1, '2025-10-15 22:21:06', 1),
(2, 'Dầu gội nuôi dưỡng chân tóc innisfree My Hair Recipe Strength Shampoo For Hair Roots Care 330 mL\r\n', 'cham-soc-toc', 'Thông tin sản phẩm\r\n1. My Hair Strength - Dưỡng chân tóc chắc khỏe\r\nMy Hair Strength là dòng dưỡng chân tóc khỏe mạnh và phục hồi gãy rụng nhờ thành phần thiên nhiên lành tính. Hỗn hợp Phytoncide gồm cây thông, cây bách và tuyết tùng trong dầu gội giúp giảm căng thẳng cho da đầu. Dòng sản phẩm bổ sung nhân sâm và bái tử nhân để tăng cường sức khỏe cho mái tóc.\r\nSản phẩm không chứa silicon để bảo vệ da đầu.\r\n\r\n2. Chăm sóc da đầu và ngọn tóc yếu\r\nDầu gội giúp phục hồi sức khỏe của da đầu và mái tóc, tránh tình trạng gãy phục nhờ thành phần thiên nhiên lành tính: Hỗn hợp Jeju Phytoncide, saponin trong nhân sâm và bái tử nhân. Mái tóc được nuôi dưỡng khỏe mạnh và giảm căng thẳng cho da đầu.\r\n\r\n3. An toàn cho da đầu\r\nDầu gội không chứa silicon, an toàn cho da đầu và phục hồi sức sống cho mái tóc bóng khỏe.', 270000.00, 400, 3, 1, 1, '2025-10-15 22:23:44', 0),
(3, 'Son bóng dạng thỏi INNISFREE DEWY GLOWY LIPSTICK 3.5G', 'cham-soc-sac-dep', 'Thông tin sản phẩm\r\n1. Kết cấu mỏng nhẹ, tự nhiên\r\nKết cấu mềm mịn giúp son lên môi căng bóng mà vẫn mỏng nhẹ tuyệt đối, bền màu mà không khô môi. Bảng màu tự nhiên, đa dạng và dễ dùng, phù hợp với nhiều tông da Châu Á:\r\n#1. Dew Pink: Màu hồng nhạt có màu như sương sớm mai đọng trên cánh hồng, phù hợp với da tông màu lạnh.\r\n#2. Sugar Coral: Màu cam san hô pha một chút ánh hồng ngọt ngào, phù hợp với da tông màu ấm.\r\n#3. Tangerine Orange: Màu cam nhạt như một trái quýt căng mọng, phù hợp với da tông màu ấm.\r\n#5. Poppy Red: Màu đỏ cổ điển sang trọng, tươi tắn và cực kỳ tôn da.\r\n#6. Dusty Rose: Màu hồng dịu nhẹ thêm một chút ánh đất, phù hợp với mọi loại da.\r\n#7. Raspberry Plum: Màu đỏ hồng như trái mận căng mọng, phù hợp với da tông màu lạnh.\r\n\r\n2. Dưỡng ẩm cho đôi môi luôn mềm mịn\r\nSon dưỡng có công thức polymer giữ nước cung cấp độ ẩm cho môi, tạo lớp son bóng nhưng không gây bết dính\r\n\r\n3. Hiệu ứng bóng tự nhiên cho đôi môi căng mọng\r\nSon bóng với đa sắc màu tự nhiên, chất son ẩm mịn nhưng vẫn nhẹ môi, độ bám màu cao cho đôi môi tươi tắn suốt cả ngày dài.\r\nMàu sẽ lên rõ hơn khi bạn thoa chồng nhiều lớp lên nhau. Bạn có thể tạo ra nhiều kiểu trang điểm môi khác nhau như khi thoa 1 lớp', 420000.00, 300, 1, 1, 1, '2025-10-28 22:26:25', 0),
(12, 'EFFACLAR MICELLAR WATER', 'cham-soc-sac-dep-1', 'EFFACLAR MICELLAR WATER là nước tẩy trang dành cho da dầu, da dễ bị mụn. Nước tẩy trang Micellar Water giúp làm sạch sâu, loại bỏ cặn bẩn, bã nhờn và lớp trang điểm một cách nhẹ nhàng, đem lại cảm giác sạch và tươi mát trên da.\r\n', 150000.00, 260, 1, 2, 1, '2025-10-29 13:25:13', 0),
(13, 'CICAPLAST BAUME B5+', 'cham-soc-da-mat-1', 'Kem phục hồi B5 giúp phục hồi da sau 1 lần sử dụng và tăng cường hàng rào bảo vệ da với 5% vitamin B5, chiết xuất rau má và hoạt chất cải tiến mới Tribioma, giúp cân bằng hệ vi sinh vật trên da.\r\nLàm dịu và phục hồi đa tình trạng tổn thương da thường gặp\r\nVÙNG DA NÓNG RÁT SAU ĐI NẮNG: bỏng nắng nhẹ, da đỏ ửng,…\r\nDA DỄ KÍCH ỨNG CỦA BÉ: hăm tã, mẩn đỏ, mẩn ngứa, viêm da dị ứng\r\nVÙNG DA NHẠY CẢM SAU LIỆU TRÌNH: sau peel, laser, …\r\nDA SAU ĐIỀU TRỊ MỤN: phục hồi da sau điều trị mụn, sau lấy mụn\r\nDA KHÔ MẨN ĐỎ, DỄ KÍCH ỨNG\r\nVẾT TRẦY XƯỚC NHẸ', 200000.00, 250, 2, 2, 1, '2025-10-29 13:25:13', 0),
(14, 'ANTHELIOS UVMUNE 400 ', 'cham-soc-da-mat-2', 'PHÙ HỢP CHO MỌI LÀN DA\r\nĐẶC BIỆT LÀ DA DỄ KÍCH ỨNG\r\nBẢO VỆ TỐI ƯU KHỎI THỦ PHẠM TIỀM ẨN CỦA THÂM NÁM\r\nTHÔNG TIN SẢN PHẨM\r\nANTHELIOS UVMUNE 400 là sản phẩm chống nắng mới nhất của La Roche Posay với màng lọc độc quyền Mexoryl 400 & công nghệ net lock giúp bảo vệ da khỏi “thủ phạm tiềm ẩn” của thâm nám\r\nKết cấu mỏng nhẹ lâu trôi, kháng nước, cát và mồ hôi. Không gây cay mắt.', 170000.00, 180, 2, 2, 1, '2025-10-29 13:25:13', 1),
(15, 'Sữa rửa mặt dạng kem tạo bọt Hyper Real Fresh Canvas', 'cham-soc-da-mat-3', 'Sữa rửa mặt dạng kem tạo bọt, tẩy trang/bụi bẩn/dầu thừa/chất gây ô nhiễm, làm mịn da/duy trì độ ẩm cho da\r\nLàm sạch sâu làn da của bạn với sữa rửa mặt dạng kem tạo bọt dịu nhẹ, tinh tế của chúng tôi , giúp loại bỏ lớp trang điểm và hòa tan bụi bẩn, dầu thừa và các chất ô nhiễm, đồng thời làm mịn da tức thì và lâu dài. Công thức biến đổi sang trọng bắt đầu từ một loại kem đặc , chuyển thành lớp bọt dày mịn màng , không gây bết dính hay khô da, mang lại vẻ ngoài khỏe mạnh, rạng rỡ. Sữa rửa mặt này, với chiết xuất hoa mẫu đơn Nhật Bản quý hiếm và bền bỉ , cùng với Axit Hyaluronic Cationic và 20% Glycerin, duy trì độ ẩm cho làn da , mang lại làn da tươi mới, mềm mại, mịn màng như cánh hoa , luôn sẵn sàng cho các bước chăm sóc da tiếp theo\r\n', 950000.00, 200, 2, 3, 1, '2025-10-29 13:37:54', 1),
(16, 'Bộ ba son môi M·A·CX TO THE FUTURE', 'cham-soc-sac-dep-2', 'Biến phong cách tối giản thành tín đồ M·A·Cximal trong mùa lễ hội này. Bộ ba son môi làm quà tặng này bao gồm hai màu son trung tính bán chạy nhất của M·A·Cximal Silky Matte Lipstick với hai màu Velvet Teddy và Whirl, cùng với son Lipglass Clear cỡ lớn. Son M·A·Cximal Silky Matte Lipstick mang đến 12 giờ phủ màu hoàn hảo và 8 giờ dưỡng ẩm. Lipglass Clear là một loại son bóng độc đáo có thể thoa nhiều lớp để có lớp nền bóng như thủy tinh hoặc ánh nhũ nhẹ nhàng. Sẵn sàng để làm quà tặng trong bao bì độc quyền dành riêng cho mùa lễ hội với giá trị tuyệt vời của M·A·Cnificent.', 750000.00, 120, 1, 3, 1, '2025-10-29 13:37:54', 1),
(17, 'Phấn má hồng ', 'cham-soc-sac-dep-3', '5+ Kết cấu, Có thể xây dựng, Chuyên nghiệp\r\nPhấn má hồng dạng bột M·A·C được thiết kế bởi và dành cho các chuyên gia trang điểm. Sản phẩm được bổ sung vitamin E và được điều chế để mang lại màu sắc tuyệt vời cho đôi má một cách dễ dàng và đồng đều. Thoa đều, bám nhẹ trên da để có được lớp nền tự nhiên\r\n', 630000.00, 120, 1, 3, 1, '2025-10-29 13:37:54', 0),
(18, 'The City Mini (Bảng phấn mắt)', 'cham-soc-sac-dep-4', 'Bảng phấn mắt The City Mini có sáu tông màu ấn tượng là lựa chọn hoàn hảo để tạo nên phong cách trang điểm mắt yêu thích.\r\nTừ Graffiti Pop và Concrete Runway tới Rooftop Bronzes và Chill Brunch Neutrals, hãy tạo lớp trang điểm ấn tượng sâu sắc với bảng phấn mắt mini 8 màu của Maybelline.\r\n\r\nMascara Làm Tơi và Dài Mi Lash Sensational Sky High 268 000 \r\n\r\nMascara làm dày và dài mi Sky High mang đến hàng mi cong vút ở mọi góc độ. Mascara lâu trôi mang lại hàng mi cong dày cùng độ dài ấn tượng.\r\nSky High mang đến hàng mi cong vút ở mọi góc độ. Mascara Lash Sensational Sky High mang lại hàng mi cong dày cùng độ dài ấn tượng. Cọ mascara Flex Tower độc quyền uốn cong làm dày và kéo dài từng sợi lông mi từ gốc tới ngọn. Công thức mascara dễ tẩy sạch với chiết xuất và sợi tre cho hàng mi dài cong ấn tượng gần như không trọng lượng. Hiện có màu Very Black và Blackest Black. Đã được kiểm nghiệm dị ứng. Đã được bác sĩ nhãn khoa kiểm nghiệm. Thích hợp cho mắt nhạy cảm và người đeo kính áp tròng. Dễ tẩy tảng với nước tẩy trang chống thấm nước cho mắt.', 308000.00, 129, 1, 4, 1, '2025-10-29 13:50:54', 0),
(19, 'Phấn Phủ Kiềm Dầu Dạng Nén Matte + Poreless ', 'cham-soc-sac-dep-5', 'Phấn phủ dạng nén Maybelline Fit Me Matte+Poreless Powder nổi bật với khả năng kiềm dầu hiệu quả lên đến 16h nhờ công nghệ Perlite Mineral, phù hợp cho da thường và da dầu. Hạt phấn Micro Power vô cùng mịn mang đến lớp phấn mỏng nhẹ, không gây bí da nhưng vẫn có độ che phủ hoàn hảo và bền màu suốt cả ngày dài. Sản phẩm có chỉ số chống nắng SPF32 PA+++ hỗ trợ bảo vệ da khỏi tác hại của tia UV.\r\n- Độ che phủ hoàn hảo, giảm thiểu tối đa khuyết điểm trên da.\r\n- Lớp phấn mỏng nhẹ, tệp màu da tự nhiên.\r\n- Mịn lì, giữ lớp trang điểm lâu trôi.\r\n- Hạn chế hoạt động của tuyến bã nhờn, kiềm dầu đến 16h.\r\n* Đã được kiểm nghiệm bởi bác sĩ da liễu, không gây mụn hay kích ứng.', 228000.00, 120, 1, 4, 1, '2025-10-29 13:53:43', 0),
(20, 'Bút Kẻ Mắt Nước Sắc Mảnh Maybelline Hyper Sharp Liner Extreme', 'cham-soc-sac-dep-6', 'Bút Kẻ Mắt Nước Maybelline Hyper Sharp Liner Extreme với công nghệ Ink Capsule mới công nghệ Ink Capsule giúp mực ra đều, đậm, bền màu. Maybelline Hyper Sharp Liner Extreme có đầu cọ 0,01mm giúp bạn linh hoạt tạo ra những đường kẻ\r\n- Đầu cọ 0,01mm sắc mảnh giúp tạo đường eyeliner sắc sảo, linh hoạt dễ dàng tạo đường cực mảnh đến dày phù hợp cho mọi phong cách trang điểm.\r\n- Công nghệ Ink Capsule mới khiến mực ra đều, đậm hơn 147% so với phiên bản trước.\r\n- Độ bền màu lên đến 36 giờ, có khả năng kháng nước, mồ hôi, không lem trôi.', 228000.00, 100, 1, 4, 1, '2025-10-29 13:53:43', 1),
(21, 'Tinh chất làm mờ nếp nhăn The Ordinary Argireline Solution 10%', 'cham-soc-da-mat-4', 'The Ordinary Argineline Solution 10% có tác dụng cải thiện nếp nhăn trong thời gian ngắn, đặc biệt ở vùng da mắt, 2 bên cánh mũi. Những dưỡng chất có trong serum Argineline Solution 10% sẽ giúp ngăn chặn sự hình thành của các sắc tố melanin, tăng cường quá trình trao đổi chất cho da, giúp da của bạn trở nên tươi sáng, khoẻ mạnh hơn rõ rệt. Các đánh giá còn cho thấy sản phẩm này có tác dụng làm mờ vết sạm, vết nám da.\r\nThe Ordinary Argireline Solution 10% có nhiều công dụng về chăm sóc da, bao gồm:\r\nGiảm sự xuất hiện của nếp nhăn và đường nhăn trên da: Argireline trong sản phẩm này có khả năng ức chế sự co rút của cơ trên da, giúp làm giảm sự xuất hiện của các nếp nhăn và đường nhăn trên da.\r\nCải thiện độ đàn hồi và độ săn chắc của da: Sản phẩm này có khả năng giúp cải thiện độ đàn hồi và độ săn chắc của da, giúp da trở nên tươi trẻ và mịn màng hơn.\r\nChống oxy hóa: The Ordinary Argireline Solution 10% cũng có khả năng chống oxy hóa, giúp bảo vệ da khỏi sự tấn công của các gốc tự do gây hại.\r\nTăng cường quá trình sản sinh collagen: Argireline có khả năng kích thích quá trình sản sinh collagen, giúp cải thiện độ đàn hồi và độ săn chắc của da.\r\n– Ngoài ra, nên kết hợp với các bước chăm sóc da khác để đạt được hiệu quả tốt nhất cho làn da của bạn.', 360000.00, 180, 2, 5, 1, '2025-10-29 14:05:53', 1),
(22, 'Bột Vitamin C The Ordinary 100% L-Ascorbic Acid Powder', 'cham-soc-da-mat-5', 'Bột vitamin C The Ordinary 100% L Ascorbic Acid Powder là một loại bột mềm mịn, với thành phần là 100% L-Ascorbic tinh khiết (dẫn xuất vitamin C mạnh nhất) có thể hòa tan được trong nước\r\nAscorbic Acid bảo vệ chúng ta khỏi các gốc tự do hình thành trong quá trình da tiếp xúc với bức xạ UVA và UVB. Axit ascorbic cũng là cần thiết để tổng hợp collagen, nơi mà nó cần thiết để hyđroxyl hóa axit amin proline sau sự tổng hợp protein.\r\nBột Vitamin C giúp sáng da, mờ thâm The Ordinary 100% L-ascorbic Acid Power có khả năng làm sáng, đều màu da, mờ thâm, tăng khả hiệu quả của kem chống nắng… Và có một điểm cộng là dạng bột nên không lo vấn đề bị oxy hóa như serum\r\nCó thể trộn chung với rất nhiều loại khác nhau: mask, kem dưỡng, kem chống nắng, serum…\r\nLƯU Ý:\r\nKhông nên mix chung với các sản phẩm chứa Niacianamide, EUK vì sẽ làm mất tác dụng của Vitamin C\r\nKhông nên mix với các sản phẩm dầu vì khó hòa tan, khó hấp thụ vào da\r\nKhông nên mix với các sản phẩm đã có hàm lượng Vitamin C, vì dễ gây kích ứng da', 260000.00, 170, 2, 5, 1, '2025-10-29 14:05:53', 0),
(23, 'Mặt nạ The Ordinary Salicylic Acid 2% Masque', 'cham-soc-da-mat-6', 'The Ordinary Salicylic Acid 2% Masque là một sản phẩm tẩy tế bào chết vật lý và hóa học, được thiết kế đặc biệt để làm sạch sâu lỗ chân lông, giảm mụn và cải thiện kết cấu da. Với thành phần chính là Salicylic Acid (BHA), sản phẩm này đã trở thành một trong những lựa chọn hàng đầu cho những ai đang tìm kiếm giải pháp cho làn da mụn và dầu nhờn.\r\nMặt nạ The Ordinary Salicylic acid 2% Masque được điều chế để làm giảm sự không đều màu trên da và sự bất thường về kết cấu da.\r\nVới công thức từ charcoal và clays (than củi và đất sét), sản phẩm nhằm mục đích tăng cường sự mịn màng và rõ ràng cho làn da, giúp làn da trở lên tươi mát nhẹ nhàng hơn.\r\nCấu trúc của Salicylic Acid tạo điều kiện thuận lợi cho việc làm sạch các lỗ chân lông cũng như khả năng trộn lẫn của chất với các lipid chất mỡ nằm trên bề mặt da. Với tác dụng loại bỏ các tế bào da chết trên bề mặt da, đặc biệt là da dầu nhờn và nhiều vết thâm, Salicylic 2% Masque sẽ giúp làn da tươi mới hơn được đẩy lên trên.\r\nThích hợp cho da mụn.', 400000.00, 120, 2, 5, 1, '2025-10-29 14:05:53', 0),
(24, 'L`Oreal Paris Elseve Fall Resist 3X Anti-Hairfall', 'cham-soc-toc-1', 'Dầu gội giảm gãy rụng tóc L`Oreal Paris Elseve Fall Resist 3X Anti-Hairfall Shampoo cung cấp cho tóc các dưỡng chất thiết yếu, giảm tóc gãy rụng\r\n\r\nDầu gội giảm gãy rụng tóc ELSEVE FALL RESIST 3X ANTI-HAIRFALL được bổ sung Arginine, một axit amin cần thiết cho tóc, với ba tác động:\r\n1. Giúp dưỡng tóc từ gốc đến ngọn\r\n2. Tăng cường dưỡng chất cho tóc giúp giảm gãy rụng\r\n3. Giúp tóc trông chắc khỏe hơn\r\nCÁCH SỬ DỤNG: Thoa dầu gội lên tóc ướt. Mát-xa nhẹ nhàng từ gốc tới ngọn, sau đó xả sạch tóc với nước. Trong trường hợp dính vào mắt, ngay lập tức rửa sạch. Sử dụng với những sản phẩm khác cùng dòng Fall Resist để đạt được kết quả tốt nhất.', 120000.00, 100, 3, 6, 1, '2025-10-29 14:20:40', 1),
(25, 'L`Oréal Paris Elseve Extraordinary Oil', 'cham-soc-toc-2', 'Dầu dưỡng tóc chiết xuất từ các loại hoa tự nhiên L`Oréal Paris Elseve Extraordinary Oil cung cấp dưỡng chất giúp tóc bóng mượt, suôn mềm và trông chắc khỏe hơn.\r\nDầu dưỡng chiết xuất từ hoa tự nhiên L`Oréal Paris Elseve Extraordinary Oil cùng nhiều dưỡng chất cho tóc  bóng mượt, suôn mềm và trông chắc khỏe hơn. Thành phần dưỡng ẩm tốt cho tóc khô, xoăn và hư tổn. Giúp tóc Trông chắc khỏe, bồng bềnh, giảm thiểu tình trạng rụng tóc. Lưu giữ hương thơm nhẹ nhàng cho mái tóc, tạo cảm giác thoải mái cho người sử dụng.', 230000.00, 150, 3, 6, 1, '2025-10-29 14:20:40', 0),
(26, 'Kem Che Khuyết Điểm L`Oreal Paris Infallible More Than Concealer', 'cham-soc-sac-dep-7', 'Kem Che Khuyết Điểm L`Oreal Paris Infallible More Than Concealer có chất kem khá đặc nhưng dễ tán, độ che phủ trung bình đến cao và có thể che tốt quầng thâm hay thâm mụn.\r\nĐịnh hình lông mày của bạn. Thoải mái thể hiện bản thân. Khám phá chì kẻ định hình lông mày cao cấp với các màu sắc được thiết kế riêng phù hợp hoàn hảo với bạn! Nhờ công thức chì siêu dễ kẻ, đầu bút hình tam giác nhọn giúp phác họa chính xác các điểm khung, tô đều với tâm tròn và cố định dáng lông mày. Đầu chải tạo kiểu mềm mại với lớp lông ngắn mịn, dễ dàng tán đều lớp chì giúp lông mày tự nhiên như không kẻ. Hãy tìm màu chì phù hợp với bạn!', 208000.00, 100, 1, 6, 1, '2025-10-29 14:20:40', 0),
(27, 'Kem dưỡng sáng da ban đêm L’Oreal Paris Aura Perfect Night Cream', 'cham-soc-sac-dep-8', 'Kem dưỡng sáng da ban đêm L’Oreal Paris Aura Perfect Night Cream với kết cấu không nhờn dính, hoạt động hiệu quả vào ban đêm giúp dưỡng sáng da, cho làn da sáng mịn đều màu.\r\nKem dưỡng sáng da ban đêm L’Oreal Paris Aura Perfect Night Cream với các thành phần - Vitamin C giúp làm sáng da, giảm các đốm tối màu và làm đều màu da; Tinh thể đá quý Tourmaline: giúp da trông tươi trẻ hơn, cho làn da trông rạng rỡ và hồng hào; Vitamin E: giúp giảm tác hại do các gốc tự do của quá trình oxy hóa gây ra trên da - là lựa chọn ưu tiên của các sản phẩm làm sáng da. \r\nHiệu quả đã được kiểm chứng theo nghiên cứu của các chuyên gia:\r\nSau một đêm: Làn da của bạn trông sáng mịn, rạng rỡ hơn.\r\nNgày qua ngày: Các vết đốm sậm màu mờ dần,  làn da trở nên sáng mịn, đều màu, trông khỏe hơn với sắc hồng rạng rỡ.', 230000.00, 120, 2, 6, 1, '2025-10-29 14:20:40', 0),
(28, 'Mặt nạ dưỡng chất pha lê Revitalift Crystal Micro Essence', 'cham-soc-sac-dep-9', 'Mặt nạ dưỡng chất pha lê Revitalift Crystal Micro Essence treatment Mask Hiệu quả tức thì: sau 15 phút – làn da được cấp nước và ẩm mịn đến +126%\r\nMặt nạ dưỡng chất pha lê Revitalift Crystal Micro Essence treatment Mask Hiệu quả tức thì: sau 15 phút – làn da được cấp nước và ẩm mịn đến +126%, sau 7 ngày – da sáng mịn rạng rỡ căng mướt. Da sáng bật 1 tone sau 3 lần sử dụng. Da sáng mịn căng mướt như pha lê – hiệu quả sau 7 ngày.', 50000.00, 140, 2, 6, 1, '2025-10-29 14:20:40', 0),
(29, 'Phấn nền chống nắng Shiseido UV Protective Stick Foundation 9g', 'cham-soc-sac-dep-10', 'Shiseido UV Protective Stick Foundation là thỏi phấn nền thông minh của thương hiệu Shiseido danh tiếng, không chỉ nổi bật bởi khả năng che phủ siêu rộng, lâu trôi và chống nắng bảo vệ da cực hiệu quả, phấn nền Shiseido ứng dụng công nghệ độc quyền từ thương hiệu này dưỡng ẩm sâu cho làn da luôn mềm mại, mượt mà suốt cả ngày.\r\n- Phấn nền với độ bám cao, mang lại lớp nền hoàn hảo và tự nhiên, cho làn da tươi trẻ, rạng rỡ suốt cả ngày.\r\n- Kết cấu cực mịn giúp mang lại lớn nền mỏng nhẹ, không gây bít tắc lỗ chân lông mà mang lại cảm giác khô thoáng, nhẹ nhàng.\r\n- Độ che phủ cực cao dễ dàng che đi những khuyết điểm trên khuôn mặt như mụn, thâm sạm, nám và tàn nhang...\r\n- Lớp nền nhanh tệp màu, giúp cân bằng tone màu da.\r\n- Bảo vệ làn da trước những tác hại của tia UV và môi trường.\r\n- Cấp ẩm và dưỡng chuyên sâu, hạn chế tình trạng da thô ráp, sần sùi hay bong tróc.', 730000.00, 150, 1, 7, 1, '2025-10-29 14:41:30', 0),
(30, 'Chống nắng Nichiei Bussan Nano NMN+ UV Essence Luxury SPF50+ PA++++ 60g', 'cham-soc-da-mat-7', 'Kem chống nắng Nichiei Bussan Nano NMN+ UV Essence Luxury SPF50+ PA++++ 60g – Chống nắng vượt trội, dưỡng da đỉnh cao\r\nĐiểm nổi bật\r\nChỉ số SPF50+ PA++++ bảo vệ da khỏi tác hại của tia UVA/UVB suốt cả ngày dài.\r\nChứa NMN công nghệ Nano – dưỡng chất cao cấp hỗ trợ trẻ hóa làn da.\r\nKết cấu essence dạng sữa mỏng nhẹ, không gây bí da, không nâng tông, phù hợp mọi loại da.\r\nCó thể dùng như lớp lót trang điểm nhẹ nhờ độ mịn và kiềm dầu tốt.\r\nKhông chứa cồn, paraben hay hương liệu nhân tạo, an toàn cho da nhạy cảm.\r\nCông dụng\r\nTạo màng chắn chống nắng tối ưu, ngăn ngừa sạm nám, cháy nắng, lão hóa da.\r\nHỗ trợ phục hồi tế bào da tổn thương do tia UV, duy trì độ ẩm mượt và khỏe mạnh.\r\nBổ sung NMN giúp làn da luôn tươi trẻ, rạng rỡ ngay cả khi tiếp xúc nắng thường xuyên.\r\nThành phần chính\r\nNMN (Nicotinamide Mononucleotide): hỗ trợ tái tạo tế bào, ngăn ngừa lão hóa sớm do ánh nắng.\r\nChiết xuất nhau thai, collagen & HA: dưỡng ẩm và phục hồi da.\r\nVitamin E & các chiết xuất thảo dược Nhật Bản: làm dịu da và tăng cường hàng rào bảo vệ da.\r\nHướng dẫn sử dụng\r\nSử dụng mỗi sáng sau bước dưỡng da, trước khi ra ngoài khoảng 15–20 phút.\r\nLấy lượng vừa đủ, thoa đều lên mặt và cổ.\r\nNên thoa lại sau 3–4 giờ nếu hoạt động ngoài trời liên tục.', 1420000.00, 150, 2, 7, 1, '2025-10-29 14:41:30', 1),
(31, 'Mặt Nạ Nichiei Bussan Nano NMN+ 3D Face Mask Luxury (8 miếng)', 'cham-soc-da-mat-8', 'Mặt Nạ Nichiei Bussan Nano NMN+ 3D Face Mask Luxury (8 miếng) – Trẻ hóa làn da, cấp ẩm sâu và tái tạo từ bên trong\r\nĐiểm nổi bật\r\nSử dụng công nghệ Nano NMN tiên tiến, giúp dưỡng chất thẩm thấu sâu vào biểu bì da.\r\nThiết kế mặt nạ 3D ôm khít khuôn mặt, tăng khả năng tiếp xúc và hấp thụ tối ưu.\r\nThành phần thiên nhiên lành tính, phù hợp mọi loại da, kể cả da nhạy cảm.\r\nCông dụng\r\nTái tạo tế bào da mới, giúp da căng mịn, đều màu và trẻ hóa rõ rệt.\r\nCấp ẩm chuyên sâu, cải thiện tình trạng khô ráp, bong tróc.\r\nLàm dịu da tức thì sau khi đi nắng hoặc stress.\r\nTăng độ đàn hồi và săn chắc da, giảm thiểu dấu hiệu lão hóa.\r\nThành phần chính\r\nNano NMN (Nicotinamide Mononucleotide): phục hồi – chống lão hóa – làm sáng da.\r\nChiết xuất nhau thai thực vật, collagen và axit hyaluronic: dưỡng ẩm sâu, làm đầy nếp nhăn.\r\nChiết xuất cam thảo, trà xanh: làm dịu, chống oxy hóa và hỗ trợ kháng viêm nhẹ.\r\nHướng dẫn sử dụng\r\nLàm sạch mặt.\r\nLấy mặt nạ ra khỏi túi, đắp lên da, điều chỉnh khớp với khuôn mặt.\r\nThư giãn 15–20 phút, sau đó gỡ bỏ và massage nhẹ cho dưỡng chất thấm sâu.\r\nKhông cần rửa lại với nước.', 1890000.00, 139, 2, 7, 1, '2025-10-29 14:41:30', 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_images`
--

CREATE TABLE `product_images` (
  `image_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `is_primary` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `product_images`
--

INSERT INTO `product_images` (`image_id`, `product_id`, `image_url`, `is_primary`) VALUES
(1, 1, 'mdeia/TravelKitSetmain.jsp', 1),
(2, 1, 'mdeia/KitSet1.jsp', 0),
(3, 1, 'mdeia/KitSet2.jsp', 0),
(4, 1, 'mdeia/KitSet3.jsp', 0),
(5, 2, 'mdeia/InniHairmain.jsp', 1),
(6, 2, 'mdeia/InniHair1.jsp', 0),
(7, 2, 'mdeia/InniHair2.jsp', 0),
(8, 2, 'mdeia/InniHair3.jsp', 0),
(9, 3, 'mdeia/InniSonmain.jsp', 1),
(10, 3, 'mdeia/InniSon1.jsp', 0),
(11, 3, 'mdeia/InniSon2.jsp', 0),
(12, 3, 'mdeia/InniSon3.jsp', 0),
(25, 12, 'media/LRPtaytrangmain.jpg', 1),
(26, 12, 'media/LRP1.jpg', 0),
(27, 12, 'media/LRP2.jpg', 0),
(28, 12, 'media/LRP3.jpg', 0),
(29, 13, 'media/LRPduongda.jpg', 1),
(30, 13, 'media/LRPdd1.jpg', 0),
(31, 13, 'media/LRPdd2.jpg', 0),
(32, 13, 'media/LRPdd3.jpg', 0),
(33, 13, 'media/LRPdd4.jpg', 0),
(34, 14, 'media/LRPchongnang.jpg', 1),
(35, 14, 'media/LRPcn1.jpg', 0),
(36, 14, 'media/LRPcn2.jpg', 0),
(37, 15, 'media/MACruamat.jpg', 1),
(38, 15, 'media/MACrm1.jpg', 0),
(39, 15, 'media/MACrm2.jpg', 0),
(40, 15, 'media/MACrm3.jpg', 0),
(41, 16, 'media/MACson.jpg', 1),
(42, 16, 'media/MACson1.jpg', 0),
(43, 16, 'media/MACson2.jpg', 0),
(44, 16, 'media/MACson3.jpg', 0),
(45, 17, 'media/MACphan.jpg', 1),
(46, 17, 'media/MACp1.jpg', 0),
(47, 17, 'media/MACp2.jpg', 0),
(48, 17, 'media/MACp3.jpg', 0),
(49, 18, 'media/Brand4phanmat.jpg', 1),
(50, 18, 'mdeia/Brand4pm1.jpg', 0),
(51, 18, 'mdeia/Brand4pm2.jpg', 0),
(52, 18, 'mdeia/Brand4pm3.jpg', 0),
(53, 19, 'media/Brand4mcr.jpg', 1),
(54, 19, 'media/Brand4mcr1.jpg', 0),
(55, 19, 'media/Brand4mcr2.jpg', 0),
(56, 19, 'media/Brand4mcr3.jpg', 0),
(57, 20, 'media/Brand4pp.jpg', 1),
(58, 20, 'media/Brand4pp1.jpg', 0),
(59, 20, 'media/Brand4pp2.jpg', 0),
(60, 20, 'media/Brand4pp3.jpg', 0),
(61, 21, 'media/Brand5tc.jpg', 1),
(62, 21, 'media/Brand5tc1.jpg', 0),
(63, 21, 'media/Brand5tc2.jpg', 0),
(64, 21, 'media/Brand5tc3.jpg', 0),
(65, 22, 'media/Brand5vtm.jpg', 1),
(66, 22, 'media/Brand5vtm2.jpg', 0),
(67, 23, 'media/Brand5mn.jpg', 1),
(68, 23, 'media/Brand5mn1.jpg', 0),
(69, 23, 'media/Brand5mn2.jpg', 0),
(70, 23, 'media/Brand5mn3.jpg', 0),
(71, 24, 'media/Brand6dg.jpg', 1),
(72, 24, 'media/Brand6dg1.jpg', 0),
(73, 24, 'media/Brand6dg2.jpg', 0),
(74, 24, 'media/Brand6dg3.jpg', 0),
(75, 25, 'media/Brand6dx.jpg', 1),
(76, 25, 'media/Brand6dx1.jpg', 0),
(77, 25, 'media/Brand6dx2.jpg', 0),
(78, 25, 'media/Brand6dx3.jpg', 0),
(79, 25, 'media/Brand6dx4.jpg', 0),
(80, 26, 'media/Brand6kkd.jpg', 1),
(81, 26, 'media/Brand6kkd1.jpg', 0),
(82, 26, 'media/Brand6kkd2.jpg', 0),
(83, 26, 'media/Brand6kkd3.jpg', 0),
(84, 27, 'media/Brand6kd.jpg', 1),
(85, 27, 'media/Brand6kd1.jpg', 0),
(86, 27, 'media/Brand6kd2.jpg', 0),
(87, 27, 'media/Brand6kd3.jpg', 0),
(88, 28, 'media/Brand6mn.jpg', 1),
(89, 28, 'media/Brand6mn1.jpg', 0),
(90, 28, 'media/Brand6mn2.jpg', 0),
(91, 28, 'media/Brand6mn3.jpg', 0),
(92, 28, 'media/Brand6mn4.jpg', 0),
(93, 29, 'media/Brand7phannen.jpg', 1),
(94, 30, 'media/Brand7kcn.jpg', 1),
(95, 31, 'media/Brand7matna.jpg', 1),
(96, 31, 'media/Brand7matna1.jpg', 0);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` between 1 and 5),
  `comment` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `reviews`
--

INSERT INTO `reviews` (`review_id`, `product_id`, `user_id`, `rating`, `comment`, `created_at`) VALUES
(1, 1, 2, 4, 'sản phẩm dùng rất ổn', '2025-10-28 22:39:10');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `role` enum('customer','admin') DEFAULT 'customer',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`user_id`, `username`, `password_hash`, `email`, `full_name`, `phone_number`, `address`, `role`, `created_at`) VALUES
(1, 'trung', '123456', 'trunglay2k4@gmail.com', 'Đoàn Quốc Trung', '0393664604', 'Hà Nội', 'admin', '2025-10-28 22:35:21'),
(2, 'minh123', '123456', 'tran@gmail.com', 'Minh Trần', '0354666064', 'Hà Nội', 'customer', '2025-10-28 22:35:21'),
(3, 'trang223', '123456', 'trangk4@gmail.com', 'Huyền Trang', '0323234604', 'Hà Nội', 'customer', '2025-10-28 22:35:21');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`brand_id`),
  ADD UNIQUE KEY `brand_name` (`brand_name`);

--
-- Chỉ mục cho bảng `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`cart_id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD UNIQUE KEY `session_id` (`session_id`);

--
-- Chỉ mục cho bảng `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`cart_item_id`),
  ADD UNIQUE KEY `cart_id` (`cart_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Chỉ mục cho bảng `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Chỉ mục cho bảng `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Chỉ mục cho bảng `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `brand_id` (`brand_id`);

--
-- Chỉ mục cho bảng `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`image_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Chỉ mục cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD UNIQUE KEY `product_id` (`product_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `brands`
--
ALTER TABLE `brands`
  MODIFY `brand_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `carts`
--
ALTER TABLE `carts`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `cart_item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT cho bảng `product_images`
--
ALTER TABLE `product_images`
  MODIFY `image_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- AUTO_INCREMENT cho bảng `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`cart_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);

--
-- Các ràng buộc cho bảng `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`brand_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
