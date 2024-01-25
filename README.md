# Free5GC Docker Images
WARNING: **The following images are NOT official builds of Free5GC**, in the future they may include beta-functionalities.

By default, configuration file from templating is used if no `--config` or `-c` is passed as argument. To start without argument, use:

```yaml
command: [" "]
```

## Routing
If you choose to configure the container using `docker-setup` (default), please refer to [`docker-setup`'s documentation](https://github.com/louisroyer/docker-setup). The environment variable ONESHOT is set to "true".
By default, it does nothing, but if you intend to use it, don't forget to add the capability `NET_ADMIN`.

## Configuration
### AMF
- On Dockerhub: [`louisroyer/dev-free5gc-amf`](https://hub.docker.com/r/louisroyer/dev-free5gc-amf).

Please note that even if this software is not yet properly packaged using `.deb`, the generated binary file `/usr/local/bin/amf` is provided to you under Apache Version 2.0 License. A copy of this license can be found in `/usr/share/common-licenses/Apache-2.0`.
A copy of the source code is available at in the repository [`free5gc/amf`](https://github.com/free5gc/amf).

Environment variable used to select templating system:
```yaml
environment:
  ROUTING_SCRIPT: "docker-setup"
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/free5gc/amf.yaml"
  CONFIG_TEMPLATE: "/usr/local/share/free5gc/template-amf.yaml"
```

Environment variables for templating:
```yaml
environment:
  N2: "192.0.2.1"
  SBI_REGISTER_IP: "amf.sbi" # you can use a domain or an IP address
  SBI_BINDING_IP: "198.51.100.1" # use only an IP address in this field
  SBI_BINDING_PORT: "8000" # default: "8000"
  MCC: "001"
  MNC: "01"
  AMF_ID: "000001" # 6 digits
  AMF_NAME: "AMF"
  NRF: "nrf.sbi:8000"
  SUPPORT_DNN_LIST: |-
    - internet
    - edge
  SNSSAI_LIST: |-
    - sst: 1
      sd: 000001
    - sst: 1
      sd: 000002
  TAC: "000001" # 6 digits
  LOCALITY: "area1"
```

### AUSF
- On Dockerhub: [`louisroyer/dev-free5gc-ausf`](https://hub.docker.com/r/louisroyer/dev-free5gc-ausf).

Please note that even if this software is not yet properly packaged using `.deb`, the generated binary file `/usr/local/bin/ausf` is provided to you under Apache Version 2.0 License. A copy of this license can be found in `/usr/share/common-licenses/Apache-2.0`.
A copy of the source code is available at in the repository [`free5gc/ausf`](https://github.com/free5gc/ausf).

Environment variable used to select templating system:
```yaml
environment:
  ROUTING_SCRIPT: "docker-setup"
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/free5gc/ausf.yaml"
  CONFIG_TEMPLATE: "/usr/local/share/free5gc/template-ausf.yaml"
```

Environment variables for templating:
```yaml
environment:
  SBI_REGISTER_IP: "ausf.sbi" # you can use a domain or an IP address
  SBI_BINDING_IP: "198.51.100.2" # use only an IP address in this field
  SBI_BINDING_PORT: "8000" # default: "8000"
  MCC: "001"
  MNC: "01"
  NRF: "nrf.sbi:8000"
```


### NRF
- On Dockerhub: [`louisroyer/dev-free5gc-nrf`](https://hub.docker.com/r/louisroyer/dev-free5gc-nrf).

Please note that even if this software is not yet properly packaged using `.deb`, the generated binary file `/usr/local/bin/nrf` is provided to you under Apache Version 2.0 License. A copy of this license can be found in `/usr/share/common-licenses/Apache-2.0`.
A copy of the source code is available at in the repository [`free5gc/nrf`](https://github.com/free5gc/nrf).

Environment variable used to select templating system:
```yaml
environment:
  ROUTING_SCRIPT: "docker-setup"
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/free5gc/nrf.yaml"
  CONFIG_TEMPLATE: "/usr/local/share/free5gc/template-nrf.yaml"
```

Environment variables for templating:
```yaml
environment:
  MONGO_HOST: "mongodb.db"
  MONGO_PORT: "27017"
  MONGO_NAME: "free5gc"
  SBI_REGISTER_IP: "nrf.sbi" # you can use a domain or an IP address
  SBI_BINDING_IP: "198.51.100.3" # use only an IP address in this field
  SBI_BINDING_PORT: "8000" # default: "8000"
  MCC: "001"
  MNC: "01"
```

### NSSF
- On Dockerhub: [`louisroyer/dev-free5gc-nssf`](https://hub.docker.com/r/louisroyer/dev-free5gc-nssf).

Please note that even if this software is not yet properly packaged using `.deb`, the generated binary file `/usr/local/bin/nssf` is provided to you under Apache Version 2.0 License. A copy of this license can be found in `/usr/share/common-licenses/Apache-2.0`.
A copy of the source code is available at in the repository [`free5gc/nssf`](https://github.com/free5gc/nssf).

Environment variable used to select templating system:
```yaml
environment:
  ROUTING_SCRIPT: "docker-setup"
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/free5gc/nssf.yaml"
  CONFIG_TEMPLATE: "/usr/local/share/free5gc/template-nssf.yaml"
```

Environment variables for templating:
```yaml
environment:
  SBI_REGISTER_IP: "nssf.sbi" # you can use a domain or an IP address
  SBI_BINDING_IP: "198.51.100.3" # use only an IP address in this field
  SBI_BINDING_PORT: "8000" # default: "8000"
  MCC: "001"
  MNC: "01"
  NSSF_NAME: "NSSF"
  SUPPORTED_NSSAI_IN_PLMN_LIST: |-
    - plmnId:
        mcc: 001
        mnc: 01
      supportedSnssaiList:
        - sst: 1
          sd: 000001
        - sst: 1
          sd: 000002
  NSI_LIST: |-
    - snssai:
        sst: 1
      nsiInformationList:
        - nrfId: http://nrf.sbi:8000/nnrf-nfm/v1/nf-instances
          nsiId: 10
  AMF_SET_LIST: |-
    - amfSetId: 1
      amfList:
        - ffa2e8d7-3275-49c7-8631-6af1df1d9d26
      nrfAmfSet: http://nrf.sbi:8000/nnrf-nfm/v1/nf-instances
      supportedNssaiAvailabilityData:
        - tai:
            plmnId:
              mcc: 001
              mnc: 01
            tac: 00001
          supportedSnssaiList:
            - sst: 1
              sd: 000001
            - sst: 1
              sd: 000002
  AMF_LIST: |-
    - nfId: 469de254-2fe5-4ca0-8381-af3f500af77c
      supportedNssaiAvailabilityData:
        - tai:
            plmnId:
              mcc: 001
              mnc: 01
            tac: 1
          supportedSnssaiList:
            - sst: 1
              sd: 000001
            - sst: 1
              sd: 000002
  TA_LIST: |-
    - tai:
        plmnId:
          mcc: 001
          mnc: 01
        tac: 1
      accessType: 3GPP_ACCESS
      supportedSnssaiList:
        - sst: 1
          sd: 000001
        - sst: 1
          sd: 000002
  MAPPING_LIST_FROM_PLMN: |-
    - operatorName: dummyoperator
      homePlmnId:
        mcc: 001
        mnc: 02
      mappingOfSnssai:
        - servingSnssai:
            sst: 1
            sd: 00001
          homeSnssai:
            sst: 1
            sd: 00001
        - servingSnssai:
            sst: 1
            sd: 00002
          homeSnssai:
            sst: 1
            sd: 00002
```

### PCF
- On Dockerhub: [`louisroyer/dev-free5gc-pcf`](https://hub.docker.com/r/louisroyer/dev-free5gc-pcf).

Please note that even if this software is not yet properly packaged using `.deb`, the generated binary file `/usr/local/bin/pcf` is provided to you under Apache Version 2.0 License. A copy of this license can be found in `/usr/share/common-licenses/Apache-2.0`.
A copy of the source code is available at in the repository [`free5gc/pcf`](https://github.com/free5gc/pcf).

Environment variable used to select templating system:
```yaml
environment:
  ROUTING_SCRIPT: "docker-setup"
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/free5gc/pcf.yaml"
  CONFIG_TEMPLATE: "/usr/local/share/free5gc/template-pcf.yaml"
```

Environment variables for templating:
```yaml
environment:
  MONGO_HOST: "mongodb.db"
  MONGO_PORT: "27017"
  MONGO_NAME: "free5gc"
  SBI_REGISTER_IP: "pcf.sbi" # you can use a domain or an IP address
  SBI_BINDING_IP: "198.51.100.5" # use only an IP address in this field
  SBI_BINDING_PORT: "8000" # default: "8000"
  NRF: "nrf.sbi:8000"
  PCF_NAME: "PCF"
  LOCALITY: "area1"
```

### SMF
- On Dockerhub: [`louisroyer/dev-free5gc-smf`](https://hub.docker.com/r/louisroyer/dev-free5gc-smf).

Please note that even if this software is not yet properly packaged using `.deb`, the generated binary file `/usr/local/bin/smf` is provided to you under Apache Version 2.0 License. A copy of this license can be found in `/usr/share/common-licenses/Apache-2.0`.
A copy of the source code is available at in the repository [`free5gc/smf`](https://github.com/free5gc/smf).

Environment variable used to select templating system:
```yaml
environment:
  ROUTING_SCRIPT: "docker-setup"
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/free5gc/smf.yaml"
  CONFIG_TEMPLATE: "/usr/local/share/free5gc/template-smf.yaml"
  TEMPLATE_SCRIPT_UEROUTING: "template-script-uerouting.sh"
  TEMPLATE_SCRIPT_UEROUTING_ARGS: ""
  CONFIG_FILE_UEROUTING: "/etc/free5gc/uerouting.yaml"
  CONFIG_TEMPLATE_UEROUTING: "/usr/local/share/free5gc/template-uerouting.yaml"
```

Environment variables for templating:
```yaml
environment:
  N4: "203.0.113.1"
  SBI_REGISTER_IP: "smf.sbi" # you can use a domain or an IP address
  SBI_BINDING_IP: "198.51.100.6" # use only an IP address in this field
  SBI_BINDING_PORT: "8000" # default: "8000"
  NRF: "nrf.sbi:8000"
  LOCALITY: "area1"
  MCC: "001"
  MNC: "01"
  SNSSAI_INFOS: |-
    - sNssai:
        sst: 1
        sd: 000001
      dnnInfos:
        - dnn: internet
          dns:
            ipv4: 9.9.9.9
            ipv6: 2620:fe::fe
    - sNssai:
        sst: 1
        sd: 000002
      dnnInfos:
        - dnn: edge
          dns:
            ipv4: 9.9.9.9
            ipv6: 2620:fe::fe
  UP_NODES: |-
    gNB1:
      type: AN
    UPF:
      type: UPF
      nodeID: "203.0.113.2"
      addr: "203.0.113.2"
      sNssaiUpfInfos:
        - sNssai:
            sst: 1
            sd: 000001
          dnnUpfInfoList:
            - dnn: internet
              pool:
                - cidr: 10.0.0.0/24
              staticPools:
                - cidr: 10.0.1.0/24
        - sNssai:
            sst: 1
            sd: 000002
          dnnUpfInfoList:
            - dnn: edge
              pool:
                - cidr: 10.0.2.0/24
              staticPools:
                - cidr: 10.0.3.0/24
      interfaces:
        - interfaceType: N3
          endpoints:
            - 233.252.0.1
          networkInstances:
            - internet
  LINKS: |-
    - A: gNB1
      B: UPF
  ULCL: "true"
  UEROUTING_INFO: |-
    group1:
      members:
        - imsi-001010000000001
      topology:
        - A: gNB1
          B: UPF
```

### UDM
- On Dockerhub: [`louisroyer/dev-free5gc-udm`](https://hub.docker.com/r/louisroyer/dev-free5gc-udm).

Please note that even if this software is not yet properly packaged using `.deb`, the generated binary file `/usr/local/bin/udm` is provided to you under Apache Version 2.0 License. A copy of this license can be found in `/usr/share/common-licenses/Apache-2.0`.
A copy of the source code is available at in the repository [`free5gc/udm`](https://github.com/free5gc/udm).

Environment variable used to select templating system:
```yaml
environment:
  ROUTING_SCRIPT: "docker-setup"
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/free5gc/udm.yaml"
  CONFIG_TEMPLATE: "/usr/local/share/free5gc/template-udm.yaml"
```

Environment variables for templating:
```yaml
environment:
  SBI_REGISTER_IP: "udm.sbi" # you can use a domain or an IP address
  SBI_BINDING_IP: "198.51.100.7" # use only an IP address in this field
  SBI_BINDING_PORT: "8000" # default: "8000"
  NRF: "nrf.sbi:8000"
```

### UDR
- On Dockerhub: [`louisroyer/dev-free5gc-udr`](https://hub.docker.com/r/louisroyer/dev-free5gc-udr).

Please note that even if this software is not yet properly packaged using `.deb`, the generated binary file `/usr/local/bin/udr` is provided to you under Apache Version 2.0 License. A copy of this license can be found in `/usr/share/common-licenses/Apache-2.0`.
A copy of the source code is available at in the repository [`free5gc/udr`](https://github.com/free5gc/udr).

Environment variable used to select templating system:
```yaml
environment:
  ROUTING_SCRIPT: "docker-setup"
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/free5gc/udr.yaml"
  CONFIG_TEMPLATE: "/usr/local/share/free5gc/template-udr.yaml"
```

Environment variables for templating:
```yaml
environment:
  MONGO_HOST: "mongodb.db"
  MONGO_PORT: "27017"
  MONGO_NAME: "free5gc"
  SBI_REGISTER_IP: "udr.sbi" # you can use a domain or an IP address
  SBI_BINDING_IP: "198.51.100.8" # use only an IP address in this field
  SBI_BINDING_PORT: "8000" # default: "8000"
  NRF: "nrf.sbi:8000"
```
