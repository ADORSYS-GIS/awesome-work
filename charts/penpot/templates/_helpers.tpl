{{/*
Expand the name of the chart.
*/}}
{{- define "penpot.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "penpot.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "penpot.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "penpot.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "penpot.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}




{{/*
Return the frontend ingress anotation
*/}}
{{- define "frontend.ingress.annotations" -}}
{{ .Values.frontend.ingress.annotations | toYaml }}
{{- end -}}

{{/*
Return the backend ingress anotation
*/}}
{{- define "backend.ingress.annotations" -}}
{{ .Values.backend.ingress.annotations | toYaml }}
{{- end -}}

{{/*
Return the ingress hostname
*/}}
{{- define "frontend.ingress.hostname" -}}
{{- tpl .Values.frontend.ingress.hostname $ -}}
{{- end -}}

{{/*
Return the api ingress hostname
*/}}
{{- define "frontend.apiIngress.hostname" -}}
{{- tpl .Values.backend.ingress.hostname $ -}}
{{- end -}}