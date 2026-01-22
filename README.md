# IRC
Repositório de Códigos da Prática Laboratorial da UC Introdução às Redes de Computadores
The run-docker.sh script uses the vinicf/core-9.0.3:latest image
The image has CORE 9.0.3 installed with all IRC TP dependencies.
It has been created using the Dockerfile.ubuntu

The script runs a container and it also does the following:
- Creates a shared volume defined in SHARED variable ($SHARED:/shared).
- Shares the host display to run core-gui.
- Forwards the host's 2000 port to container's 22.
- Injects the ~/.ssh/id_ed25519.pub as an authorized host key (it does not create it previously).
- To create the key use command: ssh-keygen -t ed25519
