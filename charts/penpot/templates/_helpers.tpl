{{/*
Return the composed name for base config shared acros multiple services
*/}}
{{- define "penpot.baseConfigName" -}}
{{- printf "%s-%s" .Release.Name "config" | trunc 63 | trimSuffix "-" }}
{{- end -}}
