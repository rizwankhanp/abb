step1:- Upgrade Packages in Dockerfile
If vulnerabilities exist in base OS packages

Dockerfile:-

RUN apt-get update && apt-get upgrade -y



docker build -t abb.azurecr.io/docsgeneratorservice:v229 .

docker push abb.azurecr.io/docsgeneratorservice:v229

trivy image abb.azurecr.io/docsgeneratorservice:v229
