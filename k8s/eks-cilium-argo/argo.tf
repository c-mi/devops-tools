resource "kubernetes_namespace" "argo" {
  metadata {
    annotations = {
      "app.kubernetes.io/part-of" = "argocd"
    }

    labels = {
      name = "argocd"
    }

    name = "argocd"
  }
}

resource "null_resource" "argo" {

  triggers = {
    cluster = module.eks.cluster_id
  }

  provisioner "local-exec" {
    on_failure  = fail
    when        = create
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOF
      set -e
      aws eks update-kubeconfig --name ${local.name} --region ${var.region} --kubeconfig ./config
      KUBECONFIG='./config' kubectl apply -k ../cluster-resources/argo
      rm ./config
    EOF
  }

  depends_on = [helm_release.cilium, kubernetes_namespace.argo]
}