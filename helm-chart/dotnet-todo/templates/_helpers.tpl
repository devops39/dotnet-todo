{{/*
Generate a name with the release name as a prefix.
*/}}
{{- define "dotnet-todo.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end }}

{{/*
Generate chart name and version as used by the chart label.
*/}}
{{- define "dotnet-todo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version -}}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dotnet-todo.labels" -}}
helm.sh/chart: {{ include "dotnet-todo.chart" . }}
{{ include "dotnet-todo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dotnet-todo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dotnet-todo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Generate name for application
*/}}
{{- define "dotnet-todo.name" -}}
{{- if .Values.nameOverride }}
{{- .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else }}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end }}
