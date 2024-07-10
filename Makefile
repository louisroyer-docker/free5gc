.PHONY: docker

all: docker/amf docker/ausf docker/nrf docker/nssf docker/pcf docker/smf docker/udm docker/udr docker/upf docker/webconsole
docker/%:
	docker buildx build -t louisroyer/dev-free5gc-$(@F) ./$(@F)
