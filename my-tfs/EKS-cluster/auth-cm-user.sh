#!/bin/bash
arn=$1
id=$2
user=$3
cat <<EOF > auth-cm-user.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: $arn
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
  mapUsers: | 
    - userarn: arn:aws:iam::$id:user/system/$user
      username: $user
      groups: 
        - system:masters
EOF