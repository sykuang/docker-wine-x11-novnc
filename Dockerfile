FROM phusion/baseimage:focal-1.2.0

# Set correct environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV WINEARCH win32
ENV DISPLAY :0
ENV WINE_MONO_VERSION 5.0.0
ENV WINE_GECKO_VERSION 2.47.1
ENV WINEPREFIX /home/docker/.wine
ENV HOME /home/docker/
ENV NOVNC_HOME /usr/libexec/noVNCdim

# Updating and upgrading a bit.
# Install vnc, window manager and basic tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends language-pack-zh-hant x11vnc supervisor fluxbox sudo kitty && \
    dpkg --add-architecture i386 && \
# We need software-properties-common to add ppas.
    # apt-get install -y --no-install-recommends software-properties-common && \
    apt-get update && \
    apt-get install -y --no-install-recommends wine wine32 && \
    apt-get install -y --no-install-recommends xvfb python3 && \
    apt-get install -y --no-install-recommends kitty && \
# Install winetricks
    curl -SL -k https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks  -o /usr/local/bin/winetricks && \
    chmod a+x /usr/local/bin/winetricks  && \
# Installation of winbind to stop ntlm error messages.
    apt-get install -y --no-install-recommends winbind && \
# Get latest version of mono for wine
    mkdir -p /usr/share/wine/mono && \
    curl -SL -k "http://dl.winehq.org/wine/wine-mono/$WINE_MONO_VERSION/wine-mono-$WINE_MONO_VERSION-x86.msi" -o "/usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION-x86.msi" && \
    chmod +x "/usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION-x86.msi" && \
    mkdir -p /usr/share/wine/gecko && \
    curl -SL -k "http://dl.winehq.org/wine/wine-gecko/$WINE_GECKO_VERSION/wine-gecko-$WINE_GECKO_VERSION-x86.msi" -o "/usr/share/wine/gecko/wine-gecko-$WINE_GECKO_VERSION-x86.msi" && \
    chmod +x "/usr/share/wine/gecko/wine-gecko-$WINE_GECKO_VERSION-x86.msi" && \
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
    adduser docker sudo 

# Clone noVNC
RUN mkdir -p "${NOVNC_HOME}"/utils/websockify \
    && curl -L https://github.com/novnc/noVNC/archive/v1.3.0.tar.gz | tar xz --strip 1 -C "${NOVNC_HOME}" \
    && curl -L https://github.com/novnc/websockify/archive/v0.10.0.tar.gz | tar xz --strip 1 -C "${NOVNC_HOME}"/utils/websockify \
    && chmod +x -v "${NOVNC_HOME}"/utils/novnc_proxy \
    && ln -s "${NOVNC_HOME}"/vnc.html "${NOVNC_HOME}"/index.html

RUN chown -R docker "${NOVNC_HOME}"
# Cleaning up.
RUN apt-get autoremove -y --purge && \
    apt-get clean -y && \
    rm -rf /home/wine/.cache && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Add supervisor conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add entrypoint.sh
COPY entrypoint.sh /etc/entrypoint.sh

ENTRYPOINT ["/bin/bash","/etc/entrypoint.sh"]
# Expose Port
EXPOSE 8080 22
