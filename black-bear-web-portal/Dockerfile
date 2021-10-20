# FROM node:12.13.1-alpine AS build
# COPY . /blackBear/portalSource
# WORKDIR /blackBear/portalSource
# RUN  npm install --no-cache && npm run build

# FROM seangalloway/black_bear
# RUN opkg update
# RUN rm /www/index.html
# COPY --from=build /blackBear/portalSource/build /www
# EXPOSE 80

FROM seangalloway/black_bear
RUN opkg update
RUN opkg install node-npm
COPY . /blackBear/portalSource/
WORKDIR /blackBear/portalSource/
RUN npm install --no-cache && npm run build
RUN rm /www/index.html
RUN cp -R ./build/* /www
EXPOSE 80