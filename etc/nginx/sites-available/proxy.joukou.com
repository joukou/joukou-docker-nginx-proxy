# Copyright 2014 Joukou Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Redirect http://*.joukou.{com,co.nz,.co,.net} -> https://*.joukou.com
#

server {
  listen 8080;
  server_name .joukou.com .joukou.co.nz .joukou.co .joukou.net;
  rewrite ^ https://joukou.com$request_uri? permanent;
}

server {
  listen 8080;
  server_name api.joukou.com api.joukou.co.nz api.joukou.co api.joukou.net;
  rewrite ^ https://api.joukou.com$request_uri? permanent;
}

server {
  listen 8080;
  server_name apidoc.joukou.com apidoc.joukou.co.nz apidoc.joukou.co apidoc.joukou.net;
  rewrite ^ https://apidoc.joukou.com$request_uri? permanent;
}

server {
  listen 8080;
  server_name cadvisor.joukou.com cadvisor.joukou.co.nz cadvisor.joukou.co cadvisor.joukou.net;
  rewrite ^ https://cadvisor.joukou.com$request_uri? permanent;
}

server {
  listen 8080;
  server_name elasticsearch.joukou.com elasticsearch.joukou.co.nz elasticsearch.joukou.co elasticsearch.joukou.net;
  rewrite ^ https://elasticsearch.joukou.com$request_uri? permanent;
}

server {
  listen 8080;
  server_name mq.joukou.com mq.joukou.co.nz mq.joukou.co mq.joukou.net;
  rewrite ^ https://mq.joukou.com$request_uri? permanent;
}

server {
  listen 8080;
  server_name riak.joukou.com riak.joukou.co.nz riak.joukou.co riak.joukou.net;
  rewrite ^ https://riak.joukou.com$request_uri? permanent;
}

#
# Redirect https://*.joukou.{co.nz,co,net} -> https://*.joukou.com
#

server {
  listen 8443 ssl;
  server_name .joukou.co.nz .joukou.co .joukou.net;
  ssl_certificate /etc/ssl/private/wildcard.joukou.com.crt;
  ssl_certificate_key /etc/ssl/private/wildcard.joukou.com.key;
  rewrite ^ https://joukou.com$request_uri? permanent;
}

server {
  listen 8443 ssl;
  server_name api.joukou.co.nz api.joukou.co api.joukou.net;
  ssl_certificate /etc/ssl/private/wildcard.joukou.com.crt;
  ssl_certificate_key /etc/ssl/private/wildcard.joukou.com.key;
  rewrite ^ https://api.joukou.com$request_uri? permanent;
}

server {
  listen 8443 ssl;
  server_name apidoc.joukou.co.nz apidoc.joukou.co apidoc.joukou.net;
  ssl_certificate /etc/ssl/private/wildcard.joukou.com.crt;
  ssl_certificate_key /etc/ssl/private/wildcard.joukou.com.key;
  rewrite ^ https://apidoc.joukou.com$request_uri? permanent;
}

server {
  listen 8443 ssl;
  server_name cadvisor.joukou.co.nz cadvisor.joukou.co cadvisor.joukou.net;
  ssl_certificate /etc/ssl/private/wildcard.joukou.com.crt;
  ssl_certificate_key /etc/ssl/private/wildcard.joukou.com.key;
  rewrite ^ https://cadvisor.joukou.com$request_uri? permanent;
}

server {
  listen 8443 ssl;
  server_name elasticsearch.joukou.co.nz elasticsearch.joukou.co elasticsearch.joukou.net;
  ssl_certificate /etc/ssl/private/wildcard.joukou.com.crt;
  ssl_certificate_key /etc/ssl/private/wildcard.joukou.com.key;
  rewrite ^ https://elasticsearch.joukou.com$request_uri? permanent;
}

server {
  listen 8443 ssl;
  server_name mq.joukou.co.nz mq.joukou.co mq.joukou.net;
  ssl_certificate /etc/ssl/private/wildcard.joukou.com.crt;
  ssl_certificate_key /etc/ssl/private/wildcard.joukou.com.key;
  rewrite ^ https://mq.joukou.com$request_uri? permanent;
}

server {
  listen 8443 ssl;
  server_name riak.joukou.co.nz riak.joukou.co riak.joukou.net;
  ssl_certificate /etc/ssl/private/wildcard.joukou.com.crt;
  ssl_certificate_key /etc/ssl/private/wildcard.joukou.com.key;
  rewrite ^ https://riak.joukou.com$request_uri? permanent;
}

#
# SSL SNI name based virtual hosts
#
# joukou-control: static files in /var/www/joukou.com
# joukou-api: http://localhost:2101 is staging. http://localhost:2201 is production.
# joukou-fbpp: http://localhost:2102 is staging. http://localhost:2202 is production.

server {
  listen 8443 ssl;
  server_name .joukou.com;
  ssl_certificate /etc/ssl/private/wildcard.joukou.com.crt;
  ssl_certificate_key /etc/ssl/private/wildcard.joukou.com.key;

  location / {
    proxy_pass http://control.production.akl1.joukou.local:8080;
  }

  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }
}

server {
  listen 8443 ssl;
  server_name api.joukou.com;
  ssl_certificate /etc/ssl/private/wildcard.joukou.com.crt;
  ssl_certificate_key /etc/ssl/private/wildcard.joukou.com.key;

  location / {
    proxy_pass http://api.production.akl1.joukou.local:2201;
  }

  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }
}

server {
  listen 8443 ssl;
  server_name apidoc.joukou.com;
  ssl_certificate /etc/ssl/private/wildcard.joukou.com.crt;
  ssl_certificate_key /etc/ssl/private/wildcard.joukou.com.key;

  location / {
    proxy_pass http://apidoc.production.akl1.joukou.local:8080;
  }

  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }
}

server {
  listen 8443 ssl;
  server_name cadvisor.joukou.com;
  ssl_certificate /etc/ssl/private/wildcard.joukou.com.crt;
  ssl_certificate_key /etc/ssl/private/wildcard.joukou.com.key;

  location / {
    proxy_pass http://cadvisor.production.akl1.joukou.local:8080;
    auth_basic "Restricted";
    auth_basic_user_file /etc/nginx/joukou.com.htpasswd;
  }

  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }
}

server {
  listen 8443 ssl;
  server_name elasticsearch.joukou.com;
  ssl_certificate /etc/ssl/private/wildcard.joukou.com.crt;
  ssl_certificate_key /etc/ssl/private/wildcard.joukou.com.key;

  location / {
    proxy_pass http://elasticsearch.production.akl1.joukou.local:9200;
  }

  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }
}

server {
  listen 8443 ssl;
  server_name mq.joukou.com;
  ssl_certificate /etc/ssl/private/wildcard.joukou.com.crt;
  ssl_certificate_key /etc/ssl/private/wildcard.joukou.com.key;

  location / {
    proxy_pass http://rabbitmq.production.akl1.joukou.local:15672;
    auth_basic "Restricted";
    auth_basic_user_file /etc/nginx/joukou.com.htpasswd;
  }

  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }
}

server {
  listen 8443 ssl;
  server_name riak.joukou.com;
  ssl_certificate /etc/ssl/private/wildcard.joukou.com.crt;
  ssl_certificate_key /etc/ssl/private/wildcard.joukou.com.key;

  location / {
    proxy_pass http://riak.production.akl1.joukou.local:8098;
    auth_basic "Restricted";
    auth_basic_user_file /etc/nginx/joukou.com.htpasswd;
  }

  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }
}
