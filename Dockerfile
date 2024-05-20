# Define node version
FROM node:16-alpine3.15

# Copy files
COPY . .

RUN npm install express

RUN npm install

# Give permissions to node_modules
RUN chown -R node ./node_modules

# Set running user
USER node

# Run Application
CMD [ "node", "server"]