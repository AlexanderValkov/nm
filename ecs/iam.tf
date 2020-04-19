resource "aws_iam_group" "logreader" {
  name = "logreaders"
}


resource "aws_iam_policy" "logread" {
  name    = "nm_logsread"
  policy  = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
      "Action": [
        "logs:Describe*",
        "logs:Get*",
        "logs:TestMetricFilter",
        "logs:FilterLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
      }
   ]
}
EOF

}

resource "aws_iam_group_policy_attachment" "logread" {
  group       = aws_iam_group.logreader.name
  policy_arn  = aws_iam_policy.logread.arn
}
