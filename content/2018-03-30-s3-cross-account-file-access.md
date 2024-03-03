---
title: "Cross-Account file access on AWS S3"
date: "2018-03-30T12:00:00-04:00"
url: "/posts/s3-cross-account-file-access"
categories:
- infosec
tags:
- aws
- cloud
- s3
---
# The Problem

Secure file sharing using AWS S3:

1. I upload a file to an S3 bucket with restricted permissions
2. The client downloads the file and processes it 
3. The client uploads the results to the S3 bucket
4. I download the processed file and the transaction is complete 

I thought setting the permissions on the bucket would be enough. I was wrong. 

# The Setup

I use a federated login to AWS and assume a role under a corporate account. I
created an S3 bucket that would be used for filesharing with one object called
"Delivery" (for files received from the client) and one object called
"Submissions" (for files I'm sharing with the client).

Although the S3 console depicts bucket contents as a hierarchical file/folder
system, S3 buckets are actually flat collections of objects. "Folder" objects
have key values that include / delimiters, and the S3 console helpfully
renders these as folders.

For example, the file "first.txt" in the "Submissions" folder of the "Example"
bucket is the "Submissions/first.txt" object.


I set the policy on the bucket to allow read, list, and write access based on
the client's Account ID. This was done in the S3 console by selecting the
bucket, and opening it's permissions, then selecting bucket policy.

{{< figure src="/images/2018/03-30-1.png" caption="Bucket permissions" >}}

This bucket policy was crafted to allow the client to list the bucket and
download/upload objects. The bucket policy JSON looks like this:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DelegateS3Access",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::<12-digit client account ID>:root"
            },
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::<bucket name>/*",
                "arn:aws:s3:::<bucket name>"
            ]
        }
    ]
}
```

With these permissions in place, the client was able to upload and download
files successfully. **However, I was unable to view or download files uploaded
by the client!** This was unexpected, as I owned the bucket.

# Elevate my thinking

I wasn't thinking loftily. As the [AWS forum post that solved the issue][forum] pointed
out:

> When a user uploads an object to your bucket the default ACL that is set is
> only set for that user.

This is great for security, but not for a mutual fileshare. The client had to
grant my account permissions to view the files they uploaded. This was possible
programmatically by using the [AWS CLI]:

~~~
aws s3api put-object --bucket <bucket name> --key <object name including path> --body <file to upload in current working directory> --acl bucket-owner-full-control
~~~

For example, if the client wanted to upload the local file "foo.txt" in their
current directory to bucket "examplebucket" in the "submissions" folder, the
command would be:

`aws s3api put-object --bucket examplebucket --key submissions/foo.txt --body
foo.txt --acl bucket-owner-full-control`

# Conclusion

I believe this solution is fairly resilient as:

* Access to this bucket is restricted to a trusted entity, identified by their
  Account ID,
* The only S3 object permissions allowed on this bucket, and objects in it, are
  _ListBucket_, _GetObject_, and _PutObject_, and
* A minimal amount of data is stored in this bucket and it's all intended for
  use by the client

Potential vulnerabilities include:

* An attacker could spoof the client by gaining access to the client's account
  which would allow access to files stored in this bucket.
* The _GetObject_ permission may not be desirable in all situations. If a
  write-only dropbox is desired, this permission should be omitted.

# References

[AWS CLI]

[IAM intro]

[IAM Principal]

[S3 walkthrough]

[AWS account ID]

[SO article on a similar issue]

[AWS forum post that solved the issue][forum]



[AWS CLI]: https://aws.amazon.com/cli/ 
[IAM intro]: https://docs.aws.amazon.com/IAM/latest/UserGuide/intro-structure.html
[IAM Principal]: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html
[S3 walkthrough]: https://docs.aws.amazon.com/AmazonS3/latest/dev/walkthrough1.html
[AWS account ID]: https://docs.aws.amazon.com/general/latest/gr/acct-identifiers.html
[SO article on a similar issue]: https://stackoverflow.com/questions/22944054/cant-download-files-uploaded-by-shared-account-s3-bucket
[forum]: https://forums.aws.amazon.com/thread.jspa?messageID=524342&%20#524342
