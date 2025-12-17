resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = var.repo_url
  chart            = var.chart_name
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true

  values = var.values != "" ? [var.values] : []
}

resource "time_sleep" "wait_for_argocd" {
  depends_on      = [helm_release.argocd]
  create_duration = var.wait_for_ready
}

resource "kubernetes_manifest" "applications_parent" {
  depends_on = [time_sleep.wait_for_argocd]
  manifest   = yamldecode(file(var.applications_parent_path))
}

resource "kubernetes_manifest" "infra_parent" {
  depends_on = [
    time_sleep.wait_for_argocd,
    kubernetes_manifest.applications_parent
  ]
  manifest = yamldecode(file(var.infra_parent_path))
}
