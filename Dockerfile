# not using tag "as bulider" due to AWS issue.
FROM node:alpine
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . . 
# don't use volume system as we are not changing code in production image.
RUN npm run build

# build output path will be /app/build

# second phase, only one FROM allowed per block
FROM nginx
# now copy build output
# since AWS fails with "as tag" format can't use:
# COPY --from=builder
# So instead use index to access instead
# Default nginx static output directory
# This removes all initial build details minus the build output
COPY --from=0 /app/build /usr/share/nginx/html

# nginx image auto launches nginx, no need to run a command