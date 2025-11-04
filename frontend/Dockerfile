# Usa la imagen base oficial de NGINX
FROM nginx:latest

# Elimina la página por defecto de NGINX
RUN rm -rf /usr/share/nginx/html/*

# Copia el contenido de tu carpeta 'sitio' al directorio público de NGINX
COPY sitio/ /usr/share/nginx/html/

# Copia también tus recursos (opcional)
COPY Resours/ /usr/share/nginx/html/Resours/

# Expone el puerto 80
EXPOSE 80

# Inicia NGINX en primer plano
CMD ["nginx", "-g", "daemon off;"]
