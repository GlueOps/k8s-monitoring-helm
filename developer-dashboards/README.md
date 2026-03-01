# Self-Service Grafana Dashboards

This Helm chart enables developers to **self-provision Grafana dashboards** without needing to understand Grafana's JSON model or panel configuration.

## How It Works

1. You add your panels to `values.yaml` with just **title**, **description**, and **PromQL query**
2. The Helm chart auto-generates the full Grafana dashboard JSON
3. Panels are **auto-arranged** in a grid layout (no manual positioning needed)
4. ArgoCD syncs the ConfigMaps → Grafana sidecar picks them up automatically

## Quick Start

Edit `values.yaml` and add a dashboard under the `dashboards:` list:

```yaml
dashboards:
  - name: "my-app"                    # unique ID (lowercase, dashes)
    title: "My Application Dashboard"  # displayed in Grafana
    description: "Metrics for my-app"
    tags:
      - my-app
      - team-backend
    panels:
      - title: "Request Rate"
        description: "HTTP requests per second"
        query: 'sum(rate(http_requests_total{app="my-app"}[5m])) by (status_code)'
        legendFormat: "{{status_code}}"

      - title: "Error Rate"
        description: "Percentage of 5xx errors"
        query: 'sum(rate(http_requests_total{app="my-app",status=~"5.."}[5m])) / sum(rate(http_requests_total{app="my-app"}[5m])) * 100'
        type: stat
        unit: percent

      - title: "P99 Latency"
        description: "99th percentile request duration"
        query: 'histogram_quantile(0.99, sum(rate(http_request_duration_seconds_bucket{app="my-app"}[5m])) by (le))'
        unit: s

      - title: "Memory Usage"
        description: "Container memory usage"
        query: 'container_memory_working_set_bytes{container="my-app"}'
        unit: bytes
```

Then open a **Pull Request**. Once merged, your dashboard appears in Grafana automatically.

## Panel Configuration Reference

### Required Fields

| Field   | Description                          | Example                                        |
|---------|--------------------------------------|------------------------------------------------|
| `title` | Panel title displayed in Grafana     | `"Request Rate"`                               |
| `query` | PromQL query                         | `'rate(http_requests_total[5m])'`              |

### Optional Fields

| Field          | Description                        | Default       | Options                                              |
|----------------|------------------------------------|---------------|------------------------------------------------------|
| `description`  | Tooltip text explaining the panel  | `""`          | Any text                                             |
| `type`         | Visualization type                 | `timeseries`  | `timeseries`, `stat`, `gauge`, `table`, `bar`, `heatmap` |
| `unit`         | Display unit for values            | `short`       | `short`, `percent`, `bytes`, `s`, `ms`, `Bps`, `reqps`, `ops` |
| `legendFormat` | Legend label format                | auto          | `"{{pod}}"`, `"{{instance}}"`, `"{{status_code}}"` |

### Visualization Types

| Type         | Best For                                    | Example                           |
|--------------|---------------------------------------------|-----------------------------------|
| `timeseries` | Metrics over time (line/area charts)        | Request rate, latency trends      |
| `stat`       | Single big number                           | Total errors, uptime percentage   |
| `gauge`      | Value within a range (0-100)                | CPU %, memory utilization         |
| `table`      | Tabular data                                | Top-N pods, status overview       |
| `bar`        | Comparison across categories                | Requests by endpoint              |
| `heatmap`    | Distribution over time                      | Latency distribution              |

### Common Units

| Unit      | Description           | Example Output |
|-----------|-----------------------|----------------|
| `short`   | Auto-scaled number    | `1.5K`         |
| `percent` | Percentage            | `85.2%`        |
| `bytes`   | Auto-scaled bytes     | `1.2 GiB`      |
| `s`       | Seconds               | `0.250 s`      |
| `ms`      | Milliseconds          | `250 ms`       |
| `Bps`     | Bytes per second      | `1.5 MB/s`     |
| `reqps`   | Requests per second   | `150 req/s`    |
| `ops`     | Operations per second | `1.2K ops/s`   |

## Layout

Panels are auto-arranged in a **2-column grid** by default. You can change this globally in `values.yaml`:

```yaml
layout:
  columns: 2       # 1, 2, 3, or 4 columns
  panelHeight: 8   # height in Grafana grid units
```

| Columns | Panel Width | Best For                      |
|---------|-------------|-------------------------------|
| 1       | Full width  | Wide timeseries, tables       |
| 2       | Half width  | General purpose (default)     |
| 3       | Third width | Dense overview dashboards     |
| 4       | Quarter     | Stat panels, compact layout   |

## Multiple Dashboards

You can define multiple dashboards in the same `values.yaml`. Each one becomes a separate Grafana dashboard:

```yaml
dashboards:
  - name: "frontend"
    title: "Frontend Metrics"
    panels: [...]

  - name: "backend-api"
    title: "Backend API Metrics"
    panels: [...]

  - name: "database"
    title: "Database Health"
    panels: [...]
```

## Local Testing

Validate your dashboard renders correct JSON:

```bash
cd developer-dashboards/
helm template . --debug
```

## Architecture

```
values.yaml (developer input)
       │
       ▼
Helm Template (_dashboard-json.tpl)
       │  Converts simple YAML → full Grafana JSON
       │  Auto-calculates grid positions
       ▼
ConfigMap (with sidecar label)
       │
       ▼
Grafana Sidecar auto-discovers → Dashboard appears
```
