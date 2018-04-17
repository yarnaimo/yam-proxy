keepalive_timeout    70;
sendfile             on;
client_max_body_size 8m;

root /mastodon/public;

gzip on;
gzip_disable "msie6";
gzip_vary on;
gzip_proxied any;
gzip_comp_level 6;
gzip_buffers 16 8k;
gzip_http_version 1.1;
gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

add_header Strict-Transport-Security "max-age=31536000";

# location / {
#   try_files $uri @proxy;
# }

location ~ ^/(emoji|packs|system/accounts/avatars|system/media_attachments/files) {
  add_header Cache-Control "public, max-age=31536000, immutable";
  try_files $uri @proxy;
}

location /sw.js {
  add_header Cache-Control "public, max-age=0";
  try_files $uri @proxy;
}

location @proxy {
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Proto https;
  proxy_set_header Proxy "";
  proxy_pass_header Server;

  proxy_pass http://typrout.ml;
  proxy_buffering off;
  proxy_redirect off;
  proxy_http_version 1.1;

  tcp_nodelay on;
}

location /api/v1/streaming {
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Proto https;
  proxy_set_header Proxy "";

  proxy_pass http://streaming.typrout.ml;
  proxy_buffering off;
  proxy_redirect off;
  proxy_http_version 1.1;

  tcp_nodelay on;
}

error_page 500 501 502 503 504 /500.html;
