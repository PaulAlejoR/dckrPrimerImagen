# /app /usr /lib
FROM node:19.2-alpine3.16

# esto es como cd a /app
WORKDIR /app

# el source es el código que hace que funcione con configuraciones, etc.
# el destino es el último lugar donde se va a colocar
# con ./ se esta apuntando a que el destino sea /app
COPY app.js package.json ./

# Se instala las dependencias
RUN npm install


# Comando run de la imagen
CMD [ "node", "app.js" ]