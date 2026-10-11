Tiêu đề  
Tối ưu Index cho SmartFactory — đánh đổi giữa Read và Write

Báo cáo (≈200 từ)  
Hệ thống SmartFactory gặp nghẽn vì một Covering Index quá “mập” chứa sensor_id, recorded_at, temperature, humidity, status. Covering Index giúp SELECT trả về nhanh bằng cách đọc trực tiếp từ B‑Tree mà không cần lookup table, nhưng đổi lại mỗi INSERT/UPDATE phải cập nhật mọi secondary index. Với dữ liệu IoT có tần suất ghi cao, chi phí duy trì một index chứa các cột thay đổi liên tục (temperature, humidity, status) là thảm họa: nhiều I/O, contention, và tăng kích thước INDEX_LENGTH vượt cả DATA_LENGTH.

Giải pháp đề xuất là thay thế bằng một Lean Index chỉ chứa các cột dùng để lọc và sắp xếp: (sensor_id, recorded_at). Lợi ích: (1) Giảm đáng kể kích thước index (ước tính giảm ~70% tùy dữ liệu), (2) Giảm số cập nhật B‑Tree cho mỗi INSERT từ N xuống còn ít (giảm write penalty), (3) Giữ được hiệu năng truy vấn lọc theo cảm biến và khoảng thời gian. Hệ quả: SELECT dashboard có thể hơi chậm hơn do cần lookup table để lấy temperature, humidity, status, nhưng trong thực tế lookup là một vài I/O đọc hàng loạt và chấp nhận được so với việc hệ thống bị rớt dữ liệu.

Khuyến nghị bổ sung: nếu cần tìm nhanh theo trạng thái hiếm (ví dụ chỉ quan tâm CRITICAL), cân nhắc tạo index nhỏ riêng cho status chỉ khi cardinality và tần suất truy vấn chứng minh lợi ích; với text lớn hoặc tìm kiếm full-text, dùng giải pháp FULLTEXT hoặc search engine ngoài DB.
