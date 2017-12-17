# 学习Docker

# 环境搭建
- 阿里云服务器安装脚本

``` sh
curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh -
```

- 配置docker 加速服务(阿里云)  

```sh
    sudo mkdir -p /etc/docker  
    # registry-mirrors可以去阿里云申请
    sudo tee /etc/docker/daemon.json <<-'EOF'
    {
    "registry-mirrors": ["https://2dipklk7.mirror.aliyuncs.com"]
    }
    EOF 
    sudo systemctl daemon-reload  
    sudo systemctl restart docker
```

- 如果是自己本地搭建docker服务器的自己找教程，跟这个是类似的


# 基本概念
 `镜像`: Docker镜像类似于虚拟机镜像， 可以将它理解为一个只读的模板，例如：一个镜像可以包含一个基本的操作系统，里面仅仅安装了Apache应用程序，可以把它称之为一个Apache镜像.
 
 `容器`: Docker容器类似于一个轻量级沙箱，在镜像的基础上创建可读可写一层文件系统.
 
 `仓库`: Docker仓库类似于代码仓库，是集中存放镜像文件的地方.
 

# 操作镜像
```sh
# 下载镜像
docker pull 镜像名称:tag [default:latest]
# 查看镜像详细信息
docker inspect 镜像名称
# 删除镜像 -f 强制删除
docker rmi 镜像名称
# 创建镜像
docker [-m][-a] commit 容器名称 | 容器Id
```

# 操作容器
```sh
# --name 给容器起别名，必须唯一，后面可以根据容器名对容器做操作
# -p 本机端口:容器端口 指定如何映射容器端口到本机端口
# -it 分配一个终端并绑定标准输入
# -d 后台运行
# -v 本机目录:容器目录 挂载本机目录到容器内
# --volumes-from=容器名称 从其他容器挂载卷

docker run [--name] 容器别名 [-p 80:80]  镜像名称
```

