FROM ubuntu:22.04
RUN apt-get update && apt-get install -y coreutils
COPY container_script.sh /main.sh
RUN chmod +x /main.sh
CMD ["/bin/bash", "/main.sh"]