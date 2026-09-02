# k8s-monitoring-helm

`apps/` is the Argo CD app-of-apps for the GlueOps cluster monitoring stack (kube-prometheus-stack, Thanos, Loki,
Tempo, the OpenTelemetry operator and collectors, Grafana admin/dev, dashboards and alerts). The platform chart
(`GlueOps/platform-helm-chart-platform`, `templates/application-monitoring.yaml`) deploys it as the
`glueops-core-monitoring` Application and passes the per-cluster values (`captain_domain`, storage backends, Grafana
and Dex secrets, host-network and node placement settings).

## CRDs are never installed from here

Every CustomResourceDefinition the platform needs is installed by the layer-0 bundle
[`GlueOps/platform-crds`](https://github.com/GlueOps/platform-crds), applied by `captain_utils` before Argo CD and
before the platform chart. No Application in `apps/` may render a CRD:

| Application | chart | how CRDs are suppressed |
|---|---|---|
| `glueops-core-kps` | kube-prometheus-stack | `helm.skipCrds: true` (the bundle pins the same chart version) |
| `glueops-core-otel` | opentelemetry-operator | `helm.skipCrds: true` **and** `crds.create: false` — this chart renders its CRDs as templates, so `skipCrds` alone is not enough |
| `glueops-core-loki` | loki | `helm.skipCrds: true` (its rollout-operator / grafana-agent-operator subcharts ship `crds/` and are disabled) |
| `glueops-core-tempo` | tempo-distributed | `helm.skipCrds: true` |
| `glueops-core-thanos`, `glueops-core-grafana-admin`, `glueops-core-grafana-dev` | thanos, grafana | `helm.skipCrds: true` (no CRDs upstream) |
| `glueops-core-grafana-dashboards` | GlueOps/platform-helm-chart-grafana-dashboards (git) | `helm.skipCrds: true` (no CRDs upstream) |
| `glueops-core-loki-alert-group-controller` | app | ships only the `CompositeController`; the `LokiAlertRuleGroup` CRD is in the bundle |
| `glueops-core-alerts`, `glueops-core-otel-collector` | app, GlueOps/otel-resources-helm (git) | plain custom resources only, nothing to suppress |

`hack/check-no-crds.sh` renders every Application's source the way Argo CD would (following app-of-apps children)
and fails if any CRD appears; CI runs it on every pull request (`.github/workflows/no-crds.yaml`).

When you bump kube-prometheus-stack (`app-prometheus.yaml` `targetRevision`) or the OpenTelemetry operator, bump the
matching pin in `platform-crds` first (`glueops.dev/pin.kube-prometheus-stack`, `glueops.dev/pin.opentelemetry-operator`):
a CRD older than the operator that serves it rejects fields the operator writes. The operator version that matters is
the **image** actually running, `otel.manager.image.tag` in `apps/values.yaml` (renovate bumps that tag on its own,
independently of the chart's `appVersion`), so the bundle pin must track that tag.

Note: the bundle serves `OpenTelemetryCollector` **only as `v1beta1`** (the upstream `v1alpha1` needs the operator's
conversion webhook, which the bundle cannot carry). Everything deployed from `GlueOps/otel-resources-helm` is
`v1beta1`.

Managed by github-org-manager
