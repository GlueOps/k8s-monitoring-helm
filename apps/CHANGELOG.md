# Changelog

## [0.1.0](https://github.com/GlueOps/k8s-monitoring-helm/compare/v0.0.1...v0.1.0) (2026-10-28)


### ⚠ BREAKING CHANGES

* deploy only on clusters where `captain_utils -> crds` has applied a platform-crds release carrying kube-prometheus-stack 86.1.0 and the opentelemetry-operator v0.152.0 CRDs (platform-crds#68). The bundle serves OpenTelemetryCollector only as v1beta1.

### Features

* adding alerts argocd app ([76a2586](https://github.com/GlueOps/k8s-monitoring-helm/commit/76a2586fdc4ff0bdd5f5df9d5cf0613e0e761250))
* let CLI tools authenticate to grafana-dev with a Dex token ([#353](https://github.com/GlueOps/k8s-monitoring-helm/issues/353)) ([b7a003c](https://github.com/GlueOps/k8s-monitoring-helm/commit/b7a003cae9ba523a1784df1976eb7c8429563ac7))
* monitoring fixes — Tempo, Loki retention, Thanos compactor, ServerSideApply, drop bundled Grafana ([#364](https://github.com/GlueOps/k8s-monitoring-helm/issues/364)) ([547ce2b](https://github.com/GlueOps/k8s-monitoring-helm/commit/547ce2b6c6b2f57b3a90d1428a7537bd09d8c7c8))
* stop installing CRDs from the monitoring app-of-apps (CRDs come from platform-crds) ([#347](https://github.com/GlueOps/k8s-monitoring-helm/issues/347)) ([d4c4fe2](https://github.com/GlueOps/k8s-monitoring-helm/commit/d4c4fe270a6d456e7af05d5516146fa0bb931678))
* update app to 0.13.0 #minor ([#288](https://github.com/GlueOps/k8s-monitoring-helm/issues/288)) ([71765c7](https://github.com/GlueOps/k8s-monitoring-helm/commit/71765c738abd713bc68bb651e7f2caa915356014))
* update app to 0.13.0 #minor ([#311](https://github.com/GlueOps/k8s-monitoring-helm/issues/311)) ([d38aa01](https://github.com/GlueOps/k8s-monitoring-helm/commit/d38aa01c035451c553097de5e0607262597d750e))
* update app to 0.14.1 #minor ([#324](https://github.com/GlueOps/k8s-monitoring-helm/issues/324)) ([62e9d42](https://github.com/GlueOps/k8s-monitoring-helm/commit/62e9d422cca05e8e5bf779a2415660f8f3f8f696))
* update app to 0.8.1 #minor ([#310](https://github.com/GlueOps/k8s-monitoring-helm/issues/310)) ([93907fd](https://github.com/GlueOps/k8s-monitoring-helm/commit/93907fdca77757ecfe118088120b5be66d98742e))
* update opentelemetry-operator to 0.114.1 #minor ([#301](https://github.com/GlueOps/k8s-monitoring-helm/issues/301)) ([85821c9](https://github.com/GlueOps/k8s-monitoring-helm/commit/85821c9746c4da36f38fdc15273891579efab782))
* update otel/opentelemetry-collector-contrib to 0.153.0 #minor ([#300](https://github.com/GlueOps/k8s-monitoring-helm/issues/300)) ([d9b63bc](https://github.com/GlueOps/k8s-monitoring-helm/commit/d9b63bcbef1229f080c76ce42044a7d38e3eecdb))
* update tempo-distributed to 1.57.1 #minor ([#312](https://github.com/GlueOps/k8s-monitoring-helm/issues/312)) ([ad07422](https://github.com/GlueOps/k8s-monitoring-helm/commit/ad07422b9db60300eab2c0685e05d5396a282ca3))
* update tempo-distributed to 1.61.3 #minor ([#252](https://github.com/GlueOps/k8s-monitoring-helm/issues/252)) ([cb8d978](https://github.com/GlueOps/k8s-monitoring-helm/commit/cb8d9789fe51f8cbf4b9de4086ad0861005315f4))


### Bug Fixes

* monitor etcd on port 2381 without creds ([#360](https://github.com/GlueOps/k8s-monitoring-helm/issues/360)) ([f813ef8](https://github.com/GlueOps/k8s-monitoring-helm/commit/f813ef898e65172620e5b24f054560ea907f15f5))
* remove pomerium references since we switched to ingress-nginx/oauth2-proxy ([62f2d7d](https://github.com/GlueOps/k8s-monitoring-helm/commit/62f2d7d37b5d2f36cff0b0143607fbd8d2ea118c))
* review follow-ups — explicit CompositeController name, no credential defaults, README corrections ([#352](https://github.com/GlueOps/k8s-monitoring-helm/issues/352)) ([23954a2](https://github.com/GlueOps/k8s-monitoring-helm/commit/23954a263c3610677cab419ab9234fb2bdb6b82d))


### Miscellaneous Chores

* **fallback:** update ghcr.io/open-telemetry/opentelemetry-operator/opentelemetry-operator ([#313](https://github.com/GlueOps/k8s-monitoring-helm/issues/313)) ([39d3084](https://github.com/GlueOps/k8s-monitoring-helm/commit/39d3084d5795abb11c8640815dd13747a97d82a3))
* **patch:** update docker.io/grafana/grafana to 11.4.8 #patch ([#257](https://github.com/GlueOps/k8s-monitoring-helm/issues/257)) ([68a4b40](https://github.com/GlueOps/k8s-monitoring-helm/commit/68a4b40628897e35598ffd2bf29bc06089c43460))
* **patch:** update grafana to 8.13.2 #patch ([#258](https://github.com/GlueOps/k8s-monitoring-helm/issues/258)) ([12c3a22](https://github.com/GlueOps/k8s-monitoring-helm/commit/12c3a226dc744a86f5f6800f9e280f9c50ab12fe))
* **pindigest:** update ghcr.io/glueops/metacontroller-operator-loki-rule-group to edf1ab4 #patch ([#256](https://github.com/GlueOps/k8s-monitoring-helm/issues/256)) ([2e98ab9](https://github.com/GlueOps/k8s-monitoring-helm/commit/2e98ab9aed5db1eb281ee7784a3a7e84c28249fe))
