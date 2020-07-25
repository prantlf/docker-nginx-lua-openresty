# prantlf/nginx-lua-openresty

[Docker] image: Nginx for web applications written in Lua on Alpine Linux

[![prantlf/nginx-lua-openresty](http://dockeri.co/image/prantlf/nginx-lua-openresty)](https://hub.docker.com/repository/docker/prantlf/nginx-lua-openresty/)

[This image] is supposed to run web applications using static assets and dynamic requests coded in [Lua] or as [Lua Pages]. This image is built automatically on the top of the tag `latest` from the [Alpine repository], so that it is always based on the latest [Alpine Linux]. The package [openresty] has to be updated from time to time by triggering a new build manually.

Additional Lua packages included:

* [lsqlite3complete] - sqlite3 suport
* [luafilesystem] - directory listing and file locking
* [lua-resty-cors] - cross-origin request support
* [lua-resty-hmac] - required by lua-resty-jwt``
* [lua-resty-jwt] - secure session tokens
* [lua-resty-libbase64] - fast base64 encoding and decoding
* [lua-resty-libr3] - fast router
* [lua-resty-murmurhash2] - fast hashes
* [lua-resty-random] - secure random numbers
* [lua-resty-session] - cookie-based sessions
* [lua-resty-template] - page templates
* [lua-resty-uuid] - safe unique identifiers
* [pgmoon] - postgres support

## Tags

- [`latest`]

## Install

```
docker pull prantlf/nginx-lua-openresty
```

## Use

You can serve a web application consisting of both [Lua Pages] and static assets:

    cd ~/my-web-application
    docker run --rm -it -p 80:80 -v "${PWD}/www":/app nginx-lua-openresty

You can add locations to `server2.conf` to serve REST API or other dynamic content. If you need a global initialization code, you can add it to a file included in the `http` context. Then you need to pass the files to the container as volumes:

    cd ~/my-web-application
    docker run --rm -it -p 80:80 -v "${PWD}/www":/app \
      -v "${PWD}/conf/http2.conf":/usr/local/openresty/nginx/conf/http2.conf
      -v "${PWD}/conf/server2.conf":/usr/local/openresty/nginx/conf/server2.conf \
      nginx-lua-openresty

Default content of `http2.conf`:

    init_by_lua_block {
      template = require "resty.template"
    }

Default content of `server2.conf`:

    location ~ ^(.+\.lsp)(?:\?[^?]*)?$ {
      default_type text/html;
      set $page $1;
      content_by_lua_block {
        local template = require "resty.template"
        template.render_file(ngx.var.page)
      }
    }

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

Test a default web application:

    make serve

Test a customized web application:

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
[lsqlite3complete]: http://lua.sqlite.org/
[luafilesystem]: https://github.com/spacewander/luafilesystem#readme
[lua-resty-cors]: https://github.com/detailyang/lua-resty-cors
[lua-resty-hmac]: https://github.com/jkeys089/lua-resty-hmac
[lua-resty-jwt]: https://github.com/cdbattags/lua-resty-jwt
[lua-resty-libbase64]: https://github.com/bungle/lua-resty-libbase64
[lua-resty-libr3]: https://github.com/iresty/lua-resty-libr3
[lua-resty-murmurhash2]: https://github.com/bungle/lua-resty-murmurhash2
[lua-resty-random]: https://github.com/bungle/lua-resty-random
[lua-resty-session]: https://github.com/bungle/lua-resty-session
[lua-resty-template]: https://github.com/bungle/lua-resty-template#readme
[lua-resty-uuid]: https://github.com/bungle/lua-resty-uuid
[pgmoon]: https://github.com/leafo/pgmoon
