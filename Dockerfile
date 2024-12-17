# Stage 1: Build Stage for the UI (React frontend)
FROM node:18 AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the project files
COPY . .

# Build the project
RUN npm run build

# Stage 2: Runtime Stage
FROM nginx:1.23-alpine

# Set working directory in NGINX
WORKDIR /usr/share/nginx/html

# Clean the default NGINX content
RUN rm -rf ./*

# Copy built files from the first stage
COPY --from=builder /app/build .

# Copy custom NGINX configuration if needed
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for serving the application
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
