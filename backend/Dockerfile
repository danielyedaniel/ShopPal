# Use the Node.js image as the base image
FROM node:14

# Set the working directory in the container
WORKDIR /app

# Copy the package.json file to install dependencies
COPY package.json .

# Install the dependencies
RUN npm install

# Copy the rest of the Express server code
COPY . .

# Expose port 3000 for incoming traffic
EXPOSE 3000

# Set the command to start the Express server
CMD ["npm", "start"]

# need to add env file to run server
# docker run --env-file .env -p 3000:3000 shoppal-server