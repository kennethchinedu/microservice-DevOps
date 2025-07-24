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
PRODUCT_CATALOG_IMAGE := productservice
RECOMMENDATION_SERVICE_IMAGE := recommendationservice
SHIPPING_SERVICE_IMAGE := shippingservice

IMAGE_TAG ?=$(shell date +%Y-%m-%d)



docker-run:
	docker build -t adservice src/adservice/.