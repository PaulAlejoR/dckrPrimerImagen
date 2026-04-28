# 1 Primer stage: deps que solo se encarga de instalar las dependencias
# cada stage se identifica con la palabra AS y el nombre del stage, en este caso deps
# /app /usr /lib
FROM node:20-alpine3.16 as deps
# esto es como cd a /app
WORKDIR /app
COPY package.json ./
# Se instala las dependencias
RUN npm install


# 2 Segundo stage: builder, se encarga de copiar los archivos y hacer el testing
FROM node:20-alpine3.16 as builder
WORKDIR /app
# También se puede usar ./ para indicar el directorio 
# Esta línea copia todo lo que tuvimos en el stage 'deps' del directorio /app/node_modules y lo copia en el directorio /app/node_modules del stage 'builder'
COPY --from=deps /app/node_modules /app/node_modules
COPY . .
RUN npm run test


# 3 Tercer stage: production, se encarga de instalar y descargar las dependencias de producción
FROM node:20-alpine3.16 as prod-deps
WORKDIR /app
COPY package.json ./
RUN npm install --prod


# 4 Cuarto stage: runner, se encarga de copiar las dependencias de producción y ejecutar la aplicación
FROM node:20-alpine3.16 as runner
WORKDIR /app
COPY --from=prod-deps /app/node_modules /app/node_modules
COPY app.js ./
# Se copia el directorio del host al contenedor, creando el directorio con el mismo nombre y se copian los archivos
COPY tasks/ ./tasks
# Comando run de la imagen
CMD [ "node", "app.js" ]