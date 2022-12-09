# String search with regular expressions.

Write a program to detect and check the names of AWS S3 buckets following the specified naming rules. 
- Bucket names must be between 3 (min) and 63 (max) characters long.
- Bucket names can consist only of lowercase letters, numbers, dots (.), and hyphens (-).
- Bucket names must begin and end with a letter or number.
- Bucket names must not contain two adjacent periods.
- Bucket names must not be formatted as an IP address (for example, 192.168.5.4).
- Bucket names must not start with the prefix xn--.
- Bucket names must not end with the suffix -s3alias

The following example bucket names are valid and follow the recommended naming guidelines:
- docexamplebucket1
- blog-delivery-march-2020
- my-hosted-content

## Examples IaC Configuration Files

```hcl

rule "aws_s3_bucket_name" {
  enabled = true
  regex = "xxxxxxx"
  prefix = "my-org"
}

resource "aws_s3_bucket" "foo" {
  bucket = "foo"
}
```
## Expected Results

```sh
1 issue(s) found:

Warning: Bucket name "foo" does not have prefix "my-org" (aws_s3_bucket_name)

  on main.tf line 2:
  2:   bucket = "foo"
```
** Please use a regular expression specifies a set of strings that matches it.
