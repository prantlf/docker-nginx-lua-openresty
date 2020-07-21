# prantlf/nginx-lua-openresty

[Docker] image: Nginx for web applications written in Lua on Alpine Linux

[![prantlf/nginx-lua-openresty](http://dockeri.co/image/prantlf/nginx-lua-openresty)](https://hub.docker.com/repository/docker/prantlf/nginx-lua-openresty/)

[This image] is supposed to run web applications using static assets and dynamic requests coded in [Lua] or as [Lua Pages]. This image is built automatically on the top of the tag `latest` from the [Alpine repository], so that it is always based on the latest [Alpine Linux]. The package [openresty] has to be updated from time to time by triggering a new build manually.

Lua packages included:

* [luafilesystem]
* [lua-resty-template]

## Tags

- [`latest`]

## Install

```
docker pull prantlf/nginx-lua-openresty
```

## Use

You can start by serving a web application consisting of static assets:

    cd ~/my-web-application
    docker run --rm -it -p 80:80 -v "${PWD}/www":/app nginx-lua-openresty

Then you continue by allowing [Lua Pages] to be authored:

    location ~ ^(.+\.lsp)(?:\?[^?]*)?$ {
      default_type text/html;
      set $page $1;
      content_by_lua_block {
        local template = require "resty.template"
        template.render_file(ngx.var.page)
      }
    }

That configuration will need to be saved to a file and included in the `server` context of the Nginx configuration:

    cd ~/my-web-application
    docker run --rm -it -p 80:80 -v "${PWD}/www":/app \
      -v "${PWD}/conf/server2.conf":/usr/local/openresty/nginx/conf/server2.conf \
      nginx-lua-openresty

You can ad other locations to `server2.conf` to server REST API or other dynamic content. If you need a global initialization code, you can add it to a file included in the `http` context, for example:

    # saved to conf/http2.conf
    init_by_lua_block {
      ...
    }

    cd ~/my-web-application
    docker run --rm -it -p 80:80 -v "${PWD}/www":/app \
      -v "${PWD}/conf/http2.conf":/usr/local/openresty/nginx/conf/http2.conf
      -v "${PWD}/conf/server2.conf":/usr/local/openresty/nginx/conf/server2.conf \
      nginx-lua-openresty

This image allows adding custom configuration to three Nginx contexts by replacing three files using volumes:

    /usr/local/openresty/nginx/conf/nginx2.conf  - main
    /usr/local/openresty/nginx/conf/http2.conf   - http
    /usr/local/openresty/nginx/conf/server2.conf - server

You can replace the whole default configuration or its part by using volumes too:

    /usr/local/openresty/nginx/conf/nginx.conf  - the whole configuration
    /usr/local/openresty/nginx/conf/http.conf   - the http section
    /usr/local/openresty/nginx/conf/server.conf - the server section

## Build, Test and Publish

The local image is built as `nginx-lua-openresty` and pushed to the docker hub as `prantlf/nginx-lua-openresty:latest`.

Remove an old local image:

    make clean

Check the `Dockerfile`:

    make lint

Build a new local image:

    make build

Enter an interactive shell inside the created image:

    make run

Test a sample web application:

    make example

Tag the local image for pushing:

    make tag

Login to the docker hub:

    make login

Push the local image to the docker hub:

    make push

## License

Copyright (c) 2020 Ferdinand Prantl

Licensed under the MIT license.

[Docker]: https://www.docker.com/
[This image]: https://hub.docker.com/repository/docker/prantlf/nginx-lua-openresty
[`latest`]: https://hub.docker.com/repository/docker/prantlf/nginx-lua-openresty/tags
[openresty]: https://openresty.org/en/apk-packages.html
[Alpine repository]: https://hub.docker.com/_/alpine
[Alpine Linux]: https://alpinelinux.org/
[Lua Pages]: https://github.com/bungle/lua-resty-template#example
[luafilesystem]: https://github.com/spacewander/luafilesystem#readme
[lua-resty-template]: https://github.com/bungle/lua-resty-template#readme
