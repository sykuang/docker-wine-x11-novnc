![Docker Pulls](https://img.shields.io/docker/pulls/sykuang/wine-x11-novnc.svg)
![Docker build](https://github.com/sykuang/docker-wine-x11-novnc/actions/workflows/docker-build.yaml/badge.svg)
# Run A windows application with docker
Using the docker image to run windows applications with Chinese support like "Smartget" on my Synology Nas(DS 916+)

## Install Image
   `docker pull sykuang/wine-x11-novnc`
## Usage
### Run image as Server
   * Run
     ```bash
     docker run -p 8080:8080 -p 8081:22 sykuang/wine-x11-novnc
     ```
   * Run with Traditional Chinese Support
     ```bash
     docker run -p 8080:8080 -p 8081:22  -e LANG=zh_TW.UTF-8 -e LC_ALL=zh_TW.UTF-8 sykuang/wine-x11-novnc
     ```
   * Advance Run
     ```bash
     docker run \
     -v $HOME/Downloads:/home/docker/.wine/drive_c/Downloads \
     -v $HOME/WinApp:/home/docker/.wine/drive_c/WinApp \
     -p 8080:8080 \
     -p 8081:22 \
     sykuang/wine
     ```
   * Advance Run with VNC password
     ```bash
     docker run \
     -v $HOME/Downloads:/home/docker/.wine/drive_c/Downloads \
     -v $HOME/WinApp:/home/docker/.wine/drive_c/WinApp \
     -e VNC_PASSWORD=password \
     -p 8080:8080 \
     -p 8081:22 \
     sykuang/wine
     ```

This follows these docker conventions:

*  `-v $HOME/WinApp:/home/docker/.wine/drive_c/WinAp` shared volume (folder) for your Window's programs data.
*  `-v $HOME/Downloads:/home/docker/.wine/drive_c/Downloads` shared volume (folder) for your Window's Download Folder.
*  `-p 8080:8080` port that you will be connecting to. (8080 has been hard code in the Dockerfile, You can use port forwarding to other port like)
	```bash
    -p 8083:8080
    ```
*  `-p 8081:22` SSH

#### Variable list
|Name         |explanations                                                       |
|-------------|-------------------------------------------------------------------|
|VNC_PASSWORD |The password for login VNC website; Default will empty(No password)|
|USER_PASSWORD|The password of user; this is for ssh usage                        |
|PUID          |Set the UID of the user                                            | 
|PGID          |Set the GID of the user                                            | 

### Client

* Using SSH
	```bash
	ssh -x docker@hostname -p 8081
	```
    Default password is 1234
* Using noVNC
	```
	firefox http://hostname:8080
	```
	or just visit `http://hostname:8080` by the browse you like
