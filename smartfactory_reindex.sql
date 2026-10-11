-- smartfactory_reindex.sql
-- Mục tiêu: đo kích thước Index trước/sau, xóa FAT index, tạo lean index, kiểm tra EXPLAIN
USE smartfactory_db;

-- 1. Kiểm tra trạng thái bảng ban đầu
SHOW TABLE STATUS LIKE 'SensorLogs';

-- 2. Lấy kích thước Data/Index từ information_schema (MB)
SELECT
  TABLE_SCHEMA,
  TABLE_NAME,
  ROUND(DATA_LENGTH/1024/1024, 3) AS data_mb,
  ROUND(INDEX_LENGTH/1024/1024, 3) AS index_mb,
  ROUND((DATA_LENGTH+INDEX_LENGTH)/1024/1024, 3) AS total_mb,
  TABLE_ROWS
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'smartfactory_db' AND TABLE_NAME = 'SensorLogs';

-- 3. Liệt kê index hiện có
SHOW INDEX FROM SensorLogs;

-- 4. EXPLAIN cho truy vấn Dashboard trước khi thay đổi
EXPLAIN SELECT temperature, humidity, status
FROM SensorLogs
WHERE sensor_id = 105 AND recorded_at >= '2026-06-20';

-- 5. DROP FAT index (thực hiện khi bạn đã backup hoặc trên môi trường staging)
ALTER TABLE SensorLogs DROP INDEX idx_fat_covering;

-- 6. Tạo Lean index chỉ cho mục đích lọc/sort
CREATE INDEX idx_lean_search ON SensorLogs(sensor_id, recorded_at);

-- 7. Kiểm tra lại index còn lại
SHOW INDEX FROM SensorLogs;

-- 8. Kiểm tra trạng thái bảng sau khi thay đổi
SHOW TABLE STATUS LIKE 'SensorLogs';

SELECT
  TABLE_SCHEMA,
  TABLE_NAME,
  ROUND(DATA_LENGTH/1024/1024, 3) AS data_mb,
  ROUND(INDEX_LENGTH/1024/1024, 3) AS index_mb,
  ROUND((DATA_LENGTH+INDEX_LENGTH)/1024/1024, 3) AS total_mb,
  TABLE_ROWS
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'smartfactory_db' AND TABLE_NAME = 'SensorLogs';

-- 9. EXPLAIN cho truy vấn Dashboard sau khi thay đổi
EXPLAIN SELECT temperature, humidity, status
FROM SensorLogs
WHERE sensor_id = 105 AND recorded_at >= '2026-06-20';
