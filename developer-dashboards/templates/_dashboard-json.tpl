{{/*
================================================================================
_dashboard-json.tpl - Auto-generates complete Grafana dashboard JSON
================================================================================
Input context (passed via "dict"):
  - "dashboard"     : the dashboard object from values.yaml
  - "datasourceUid" : Prometheus datasource UID
  - "layout"        : layout settings (columns, panelHeight)
================================================================================
*/}}

{{- define "developer-dashboards.dashboardJson" -}}
{{- $dashboard := .dashboard }}
{{- $dsUid := .datasourceUid }}
{{- $columns := .layout.columns | int }}
{{- $panelHeight := .layout.panelHeight | int }}
{{- $panelWidth := div 24 $columns }}
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": { "type": "grafana", "uid": "-- Grafana --" },
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "description": {{ $dashboard.description | default "" | toJson }},
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 1,
  "links": [],
  "panels": [
    {{- range $i, $panel := $dashboard.panels }}
    {{- $type := $panel.type | default "timeseries" }}
    {{- $unit := $panel.unit | default "short" }}
    {{- $legend := $panel.legendFormat | default "" }}
    {{- $gridX := mod $i $columns | mul $panelWidth }}
    {{- $gridY := div $i $columns | mul $panelHeight }}
    {{- if $i }},{{ end }}
    {
      "id": {{ add $i 1 }},
      "title": {{ $panel.title | toJson }},
      "description": {{ $panel.description | default "" | toJson }},
      {{- if eq $type "stat" }}
      "type": "stat",
      "fieldConfig": {
        "defaults": {
          "color": { "mode": "thresholds" },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              { "color": "green", "value": null },
              { "color": "red", "value": 80 }
            ]
          },
          "unit": {{ $unit | toJson }}
        },
        "overrides": []
      },
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "percentChangeColorMode": "standard",
        "reduceOptions": {
          "calcs": ["lastNotNull"],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "textMode": "auto",
        "wideLayout": true
      },
      {{- else if eq $type "gauge" }}
      "type": "gauge",
      "fieldConfig": {
        "defaults": {
          "color": { "mode": "thresholds" },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              { "color": "green", "value": null },
              { "color": "orange", "value": 65 },
              { "color": "red", "value": 80 }
            ]
          },
          "unit": {{ $unit | toJson }},
          "min": 0,
          "max": 100
        },
        "overrides": []
      },
      "options": {
        "minVizHeight": 75,
        "minVizWidth": 75,
        "orientation": "auto",
        "reduceOptions": {
          "calcs": ["lastNotNull"],
          "fields": "",
          "values": false
        },
        "showThresholdLabels": false,
        "showThresholdMarkers": true
      },
      {{- else if eq $type "table" }}
      "type": "table",
      "fieldConfig": {
        "defaults": {
          "color": { "mode": "thresholds" },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              { "color": "green", "value": null },
              { "color": "red", "value": 80 }
            ]
          },
          "unit": {{ $unit | toJson }}
        },
        "overrides": []
      },
      "options": {
        "cellHeight": "sm",
        "footer": { "countRows": false, "fields": "", "reducer": ["sum"], "show": false },
        "showHeader": true
      },
      {{- else if eq $type "bar" }}
      "type": "barchart",
      "fieldConfig": {
        "defaults": {
          "color": { "mode": "palette-classic" },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              { "color": "green", "value": null },
              { "color": "red", "value": 80 }
            ]
          },
          "unit": {{ $unit | toJson }}
        },
        "overrides": []
      },
      "options": {
        "barRadius": 0,
        "barWidth": 0.97,
        "groupWidth": 0.7,
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom" },
        "orientation": "auto",
        "showValue": "auto",
        "stacking": "none",
        "tooltip": { "mode": "single", "sort": "none" },
        "xTickLabelRotation": 0
      },
      {{- else if eq $type "heatmap" }}
      "type": "heatmap",
      "fieldConfig": {
        "defaults": {
          "color": { "mode": "scheme", "schemeVersion": 2 },
          "mappings": [],
          "unit": {{ $unit | toJson }}
        },
        "overrides": []
      },
      "options": {
        "calculate": false,
        "cellGap": 1,
        "color": { "mode": "scheme", "scheme": "Oranges", "steps": 64 },
        "legend": { "show": true },
        "tooltip": { "show": true, "yHistogram": false },
        "yAxis": { "axisPlacement": "left" }
      },
      {{- else }}
      "type": "timeseries",
      "fieldConfig": {
        "defaults": {
          "color": { "mode": "palette-classic" },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 10,
            "gradientMode": "none",
            "hideFrom": { "legend": false, "tooltip": false, "viz": false },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": { "type": "linear" },
            "showPoints": "auto",
            "spanNulls": false,
            "stacking": { "group": "A", "mode": "none" },
            "thresholdsStyle": { "mode": "off" }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              { "color": "green", "value": null },
              { "color": "red", "value": 80 }
            ]
          },
          "unit": {{ $unit | toJson }}
        },
        "overrides": []
      },
      "options": {
        "legend": { "calcs": [], "displayMode": "list", "placement": "bottom", "showLegend": true },
        "tooltip": { "mode": "single", "sort": "none" }
      },
      {{- end }}
      "datasource": { "type": "prometheus", "uid": {{ $dsUid | toJson }} },
      "gridPos": {
        "h": {{ $panelHeight }},
        "w": {{ $panelWidth }},
        "x": {{ $gridX }},
        "y": {{ $gridY }}
      },
      "targets": [
        {
          "datasource": { "type": "prometheus", "uid": {{ $dsUid | toJson }} },
          "editorMode": "code",
          "expr": {{ $panel.query | toJson }},
          {{- if $legend }}
          "legendFormat": {{ $legend | toJson }},
          {{- else }}
          "legendFormat": "__auto",
          {{- end }}
          "range": true,
          "refId": "A"
        }
      ]
    }
    {{- end }}
  ],
  "schemaVersion": 39,
  "tags": {{ $dashboard.tags | default list | toJson }},
  "templating": {
    "list": []
  },
  "time": { "from": "now-1h", "to": "now" },
  "timepicker": {},
  "timezone": "browser",
  "title": {{ $dashboard.title | toJson }},
  "uid": {{ printf "dev-%s" $dashboard.name | toJson }},
  "version": 1,
  "weekStart": ""
}
{{- end }}
