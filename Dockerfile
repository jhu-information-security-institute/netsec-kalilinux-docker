FROM kalilinux/kali-last-release:latest

#ARG needs to be after FROM!
ARG USERNAME
ARG PASSWORD
ARG KALISHELL
ARG NOVNCPORT
ARG VNCPORT
ARG SSHPORT

ENV USERNAME=$USERNAME
ENV PASSWORD=$PASSWORD
ENV SHELL=$KALISHELL
ENV NOVNCPORT=$NOVNCPORT
ENV VNCPORT=$VNCPORT
ENV SSHPORT=$SSHPORT

RUN echo "USERNAME=${USERNAME}"
RUN echo "PASSWORD=${PASSWORD}"
RUN echo "SHELL=${SHELL}"
RUN echo "NOVNCPORT=${NOVNCPORT}"
RUN echo "VNCPORT=${VNCPORT}"
RUN echo "SSHPORT=${SSHPORT}"

LABEL maintainer="reub@jhu.edu"

RUN sed -i "s/http.kali.org/mirrors.ocf.berkeley.edu/g" /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install \
    sudo \
    openssh-server \
    python2 \
    dialog \
    firefox-esr \
    inetutils-ping \
    htop \
    nano \
    net-tools \
    tigervnc-standalone-server \
    tigervnc-xorg-extension \
    tigervnc-viewer \
    novnc \
    dbus-x11
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install \
    xfce4-goodies \
    kali-linux-core \
    kali-desktop-xfce && \
    apt-get -y full-upgrade
RUN apt-get -y autoremove && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m -c "Kali Linux" -s /bin/bash -d "/home/${USERNAME}" "${USERNAME}" && \
    sed -i "s/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g" /etc/ssh/sshd_config && \
    sed -i "s/#Port 22/Port ${SSHPORT}/g" /etc/ssh/sshd_config && \
    sed -i "s/off/remote/g" /usr/share/novnc/app/ui.js && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    touch /usr/share/novnc/index.htm
RUN mkdir /run/dbus
RUN mkdir /mnt/dockershared
COPY startup.sh /startup.sh
USER $USERNAME
WORKDIR /home/$USERNAME
EXPOSE $NOVNCPORT
ENTRYPOINT ["/bin/bash", "/startup.sh"]
