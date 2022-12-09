# IAM users and group
# users
resource "aws_iam_user" "user01" {
    name = "user01"
}
resource "aws_iam_user" "user02" {
    name = "user02"
}

# group
resource "aws_iam_group" "ec2-container-registry-power-user-group" {
    name = "ec2-container-registry-power-user-group"
}

# กำหนด users ให้ group
resource "aws_iam_group_membership" "assignment" {
    name = "assignment"
    users = [
        aws_iam_user.user01.name,
        aws_iam_user.user02.name
    ]
    group = aws_iam_group.ec2-container-registry-power-user-group.name
}

# Attach policy (สิทธิการเข้้าถึง) ให้ group
# IAM ARNs format(Amazon Resource Names) - arn:partition:service:region:account:resource
resource "aws_iam_policy_attachment" "attachment" {
    name = "attachment"
    groups = [aws_iam_group.ec2-container-registry-power-user-group.name]
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}