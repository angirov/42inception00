SRCS_DIR := ./srcs
CERT_DIR := ${SRCS_DIR}/requirements/nginx/tools/cert
CA_NAME := ca
SERVER_NAME := server
DOM_NAME := vangirov.local

all:
	export DOM_NAME=${DOM_NAME} && \
	export CERT_DIR=${CERT_DIR} && \
	export CA_NAME=${CA_NAME} && \
	export SERVER_NAME=${SERVER_NAME} && \
	export $$( cat $(SRCS_DIR)/build.env | xargs ); \
	# export NGINX_PASS_LINE=$$( htpasswd -n $${NGINX_USERNAME:-admin} ); \
	cd $(SRCS_DIR); \
	docker-compose up -d --build

certs:
	cd ${CERT_DIR} && \
	export CA_NAME=${CA_NAME} && \
	export SERVER_NAME=${SERVER_NAME} && \
	bash create_cert.sh && \
	openssl x509 -in ${SERVER_NAME}.pem -noout -text && \
	openssl x509 -in ${CA_NAME}.pem -inform PEM -out $${CA_NAME}.crt

curl:
	@(echo -n "Trying  tls 1.0: " && curl --tls-max 1.0 --cacert ${CERT_DIR}/${CA_NAME}.pem  https://${DOM_NAME}/ 2> /dev/null) || echo "FAILED"
	@(echo -n "Trying  tls 1.1: " && curl --tls-max 1.1 --cacert ${CERT_DIR}/${CA_NAME}.pem  https://${DOM_NAME}/ 2> /dev/null) || echo "FAILED"
	@(echo -n "Trying  tls 1.2: " && curl --tls-max 1.2 --cacert ${CERT_DIR}/${CA_NAME}.pem  https://${DOM_NAME}/ 2> /dev/null) || echo "FAILED"
	@(echo -n "Trying  tls 1.3: " && curl --tls-max 1.3 --cacert ${CERT_DIR}/${CA_NAME}.pem  https://${DOM_NAME}/ 2> /dev/null) || echo "FAILED"

clean:
	rm inception-nginx.crt


