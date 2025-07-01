FROM atmoz/sftp:alpine

ARG USERNAME
ARG UPLOAD_PATH

COPY ssh_keys/id_rsa.pub /id_rsa.pub

RUN mkdir -p /home/${USERNAME}/.ssh && \
    mv /id_rsa.pub /home/${USERNAME}/.ssh/authorized_keys

ENV SFTP_USERS="${USERNAME}::::${UPLOAD_PATH}"