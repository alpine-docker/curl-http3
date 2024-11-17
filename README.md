# alpine/curl-http3

[If enjoy, please consider buying me a coffee.](https://www.buymeacoffee.com/ozbillwang)

A custom `curl` build with `brotli`, `BoringSSL` and `http3` support (via `quiche`) in **alpine image**.

[![DockerHub Badge](http://dockeri.co/image/alpine/curl-http3)](https://hub.docker.com/r/alpine/curl-http3/)

Follow up document: [Building and Testing Nginx HTTP/3 Support with Docker Compose](https://medium.com/towardsdev/building-and-testing-nginx-http-3-support-with-docker-compose-df30477f7460)

## Usage

```
# run on 14th Aug 2024
$ docker run -ti --rm alpine/curl-http3 curl -V

docker run -ti --rm alpine/curl-http3 curl -V
curl 8.9.1-DEV (x86_64-pc-linux-musl) libcurl/8.9.1-DEV BoringSSL zlib/1.3.1 brotli/1.1.0 nghttp2/1.62.1 quiche/0.22.0
Release-Date: [unreleased]
Protocols: dict file ftp ftps gopher gophers http https imap imaps ipfs ipns mqtt pop3 pop3s rtsp smb smbs smtp smtps telnet tftp
Features: alt-svc AsynchDNS brotli HSTS HTTP2 HTTP3 HTTPS-proxy IPv6 Largefile libz NTLM SSL threadsafe UnixSockets

# run with http3 supported with "--http3"
$ docker run -ti --rm alpine/curl-http3 curl --http3 -sI https://www.google.com

HTTP/3 200
content-type: text/html; charset=ISO-8859-1
content-security-policy-report-only: object-src 'none';base-uri 'self';script-src 'nonce-_kX-8y7rjr1XARNsb4yYlw' 'strict-dynamic' 'report-sample' 'unsafe-eval' 'unsafe-inline' https: http:;report-uri https://csp.withgoogle.com/csp/gws/other-hp
p3p: CP="This is not a P3P policy! See g.co/p3phelp for more info."
date: Wed, 14 Aug 2024 06:21:15 GMT
server: gws
x-xss-protection: 0
x-frame-options: SAMEORIGIN
expires: Wed, 14 Aug 2024 06:21:15 GMT
cache-control: private
set-cookie: AEC=AVYB7cqeXXSyhbtVPurzY8K4F0qmfMZclH4d23adB3RxMpHke11yB0EK5g; expires=Mon, 10-Feb-2025 06:21:15 GMT; path=/; domain=.google.com; Secure; HttpOnly; SameSite=lax
set-cookie: NID=516=gnr75ZvPMm_QXym1Hv2JBWsgDnEAK1FHACG7MBmdm8hekxrq3nPYRsQB2BC_VdalK16pei2slWFAYDw-3eeFocZKjgKVdEbEu9kW0AM6ggrxAqMYe_prHxz7I28azfCtbfdKC-GgT-Q_TImyksEhRASvMIfaAfZ2-hTJXJDFGlxNgniU4T73; expires=Thu, 13-Feb-2025 06:21:15 GMT; path=/; domain=.google.com; HttpOnly
alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000

```

```
$  docker run --rm alpine/curl-http3 curl -sIL https://blog.cloudflare.com --http3 -H 'user-agent: mozilla'
HTTP/3 200
(...)
```

Auto trigger with latest release and build a docker image with 

* [curl](https://github.com/curl/curl/releases)
* [QUICHE](https://github.com/cloudflare/quiche/releases)

### Multi-Arch support
	
* linux/amd64
* linux/arm64

### Repo:

https://github.com/alpine-docker/curl-http3

### Daily build logs:

https://github.com/alpine-docker/curl-http3/actions

### Docker iamge tags:

https://hub.docker.com/r/alpine/curl-http3/tags/

### The Processes to build this image

The Processes to build this image
* Enable CI cronjob on this repo to run build daily on master branch
* Check if there are new tags/releases announced via Github REST API
* Match the exist docker image tags via Hub.docker.io REST API
* build the image with latest version as tag and push to hub.docker.com
