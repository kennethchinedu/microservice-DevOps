ads *
cart *
checkout *
currency * 
payment * 




TOOLS:
Trivy
ECR
EKS
Vault
Atlantis
ArgoCD
EFS file system



```
# Setting up AWS ingress controller

## OIDC association
# https://www.youtube.com/watch?v=AhzZQlb_k40&ab_channel=DevOps4Solutions 
First associate the cluster OICD with identity provider

curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json   

### Creating IAM policy
aws iam create-policy \                                                                                                             
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json


# Install ingress controller

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh


 helm repo add eks https://aws.github.io/eks-charts
 helm repo update eks
 helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=my-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```