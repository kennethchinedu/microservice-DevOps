IMAGE_REG ?= docker.io
IMAGE_DIRECTORY ?= anamskenneth


AD_SERVICE_IMAGE := adservice
CART_SERVICE_IMAGE := cartservice
CHECKOUT_SERVICE_IMAGE := checkoutservice
CURRENCY_SERVICE_IMAGE := currencyservice
EMAIL_SERVICE_IMAGE := emailservice
FRONTEND_IMAGE := frontend
LOAD_GENERATOR_IMAGE := loadgenerator
PAYMENT_SERVICE_IMAGE := paymentservice
PRODUCT_CATALOG_IMAGE := productcatalogservice
RECOMMENDATION_SERVICE_IMAGE := recommendationservice
SHIPPING_SERVICE_IMAGE := shippingservice

IMAGE_TAG ?=$(shell date +%Y-%m-%d)

SERVICES= adservice productcatalogservice cartservice checkoutservice currencyservice emailservice \
		 frontend loadgenerator paymentservice recommendationservice shippingservice



docker-run:
	docker build -t adservice src/adservice/.

loop:
	for service in $(SERVICES); do \
		docker build -t $(IMAGE_DIRECTORY)/$$service:$(IMAGE_TAG) src/$$service/.; \
	done
