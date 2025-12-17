variable "namespace" {
  description = "Namespace where Argo CD will be installed."
  type        = string
  default     = "argocd"
}

variable "repo_url" {
  description = "Helm chart repository URL for Argo CD."
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "chart_name" {
  description = "Helm chart name for Argo CD."
  type        = string
  default     = "argo-cd"
}

variable "chart_version" {
  description = "Helm chart version to deploy."
  type        = string
}

variable "values" {
  description = "Optional Helm values as a YAML string."
  type        = string
  default     = ""
}

variable "applications_parent_path" {
  description = "Path to the ArgoCD applications-parent.yaml file."
  type        = string
}

variable "infra_parent_path" {
  description = "Path to the ArgoCD infra-parent.yaml file."
  type        = string
}

variable "wait_for_ready" {
  description = "Duration to wait after installing Argo CD before applying parent apps."
  type        = string
  default     = "30s"
}
