IMAGE_REG ?= docker.io
IMAGE_DIRECTORY ?= anamskenneth


# AD_SERVICE_IMAGE := adservice #
# CART_SERVICE_IMAGE := cartservice #
# CHECKOUT_SERVICE_IMAGE := checkoutservice
# CURRENCY_SERVICE_IMAGE := currencyservice #
# EMAIL_SERVICE_IMAGE := emailservice
# FRONTEND_IMAGE := frontend
# LOAD_GENERATOR_IMAGE := loadgenerator
# PAYMENT_SERVICE_IMAGE := paymentservice
# PRODUCT_CATALOG_IMAGE := productcatalogservice
# RECOMMENDATION_SERVICE_IMAGE := recommendationservice
# SHIPPING_SERVICE_IMAGE := shippingservice

IMAGE_TAG ?=$(shell date +%Y-%m-%d)

SERVICES= adservice productcatalogservice cartservice checkoutservice currencyservice emailservice \
		  loadgenerator paymentservice recommendationservice shippingservice



SERVICES=     checkoutservice \
# 		     

docker-run:
	docker build -t adservice src/adservice/.

docker-build:
	for service in $(SERVICES); do \
		docker build -t $(IMAGE_DIRECTORY)/$$service:2025-07-24 src/$$service/.; \
	done

docker-push:
	for service in $(SERVICES); do \
		docker push $(IMAGE_DIRECTORY)/$$service:2025-07-24; \
	done 

docker-run:
	for service in $(SERVICES); do \
		docker run -d   $(IMAGE_DIRECTORY)/$$service:2025-07-24; \
	done 



## EKS CLUSTER SETUP


switch_to_cluster:
	aws eks update-kubeconfig --name my-cluster --region us-east-1

enable_iam_sa_provider:
	eksctl utils associate-iam-oidc-provider --cluster=my-cluster --approve




create_cluster_role:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/rbac-role.yaml

create_iam_policy:
	curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.0/docs/install/iam_policy.json
	aws iam create-policy \
		--policy-name AWSLoadBalancerControllerIAMPolicy \
		--policy-document file://iam_policy.json

create_service_account:
	eksctl create iamserviceaccount \
      --cluster=my-cluster \
      --namespace=kube-system \
      --name=aws-load-balancer-controller \
      --attach-policy-arn=arn:aws:iam::471112894147:policy/AWSLoadBalancerControllerIAMPolicy \
      --override-existing-serviceaccounts \
      --approve

install_helm:
	curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
	chmod 700 get_helm.sh
	./get_helm.sh
	

install_helm:
	helm repo add eks https://aws.github.io/eks-charts
 	helm repo update eks

install_alb_ingress_controller:
 	helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  	-n kube-system \
  	--set clusterName=my-cluster \
  	--set serviceAccount.create=false \
  	--set serviceAccount.name=aws-load-balancer-controller 


	