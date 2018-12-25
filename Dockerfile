FROM phusion/baseimage:0.11

# Set correct environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV WINEARCH win32
ENV DISPLAY :0
ENV WINE_MONO_VERSION 4.5.6
ENV WINEPREFIX /home/docker/.wine
#ENV WINEARCH win32
ENV HOME /home/docker/

# Updating and upgrading a bit.
# Install vnc, window manager and basic tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends language-pack-zh-hant  x11vnc xdotool supervisor fluxbox git terminology sudo && \
    dpkg --add-architecture i386 && \

# We need software-properties-common to add ppas.
    curl https://dl.winehq.org/wine-builds/winehq.key -o /tmp/Release.key && \
    apt-get install -y --no-install-recommends software-properties-common && \
    apt-key add /tmp/Release.key && \
    apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/' && \
    apt-get update && \
    apt-get install -y --no-install-recommends  winehq-stable && \
    apt-get install -y --no-install-recommends cabextract unzip p7zip zenity xvfb && \
    curl -SL -k https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks  -o /usr/local/bin/winetricks && \
    chmod a+x /usr/local/bin/winetricks  && \
# Installation of winbind to stop ntlm error messages.
    apt-get install -y --no-install-recommends winbind && \
# Get latest version of mono for wine
    mkdir -p /usr/share/wine/mono && \
    curl -SL -k 'http://sourceforge.net/projects/wine/files/Wine%20Mono/$WINE_MONO_VERSION/wine-mono-$WINE_MONO_VERSION.msi/download' -o /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi && \
    chmod +x /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi && \
    mkdir -p /usr/share/wine/gecko && \
    curl -SL -k 'http://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi' -o /usr/share/wine/gecko/wine_gecko-2.47-x86.msi && \
    # Add Traditional Chinese Fonts
    mkdir -p /usr/share/fonts/TTF/ && \
    curl -SL -k https://github.com/adobe-fonts/source-han-sans/raw/release/OTF/TraditionalChinese/SourceHanSansTC-Regular.otf -o /usr/share/fonts/TTF/SourceHanSansTC-Regular.otf && \
    curl -SL -k https://github.com/adobe-fonts/source-han-sans/raw/release/OTF/TraditionalChinese/SourceHanSansTC-Bold.otf -o /usr/share/fonts/TTF/SourceHanSansTC-Bold.otf && \
    # Create user for ssh
    adduser \
            --home /home/docker \
            --disabled-password \
            --shell /bin/bash \
            --gecos "user for running application" \
            --quiet \
            docker && \
    echo "docker:1234" | chpasswd && \
    adduser docker sudo && \
    # Clone noVNC
    runuser -l docker -c "git clone https://github.com/novnc/noVNC.git /home/docker/novnc" && \
    # Clone websockify for noVNC
    runuser -l docker -c "git clone https://github.com/kanaka/websockify /home/docker/novnc/utils/websockify" && \
    ln -s /home/docker/novnc/vnc.html /home/docker/novnc/index.html && \
    chown docker -R /home/docker/novnc && \
# Cleaning up.
    apt-get autoremove -y --purge software-properties-common && \
    apt-get autoremove -y --purge && \
    apt-get clean -y && \
    rm -rf /home/wine/.cache && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add supervisor conf
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add entrypoint.sh
ADD entrypoint.sh /etc/entrypoint.sh


## Add novnc
ENTRYPOINT ["/bin/bash","/etc/entrypoint.sh"]
# Expose Port
EXPOSE 8080 22
