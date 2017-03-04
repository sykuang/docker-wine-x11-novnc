-Install Image
    ` docker pull kenkuang/wine`
-Usage
    * Run
        ` docker run -p 8080:8080 kenkuang/wine`
    * Run with Chinese (using env file)
        `docker run -p 8080:8080  --env-file ./CHT.env  kenkuang/wine`
    * Run with Chinese (by passing ENV)
        `docker run -p 8080:8080  -e LANG=zh_TW.UTF-8 -e LC_ALL=zh_TW.UTF-8 kenkuang/wine`
    * Run with Chinese (by passing ENV)
        `docker run -p 8080:8080  -e LANG=zh_TW.UTF-8 -e LC_ALL=zh_TW.UTF-8 kenkuang/wine`
