#Create Cross Account Role
resource "aws_iam_role" "cross_account" {
  name = "${var.role_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.permitted_account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "iam_permission" {
  name        = "IAM_Role_Permissions_For_Tensult"
  description = "Basic role permission for tensult"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:PassRole",
                "iam:CreateRole",
                "iam:AddRoleToInstanceProfile",
                "iam:AttachRolePolicy",
                "iam:CreatePolicy",
                "iam:PutRolePolicy",
                "iam:CreateInstanceProfile",
                "sts:GetCallerIdentity"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

#Attach policy
resource "aws_iam_role_policy_attachment" "permission" {
  role       = "${aws_iam_role.cross_account.name}"
  policy_arn = "${var.role_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "read_permission" {
  role       = "${aws_iam_role.cross_account.name}"
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "iam_permission" {
  role       = "${aws_iam_role.cross_account.name}"
  policy_arn = "${aws_iam_policy.iam_permission.arn}"
}
