# Define node version
FROM node:16-alpine3.15

# Copy files
COPY . .

RUN npm install express
RUN npm install
RUN npm install pm2 -g

# Give permissions to node_modules
RUN chown -R node ./node_modules

# Set running user
USER node

# Run Application
CMD [ "pm2-runtime", "ecosystem.config.js" ]