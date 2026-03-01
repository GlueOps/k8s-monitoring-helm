{{/*
Expand the name of the chart.
*/}}
{{- define "developer-dashboards.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "developer-dashboards.labels" -}}
helm.sh/chart: {{ include "developer-dashboards.name" . }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: glueops-monitoring
{{- end }}

{{/*
Sanitize a name for use in Kubernetes resource names.
Converts to lowercase, replaces non-alphanumeric with dashes, trims.
*/}}
{{- define "developer-dashboards.sanitizeName" -}}
{{- . | lower | replace " " "-" | replace "_" "-" | trunc 63 | trimSuffix "-" }}
{{- end }}
