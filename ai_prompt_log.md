1) Prompt
"Giải thích Covering Index trong MySQL là gì và tại sao nó tăng tốc SELECT."

Summary
- Covering Index chứa tất cả cột cần cho SELECT nên engine đọc trực tiếp từ index leaf, tránh lookup table.
- Hiệu quả lớn cho các truy vấn đọc nhưng làm index lớn hơn và tăng chi phí ghi.

2) Prompt
"Khi bảng có N secondary indexes, mỗi INSERT phải làm gì với các B-Tree? Mô tả ngắn."

Summary
- Mỗi INSERT chèn vào clustered index (PRIMARY) và chèn vào mỗi secondary index.
- Số thao tác B‑Tree ≈ 1 + number_of_secondary_indexes; mỗi secondary index tăng I/O và CPU.

3) Prompt
"Tại sao đưa các cột thay đổi liên tục như temperature, humidity vào index lại gây hại cho hệ thống IoT?"

Summary
- Các cột thay đổi liên tục khiến secondary index phải cập nhật liên tục, gây nhiều random I/O.
- Index pages phình to, cache miss tăng, latency INSERT tăng, có thể gây backlog và data loss.

4) Prompt
"Cardinality là gì và vì sao index trên cột low-cardinality thường vô dụng?"

Summary
- Cardinality = số giá trị khác nhau trong cột.
- Low-cardinality (ví dụ boolean) có selectivity thấp; optimizer thường chọn full table scan thay vì dùng index.

5) Prompt
"Nên dùng giải pháp nào thay thế khi cần tìm kiếm nội dung lớn như temperature logs hoặc text?"

Summary
- Với text lớn: FULLTEXT index hoặc external search engine (Elasticsearch) phù hợp hơn B-Tree.
- Với time-series numeric: giữ index trên sensor_id và timestamp; dùng columnar store hoặc time-series DB nếu cần phân tích sâu.
