# Stage 1: Build Flutter Web
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy Flutter project
COPY . .

# Get dependencies
RUN flutter pub get

# Build Flutter Web
RUN flutter build web --release


# Stage 2: Serve Flutter Web
FROM nginx:alpine

# Copy Flutter web build
COPY --from=build /app/build/web /usr/share/nginx/html

# Render uses the PORT environment variable
RUN sed -i 's/listen       80;/listen       10000;/' /etc/nginx/conf.d/default.conf

EXPOSE 10000

CMD ["nginx", "-g", "daemon off;"]