FROM kalilinux/kali-bleeding-edge


ENV DEBIAN_FRONTEND=noninteractive



# Helpers
RUN apt-get update && apt-get install -y vim xterm pulseaudio cups 

RUN apt-get -y dist-upgrade 
RUN apt update -y ; apt upgrade -y ; apt install sudo wget curl -y ; sudo DEBIAN_FRONTEND=noninteractive apt install kali-tools-top10 -y ; sudo DEBIAN_FRONTEND=noninteractive apt install kali-desktop-xfce -y ; sudo DEBIAN_FRONTEND=noninteractive apt install software-properties-common git -y && add-apt-repository ppa:dawidd0811/neofetch -y && apt install neofetch -y 
RUN apt-get install -y wget curl

RUN curl -fSL "https://download.nomachine.com/download/7.7/Linux/nomachine_7.7.4_1_amd64.deb" -o nomachine.deb \
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
