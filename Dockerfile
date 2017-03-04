FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV WINEARCH win32
ENV DISPLAY :0
ENV WINE_MONO_VERSION 4.5.6

# Updating and upgrading a bit.
	# Install vnc, window manager and basic tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends  language-pack-zh-hant  && \
    apt-get install -y x11vnc xdotool supervisor fluxbox
RUN	dpkg --add-architecture i386 && \

# We need software-properties-common to add ppas.
	apt-get install -y --no-install-recommends software-properties-common && \
add-apt-repository ppa:ubuntu-wine/ppa && \
	apt-get update && \
apt-get install -y --no-install-recommends wine1.8 cabextract unzip p7zip zenity xvfb && \
	curl -SL https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks  -o /usr/local/bin/winetricks && \
# Installation of winbind to stop ntlm error messages.
	apt-get install -y --no-install-recommends winbind
# Get latest version of mono for wine
RUN mkdir -p /usr/share/wine/mono && \
	curl -SL 'http://sourceforge.net/projects/wine/files/Wine%20Mono/$WINE_MONO_VERSION/wine-mono-$WINE_MONO_VERSION.msi/download' -o /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi && \
    chmod +x /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi
RUN mkdir -p /usr/share/wine/gecko && \
    curl -SL 'http://dl.winehq.org/wine/wine-gecko/2.40/wine_gecko-2.40-x86.msi' -o /usr/share/wine/gecko/wine_gecko-2.40-x86.msi

# Cleaning up.
RUN   apt-get autoremove -y --purge software-properties-common && \
      apt-get autoremove -y --purge && \
      apt-get clean -y && \
      rm -rf /home/wine/.cache && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /root/

# Add Traditional Chinese Fonts
RUN mkdir -p /usr/share/fonts/TTF/ && \
    curl -SL https://github.com/adobe-fonts/source-han-sans/raw/release/OTF/TraditionalChinese/SourceHanSansTC-Regular.otf -o /usr/share/fonts/TTF/SourceHanSansTC-Regular.otf
RUN curl -SL https://github.com/adobe-fonts/source-han-sans/raw/release/OTF/TraditionalChinese/SourceHanSansTC-Bold.otf -o /usr/share/fonts/TTF/SourceHanSansTC-Bold.otf
# Create user for ssh
RUN adduser \
            --home /home/xclient \
            --disabled-password \
            --shell /bin/bash \
            --gecos "user for running an xclient application" \
            --quiet \
            xclient 
RUN echo "xclient:1234" | chpasswd
# Generate ssh key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
## Add novnc
ADD novnc /root/novnc
# Add supervisor conf
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ENV WINEPREFIX /root/.wine
CMD ["/usr/bin/supervisord"]
# Expose Port
EXPOSE 8080
EXPOSE 8081
