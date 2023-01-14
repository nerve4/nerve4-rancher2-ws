# Rancher 2.7: How to create etcd and Cluster Backup


## Summary

[back-up-rancher](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/backup-restore-and-disaster-recovery/back-up-rancher)

### rke2 etcd-snapshot (help)

```
root@nerve4rch01:/home/lee# rke2 etcd-snapshot help
NAME:
   rke2 etcd-snapshot - Trigger an immediate etcd snapshot

USAGE:
   rke2 etcd-snapshot [global options] command [command options] [arguments...]

VERSION:
   v1.24.9+rke2r1 (1e1469d26dcddd9f712216b299b6a6c1c8e916ca)

COMMANDS:
   delete       Delete given snapshot(s)
   ls, list, l  List snapshots
   prune        Remove snapshots that exceed the configured retention count
   save         Trigger an immediate etcd snapshot

GLOBAL OPTIONS:
   --debug                                              (logging) Turn on debug logs [$RKE2_DEBUG]
   --config FILE, -c FILE                               (config) Load configuration from FILE (default: "/etc/rancher/rke2/config.yaml") [$RKE2_CONFIG_FILE]
   --log value, -l value                                (logging) Log to file
   --alsologtostderr                                    (logging) Log to standard error as well as file (if set)
   --node-name value                                    (agent/node) Node name [$RKE2_NODE_NAME]
   --data-dir value, -d value                           (data) Folder to hold state (default: "/var/lib/rancher/rke2")
   --dir value, --etcd-snapshot-dir value               (db) Directory to save etcd on-demand snapshot. (default: ${data-dir}/db/snapshots)
   --name value                                         (db) Set the base name of the etcd on-demand snapshot (appended with UNIX timestamp). (default: "on-demand")
   --snapshot-compress, --etcd-snapshot-compress        (db) Compress etcd snapshot
   --s3, --etcd-s3                                      (db) Enable backup to S3
   --s3-endpoint value, --etcd-s3-endpoint value        (db) S3 endpoint url (default: "s3.amazonaws.com")
   --s3-endpoint-ca value, --etcd-s3-endpoint-ca value  (db) S3 custom CA cert to connect to S3 endpoint
   --s3-skip-ssl-verify, --etcd-s3-skip-ssl-verify      (db) Disables S3 SSL certificate validation
   --s3-access-key value, --etcd-s3-access-key value    (db) S3 access key [$AWS_ACCESS_KEY_ID]
   --s3-secret-key value, --etcd-s3-secret-key value    (db) S3 secret key [$AWS_SECRET_ACCESS_KEY]
   --s3-bucket value, --etcd-s3-bucket value            (db) S3 bucket name
   --s3-region value, --etcd-s3-region value            (db) S3 region / bucket location (optional) (default: "us-east-1")
   --s3-folder value, --etcd-s3-folder value            (db) S3 folder
   --s3-insecure, --etcd-s3-insecure                    (db) Disables S3 over HTTPS
   --s3-timeout value, --etcd-s3-timeout value          (db) S3 timeout (default: 5m0s)
   --help, -h                                           show help
```


## rke2 etcd-snapshot - s3 bucket

```
rke2 etcd-snapshot \
  --s3 \
  --s3-bucket=<S3-BUCKET-NAME> \
  --s3-access-key=<S3-ACCESS-KEY> \
  --s3-secret-key=<S3-SECRET-KEY>
```


## IAM Permissions for EC2 Nodes to Access S3

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
     "Resource": [
        "arn:aws:s3:::rancher-backups"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
         "arn:aws:s3:::rancher-backups/*"
      ]
    }
  ]
}
```


## rke2 etcd-snapshot - to minio
```
rke2 etcd-snapshot \
  --name rancher-data-backup-v2.7.0-2023-01-13 \
  --etcd-s3 \
  --etcd-s3-bucket=<BUCKETNAME> \
  --etcd-s3-access-key=<ACCESS-KEY> \
  --etcd-s3-secret-key=<SECRET-KEY> \
  --etcd-s3-endpoint=<HOST-IP-ADDRESS>:9000 \
  --etcd-s3-skip-ssl-verify
```


## Ranche Opaque Secret example

```
apiVersion: v1
data:
  accessKey: <ACCESS-KEY>
  secretKey: <SECRET-KEY>
kind: Secret
metadata:
  creationTimestamp: "2023-01-13T14:50:55Z"
  managedFields:
  - apiVersion: v1
    fieldsType: FieldsV1
    fieldsV1:
      f:data:
        .: {}
        f:accessKey: {}
        f:secretKey: {}
      f:type: {}
    manager: rancher
    operation: Update
    time: "2023-01-13T14:50:55Z"
  name: minio-creds
  namespace: default
  resourceVersion: "160027"
  uid: ee14447e-8709-408c-95ea-b7518c510297
type: Opaque
```


### Install the Rancher Backups operator

```
  - In the upper left corner, click ☰ > Cluster Management.
  - On the Clusters page, go to the local cluster and click Explore. The local cluster runs the Rancher server.
  - Click Apps > Charts.
  - Click Rancher Backups.
  - Click Install.
  - Configure the default storage location. For help, refer to the storage configuration section.
  - Click Install.
```


## Maintainer Information
Lee | 2023