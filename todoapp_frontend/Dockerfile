# Menggunakan Node.js sebagai base image
FROM node:18 AS build

# Set working directory di dalam container
WORKDIR /app

# Menyalin file package.json dan package-lock.json ke dalam container
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Menyalin semua file proyek ke dalam container
COPY . .

# Build aplikasi React untuk produksi
RUN npm run build

# Menggunakan Nginx untuk menjalankan aplikasi frontend yang sudah dibuild
FROM nginx:alpine

# Menghapus file default nginx
RUN rm -rf /usr/share/nginx/html/*

# Menyalin hasil build dari tahap sebelumnya ke folder nginx
COPY --from=build /app/build /usr/share/nginx/html

# Mengekspos port 80 untuk aplikasi frontend
EXPOSE 80

# Menjalankan nginx pada container
CMD ["nginx", "-g", "daemon off;"]
