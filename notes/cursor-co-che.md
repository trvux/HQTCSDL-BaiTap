# Cursor trong T-SQL — cơ chế hoạt động

Cursor = cách duyệt kết quả của 1 `SELECT` từng dòng một, thay vì xử lý cả tập cùng lúc.
(Đây là mô hình ở mức T-SQL, không phải cấu trúc nội bộ của engine — phần đó phụ thuộc loại
cursor STATIC/KEYSET/DYNAMIC và phiên bản SQL Server.)

## 1. DECLARE — chỉ ghi nhớ "công thức"

```
DECLARE c CURSOR FOR SELECT MAGIAO FROM PHIEUGIAOHANG ORDER BY MAGIAO
      |
      v
  [ chi luu "cong thuc" cua cau SELECT, CHUA chay ]
```

## 2. OPEN — chạy SELECT, con trỏ đứng TRƯỚC dòng đầu

```
OPEN c
      |
      v
  ket qua SELECT (da sap xep)           con tro
  +--------+
  | GH01   |   <---- dong 1              (dang dung o day, TRUOC dong 1)
  | GH02   |   <---- dong 2                      |
  | GH04   |   <---- dong 3                      v
  | GH05   |   <---- dong 4              [BOF] truoc dong dau
  +--------+
```

## 3. FETCH NEXT — nhích 1 dòng + copy giá trị vào biến

Biến (`@ma`) là chỗ DUY NHẤT mày đọc được dữ liệu dòng hiện tại.

```
FETCH NEXT #1                         FETCH NEXT #2
  +--------+                            +--------+
  | GH01   | <-- con tro                | GH01   |
  | GH02   |      |                     | GH02   | <-- con tro
  | GH04   |      v                     | GH04   |      |
  | GH05   |   @ma = 'GH01'             | GH05   |      v
  +--------+                            +--------+   @ma = 'GH02'
```

## 4. @@FETCH_STATUS — biết khi nào dừng

`0` = lấy được dòng, `-1` = đã trượt qua dòng cuối (hết dòng).

```
        OPEN c
          |
          v
   FETCH NEXT INTO @ma  <-----------------+
          |                               |
          v                               |
   @@FETCH_STATUS = 0 ?                   |
      |            |                      |
     YES          NO (-1)                 |
      |            |                      |
      v            v                      |
  xu ly @ma     thoat vong lap            |
  (ban lam gi   |                         |
   voi dong     v                         |
   nay)      CLOSE c                      |
      |      DEALLOCATE c                 |
      +-----> FETCH NEXT tiep -----------+
```

Có 2 chỗ FETCH: 1 lần TRƯỚC `WHILE`, 1 lần Ở CUỐI thân vòng lặp.
- Thiếu lần cuối -> `@@FETCH_STATUS` không đổi -> lặp vô hạn.
- Thiếu lần đầu -> `WHILE` kiểm tra khi `@@FETCH_STATUS` chưa phản ánh dòng đầu.

## 5. Hết dòng

```
  | GH05   |
  +--------+
      |
      v
   [EOF] sau dong cuoi  ->  FETCH khong co dong  ->  @@FETCH_STATUS = -1
```

## 6. Dọn dẹp

- `CLOSE c` — giải phóng tập kết quả, còn giữ định nghĩa (có thể `OPEN` lại).
- `DEALLOCATE c` — xoá hẳn định nghĩa. Quên -> chạy lại procedure báo "cursor already exists".
