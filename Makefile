clean ::
	docker image rm nginx-lua-openresty

lint ::
	docker run --rm -i \
		-v "${PWD}"/.hadolint.yaml:/bin/hadolint.yaml \
		-e XDG_CONFIG_HOME=/bin hadolint/hadolint \
		< Dockerfile

build ::
	docker build -t nginx-lua-openresty .

shell ::
	docker run --rm -it --entrypoint=busybox --expose=8172 -p 8172:8172 \
		-e LUA_PATH="?.lua;/usr/local/openresty/lualib/?.lua;/usr/local/openresty/lualib/?/?.lua;/usr/local/openresty/site/lualib/?.lua;/usr/local/openresty/site/lualib/?/?.lua" \
		-v "${PWD}/example":/app nginx-lua-openresty sh

run ::
	docker run --rm -it --entrypoint=luajit --expose=8172 -p 80:80 -p 8172:8172 \
		-e LUA_PATH="?.lua;/usr/local/openresty/lualib/?.lua;/usr/local/openresty/lualib/?/?.lua;/usr/local/openresty/site/lualib/?.lua;/usr/local/openresty/site/lualib/?/?.lua" \
		-v "${PWD}/example":/app nginx-lua-openresty
		# -e "require('mobdebug').listen()"

serve ::
	docker run --rm -it -p 80:80 -v "${PWD}/example/www":/app nginx-lua-openresty

example ::
	docker run --rm -it -p 80:80 -v "${PWD}/example/www":/app \
		-v "${PWD}/example/conf/http2.conf":/usr/local/openresty/nginx/conf/http2.conf \
		-v "${PWD}/example/conf/server2.conf":/usr/local/openresty/nginx/conf/server2.conf \
		nginx-lua-openresty

tag ::
	docker tag nginx-lua-openresty prantlf/nginx-lua-openresty:latest

login ::
	docker login --username=prantlf

push ::
	docker push prantlf/nginx-lua-openresty:latest
