# Môn Hệ quản trị Cơ sở dữ liệu — bài tập thực hành

## Thông tin sinh viên
- Họ tên: Huỳnh Bảo Huy
- MSSV: 207ct55065
- Lớp: 261_71ITIS30203_0101 (đề bài luôn chọn theo lớp **0101**, không phải 0102, khi PDF có
  đề riêng cho từng lớp)
- GitHub repo bài nộp: https://github.com/trvux/HQTCSDL-BaiTap

## Cấu trúc thư mục
Mỗi buổi là 1 folder `BuoiN/` (không dấu cách, không hậu tố) ngay tại root repo này, chứa:
- `BuoiN_Bai tap Thuc hanh He quan tri CSDL.pdf` — đề bài
- `BuoiN_Huong dan Thuc hanh He quan tri CSDL.pdf` — hướng dẫn lý thuyết + cú pháp mẫu
- `Database <TEN_SCHEMA>/` — script mẫu cô cho sẵn (`CREATEDATABASE.sql`, `DROPDATABASE.sql`,
  `USEDATABASE.sql`), tên database trong đó có placeholder `MSSV` cần thay bằng `207ct55065`
  (hoặc `207CT55065` tùy buổi, giữ nguyên case gốc của teacher's script).
- File bài nộp đặt ngay trong `BuoiN/`, tên theo đúng convention:
  `<Lop>-<MSSV>-<HoTenKhongDau>-Assignment-SessionN.sql`
  (ví dụ: `0101-207ct55065-HuynhBaoHuy-Assignment-Session3.sql`)

Bản gốc chưa chỉnh sửa của từng buổi (file zip cô gửi, giải nén) còn nằm ở
`../Buoi N Thuc hanh He quan tri CSDL/` (thư mục cha, ngoài repo git này) — nếu cần đối chiếu đề
gốc thì lấy ở đó, nhưng thao tác/sửa bài luôn làm trong `BuoiN/` bên trong repo.

## Quy ước đặt tên Database
Theo mẫu trong `CREATEDATABASE.sql` của mỗi buổi: `<TENSCHEMA_KHONG_DAU>_B<N>_<MSSV>`
Ví dụ buổi 3: `QUANLYCHUCVU_B3_207ct55065`.

## DataGrip — quy ước làm việc
- **Mỗi buổi/mỗi database = 1 Data Source riêng** trong DataGrip (không dùng chung 1 connection
  cho nhiều buổi). Data Source đặt tên `<tendatabase>@localhost`.
- Cách tạo nhanh: right-click 1 data source có sẵn → `Copy/Paste` → `Paste` (= Duplicate) →
  sửa `Database` field (tạm để `master` nếu DB chưa tồn tại) → sửa `Name` → Test Connection →
  chạy `CREATE DATABASE ...` → quay lại sửa `Database` field thành tên DB thật.
- Nút Run (▷) / Cmd+Enter chỉ chạy **statement đang chọn/tại con trỏ**, không tự chạy hết file.
  Muốn chạy nhiều statement liên tiếp: bôi đen cả đoạn rồi Cmd+Enter.
- SQL Server dùng `N'...'` (chữ N hoa, sát dấu nháy) cho chuỗi Unicode/có dấu — `n'...'` thường
  KHÔNG hoạt động (lỗi "the name n is not permitted").
- Cảnh báo đỏ kiểu "Unable to resolve table" trong editor thường chỉ là do chưa chọn database ở
  dropdown `<database>` đầu file, hoặc data source chưa introspect schema — không phải lỗi chạy
  thật, cứ chọn đúng database ở dropdown / Refresh data source là hết.

## Cách hướng dẫn khi làm bài (áp dụng mọi buổi trong repo này)
Sinh viên yêu cầu **chế độ Socratic Cognitive Coach** khi làm bài tập ở đây — xem chi tiết đầy đủ
tại `notes/socratic-coaching-rule.md`. Tóm tắt:
- Khi hỏi 1 CONCEPT/kỹ thuật (không phải fact đơn giản): đừng đưa đáp án ngay — hỏi ngược 1 câu
  hoặc đưa 1 tình huống cụ thể để tự suy luận trước.
- Khi hỏi fact đơn giản (cú pháp, số liệu, định nghĩa ngắn) hoặc gõ rõ "trả lời thẳng"/"gấp": trả
  lời thẳng, không vòng vo.
- Không tự viết sẵn code lời giải cho sinh viên — để họ tự gõ, chỉ review/sửa lỗi khi họ đã thử.
- Sinh viên chưa học lý thuyết trước khi thực hành — có thể chưa biết cú pháp/khái niệm nền, cứ
  giải thích từ gốc khi cần (xem `notes/` để biết những gì đã giải thích rồi, tránh lặp lại).

## Ghi chú / kiến thức đã học
Xem thư mục `notes/` — mỗi khái niệm quan trọng đã giải thích trong lúc làm bài được note lại ở
đây để buổi sau không phải hỏi lại từ đầu.
- `notes/trigger-vs-app-validation.md` — cơ chế INSERTED/DELETED, vì sao cần trigger ở DB thay vì
  chỉ validate ở app.
