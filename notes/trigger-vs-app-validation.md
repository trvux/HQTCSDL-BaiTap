# Tại sao cần Trigger/constraint ở DB, không chỉ validate ở app?

## Cơ chế INSERTED / DELETED

- `INSERTED` và `DELETED` là 2 bảng ảo (logic), cấu trúc giống hệt bảng mà trigger gắn vào.
- Chỉ tồn tại **trong lúc trigger đang chạy**, chạy xong là biến mất — không phải bảng thật.
- INSERT → dữ liệu mới nằm trong `INSERTED`, `DELETED` rỗng.
- DELETE → dữ liệu bị xóa nằm trong `DELETED`, `INSERTED` rỗng.
- UPDATE → dòng cũ vào `DELETED`, dòng mới (sau khi sửa) vào `INSERTED`.
- Trigger loại `FOR`/`AFTER` chạy sau khi dữ liệu đã được ghi tạm vào bảng (trong 1 transaction ngầm).
  Nếu trong trigger gọi `ROLLBACK TRANSACTION`, SQL Server hủy luôn cả batch đang chạy
  (báo lỗi kiểu "The transaction ended in the trigger. The batch has been aborted.") — đây là
  hành vi bình thường, không phải bug.

## Vì sao không validate ở tầng ứng dụng (app) là đủ?

Tình huống thực tế đã tự tay gặp: gõ thẳng `INSERT INTO NHANVIEN VALUES(..., 'X')` trong
DataGrip — không hề đi qua app/form nào cả. Nếu validate chỉ nằm trong code ứng dụng thì
câu insert trực tiếp này sẽ chui thẳng vào bảng, không ai chặn.

Lý do: dữ liệu vào 1 bảng thường không chỉ đi qua đúng 1 con đường. Có thể có:
- Người gõ SQL tay để sửa data gấp.
- Một app khác cũng ghi vào cùng bảng đó.
- Script import dữ liệu hàng loạt.
- Dev mới viết thiếu 1 chỗ check ở 1 trong nhiều app/service.

Validate ở tầng ứng dụng phải được lặp lại **đúng ở mọi nơi** có thể ghi vào bảng — quên 1 chỗ
là thủng ngay ("chốt mềm"). Trigger/constraint nằm ngay tại bảng, trong database, nên bất kể
ai/con đường nào ghi vào bảng cũng phải đi qua nó, không né được ("chốt cứng" — lớp phòng thủ
cuối cùng).

## Ghi nhớ khi viết PRINT có dấu tiếng Việt

- Phải dùng `N'...'` (chữ **N hoa**, sát ngay trước dấu nháy) để SQL Server hiểu là chuỗi Unicode.
- `n'...'` (n thường) **không** hoạt động — SQL Server sẽ hiểu `n` là một định danh (identifier)
  đứng trước chuỗi và báo lỗi `The name "n" is not permitted in this context`. Đây là 1 trong ít
  chỗ T-SQL phân biệt hoa/thường ở mức token, không phải do collation.
