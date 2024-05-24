{{/*
Return the composed name for base config shared acros multiple services
*/}}
{{- define "taiga.baseConfigName" -}}
{{- printf "%s-%s" .Release.Name "config" | trunc 55 | trimSuffix "-" }}
{{- end -}}

{{/*
Create the base config for the Taiga services
*/}}
{{- define "taiga.config.gateway" -}}
server {
    listen 80 default_server;

    client_max_body_size 100M;
    charset utf-8;

    # Frontend
    location / {
        proxy_pass http://{{ .Release.Name }}-front/;
        proxy_pass_header Server;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Scheme $scheme;
    }

    # API
    location /api/ {
        proxy_pass http://{{ .Release.Name }}-back:8000/api/;
        proxy_pass_header Server;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Scheme $scheme;
    }

    # Admin
    location /admin/ {
        proxy_pass http://{{ .Release.Name }}-back:8000/admin/;
        proxy_pass_header Server;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Scheme $scheme;
    }

    # Static
    location /static/ {
        alias /taiga/static/;
    }

    # Media
    location /_protected/ {
        internal;
        alias /taiga/media/;
        add_header Content-disposition "attachment";
    }

    # Unprotected section
    location /media/exports/ {
        alias /taiga/media/exports/;
        add_header Content-disposition "attachment";
    }

    location /media/ {
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Scheme $scheme;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://{{ .Release.Name }}-protected:8003/;
        proxy_redirect off;
    }

    # Events
    location /events {
        proxy_pass http://{{ .Release.Name }}-events:8888/events;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_connect_timeout 7d;
        proxy_send_timeout 7d;
        proxy_read_timeout 7d;
    }
}
{{- end -}}
