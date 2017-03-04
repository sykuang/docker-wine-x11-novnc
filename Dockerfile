FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV WINEPREFIX /root/.wine
ENV WINEARCH win32
ENV DISPLAY :0
ENV WINE_MONO_VERSION 4.5.6
# Configure user nobody to match unRAID's settings
 RUN \
 usermod -u 99 nobody && \
 usermod -g 100 nobody && \
 usermod -d /config nobody && \
 chown -R nobody:users /home


# Updating and upgrading a bit.
	# Install vnc, window manager and basic tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends  language-pack-zh-hant  && \
    apt-get install -y x11vnc xdotool wget supervisor fluxbox
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN	dpkg --add-architecture i386 && \

# We need software-properties-common to add ppas.
	apt-get install -y --no-install-recommends software-properties-common && \
add-apt-repository ppa:ubuntu-wine/ppa && \
	apt-get update && \
apt-get install -y --no-install-recommends wine1.8 cabextract unzip p7zip wget zenity xvfb && \
	wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && chmod +x winetricks && mv winetricks /usr/local/bin && \
# Installation of winbind to stop ntlm error messages.
	apt-get install -y --no-install-recommends winbind 
# Get latest version of mono for wine
RUN mkdir -p /usr/share/wine/mono \
	&& curl -SL 'http://sourceforge.net/projects/wine/files/Wine%20Mono/$WINE_MONO_VERSION/wine-mono-$WINE_MONO_VERSION.msi/download' -o /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi \
&& chmod +x /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi
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
ADD https://github.com/adobe-fonts/source-han-sans/raw/release/OTF/TraditionalChinese/SourceHanSansTC-Regular.otf /usr/share/fonts/TTF/SourceHanSansTC-Regular.otf
ADD https://github.com/adobe-fonts/source-han-sans/raw/release/OTF/TraditionalChinese/SourceHanSansTC-Bold.otf /usr/share/fonts/TTF/SourceHanSansTC-Bold.otf
# Add novnc
ADD novnc /root/novnc/
# Expose Port
EXPOSE 8080

CMD ["/usr/bin/supervisord"]
