FROM ubuntu:20.04


ENV DEBIAN_FRONTEND=noninteractive

ENV NOMACHINE_PACKAGE_NAME nomachine_7.1.3_1_amd64.deb
ENV NOMACHINE_BUILD 7.1
ENV NOMACHINE_MD5 d833ad52f92e5b3cc30c96f12686d97f

# Helpers
RUN apt-get update && apt-get install -y vim xterm pulseaudio cups 

RUN apt-get -y dist-upgrade 
RUN apt-get install -y  xfce4 xfce4-goodies firefox nano sudo

RUN apt-get install -y wget curl

RUN curl -fSL "http://download.nomachine.com/download/${NOMACHINE_BUILD}/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb \
&& dpkg -i nomachine.deb && sed -i "s|#EnableClipboard both|EnableClipboard both |g" /usr/NX/etc/server.cfg

# Set the Chrome repo.
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# Install Chrome.
RUN apt-get update && apt-get -y install google-chrome-stable

RUN apt-get clean
RUN apt-get autoclean

RUN echo 'pref("browser.tabs.remote.autostart", false);' >> /usr/lib/firefox/browser/defaults/preferences/vendor-firefox.js
RUN rm -rf /var/lib/apt/lists/*

EXPOSE 4000

VOLUME [ "/home/nomachine" ]

ADD nxserver.sh /

RUN chmod +x /nxserver.sh

ENTRYPOINT ["/nxserver.sh"]
