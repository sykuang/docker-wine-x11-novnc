![Docker Pulls](https://img.shields.io/docker/pulls/sykuang/wine-x11-novnc.svg)
![Docker Stars](https://img.shields.io/docker/stars/sykuang/wine-x11-novnc.svg?colorB=dfb317)
[![Docker Automated build](https://img.shields.io/docker/automated/sykuang/wine-x11-novnc.svg)](https://hub.docker.com/r/sykuang/wine-x11-novnc/)
[![Docker build](https://img.shields.io/docker/build/sykuang/wine-x11-novnc.svg)](https://hub.docker.com/r/sykuang/wine-x11-novnc/)
# Run A windows application with docker
Using the docker image to run windows application with Chinese support like smartget on my Synology Nas(DS 916+)

## Install Image
   `docker pull sykuang/wine`
## Usage
### Run image as Server
   * Run
     ```bash
     docker run -p 8080:8080 -p 8081:22 sykuang/wine-x11-novnc
     ```
   * Run with Tranditional Chinese Support
     ```bash
     docker run -p 8080:8080 -p 8081:22  -e LANG=zh_TW.UTF-8 -e LC_ALL=zh_TW.UTF-8 sykuang/wine-x11-novnc
     ```
   * Adanvace Run
     ```bash
     docker run \
     -v $HOME/Downloads:/home/docker/.wine/drive_c/Downloads \
     -v $HOME/WinApp:/home/docker/.wine/drive_c/WinApp \
     -p 8080:8080 \
     -p 8081:22 \
     sykuang/wine
     ```

This follows these docker conventions:

*  `-v $HOME/WinApp:/home/docker/.wine/drive_c/WinAp` shared volume (folder) for your Window's programs data.
*  `-v $HOME/Downloads:/home/docker/.wine/drive_c/Downloads` shared volume (folder) for your Window's Download Folder.
*  `-p 8080:8080` port that you will be connecting to.(8080 has been hard code in the dockerfile, You can use port fowarding to other port like
	```bash
    -p 8083:8080
    ```
*  `-p 8081:22` SSH

### Client

* Using SSH
	```bash
	ssh -x docker@hostname -p 8081
	```
    Defalutl password is 1234
* Using noVNC
	```
	firefox http://hostname:8080
	```
	or just visit `http://hostname:8080` by the browse you like
