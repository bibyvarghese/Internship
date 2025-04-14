# Use official Node.js LTS image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy only the package files first to install dependencies
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Create the uploads folder (for file uploads) if it doesn't exist
RUN mkdir -p uploads

# Expose port the app runs on
EXPOSE 3000

# Set environment variable for production (optional)
ENV NODE_ENV=development

# Start the server
CMD ["node", "server.js"]
