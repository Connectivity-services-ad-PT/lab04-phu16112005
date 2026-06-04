FROM python:3.10-slim

# Thiết lập thư mục làm việc trong container
WORKDIR /app

# Khởi tạo user hệ thống non-root để đảm bảo bảo mật
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Sao chép và cài đặt thư viện Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Sao chép toàn bộ mã nguồn vào container
COPY src/ ./src

# Cấp quyền sở hữu thư mục cho user non-root
RUN chown -R appuser:appgroup /app

# Chuyển sang sử dụng user non-root
USER appuser

# Cấu hình biến môi trường mặc định
ENV PORT=8000
ENV HOST=0.0.0.0

# Khai báo cổng lắng nghe bên trong mạng của Docker
EXPOSE 8000

# Lệnh khởi chạy ứng dụng chính thức (Dòng bạn hỏi nằm ở đây)
CMD ["python", "-m", "uvicorn", "iot_app.main:app", "--app-dir", "src", "--host", "0.0.0.0", "--port", "8000"]