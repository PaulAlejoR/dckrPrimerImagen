# /app /usr /lib
# Línea para el forzado de la construcción de imagen en alguna arquitectura no nativa
# FROM --platform=arm64 node:20-alpine3.16
# Línea para poder agregar más arquitecturas de nuestro buildx 
FROM --platform=$BUILDPLATFORM node:20-alpine3.16
# FROM node:20-alpine3.16

# esto es como cd a /app
WORKDIR /app

# el source es el código que hace que funcione con configuraciones, etc.
# el destino es el último lugar donde se va a colocar
# con ./ se esta apuntando a que el destino sea /app
#COPY app.js package.json ./

# DOCKER CONSTUYE UNA IMAGEN EN CAPAS (INSTRUCCIONES DE ESTE ARCHIVO) Y CADA CAPA SE GUARDA EN CACHE, SI UNA INSTRUCCIÓN (CAPA) NO CAMBIA
# SE SALTA ESA CAPA Y TODAS LAS DEMAS CAPAS DESPUES DE ESA SE VUELVEN A EJECUTAR, POR ESO EL ORDEN IMPORTA Y SE PONEN LAS INSTRUCCIONES QUE MENOS CAMBIAN
# Y DESPUÉS LAS QUE CAMBIAN MÁS COMO EL CÓDIGO.


# Por esa razón se separo la instrucción COPY app.js package.json ./ porque esta es una sola instrucción y primero revisa el código si tuvo cambios y se reconstruye
# y si el segundo archivo no tuvo cambios tiene que volver a instalar dependencias porque esta atada a la instrucción.


COPY package.json ./

# Se instala las dependencias
RUN npm install

# Destino /app
# Este COPY es un parche temporal ya que agrega todo lo que tenga el directorio actual donde esta el Dockerfile y lo agrega en el directorio del contenedor que es /app
COPY . .

# Realizar testing, comando para las pruebas
RUN npm run test

# Despues de hacer el testing, se eliminan archivos y directorios innecesarios en PRODUCTION
RUN rm -rf tests && rm -rf node_modules

# Se vuelven a construir las dependencias pero solo las de pr
RUN npm install --prod


# Comando run de la imagen
CMD [ "node", "app.js" ]