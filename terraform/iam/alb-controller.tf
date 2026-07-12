data "aws_iam_openid_connect_provider" "eks" {
  arn = data.terraform_remote_state.eks.outputs.oidc_provider_arn
}

data "aws_iam_policy_document" "alb_controller_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        data.terraform_remote_state.eks.outputs.oidc_provider_arn
      ]
    }

    condition {
      test = "StringEquals"

      variable = "${replace(data.aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller"
      ]
    }

    condition {
      test = "StringEquals"

      variable = "${replace(data.aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "alb_controller" {
  name = "incident-alb-controller-role"

  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role.json
}

resource "aws_iam_policy" "alb_controller" {
  name = "AWSLoadBalancerControllerIAMPolicy"

  policy = file("${path.module}/iam_policy.json")
}

resource "aws_iam_role_policy_attachment" "alb_controller" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller.arn
}
