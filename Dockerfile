FROM debian:stable-slim
LABEL Description="nginx with lua" Version="1.0.0" Tags="nginx"
RUN groupadd -r -g 500 nginx && useradd -r -g nginx -u 500 nginx \
    && mkdir -p /home/nginx && chown -R nginx:nginx /home/nginx
			
WORKDIR /home/nginx
RUN apt-get update
RUN apt-get install -y wget make gcc libpcre3 libpcre3-dev zlib1g-dev
			
RUN wget http://luajit.org/download/LuaJIT-2.1.0-beta3.tar.gz
RUN tar xzf LuaJIT-2.1.0-beta3.tar.gz
RUN cd LuaJIT-2.1.0-beta3 && make && make install
			
WORKDIR /home/nginx
RUN wget https://github.com/simpl/ngx_devel_kit/archive/v0.3.0.tar.gz -O ngx_devel_kit-v0.3.0.tar.gz
RUN tar xzf ngx_devel_kit-v0.3.0.tar.gz
RUN cd ngx_devel_kit-0.3.0
			
WORKDIR /home/nginx
RUN wget https://github.com/openresty/lua-nginx-module/archive/v0.10.12rc1.tar.gz -O lua-nginx-module-v0.10.12rc1.tar.gz
RUN tar xzf lua-nginx-module-v0.10.12rc1.tar.gz
RUN cd lua-nginx-module-0.10.12rc1
			
WORKDIR /home/nginx
RUN wget http://nginx.org/download/nginx-1.13.8.tar.gz
RUN tar xzf nginx-1.13.8.tar.gz
RUN cd nginx-1.13.8 && \
  export LUAJIT_LIB=/usr/local/lib && \
  export LUAJIT_INC=/usr/local/include/luajit-2.1 && \
  ./configure --prefix=/opt/nginx \
  --with-ld-opt="-Wl,-rpath,/usr/local/lib" \
  --add-module=/home/nginx/ngx_devel_kit-0.3.0 \
  --add-module=/home/nginx/lua-nginx-module-0.10.12rc1 && \
 make && make install
			
			
USER nginx

ENTRYPOINT /bin/bash
