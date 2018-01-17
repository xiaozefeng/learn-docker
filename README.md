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

# 数据管理
1. 数据卷: `容器内数据直接映射到本地主机环境`
	- 在容器内创建数据卷
			
		``` sh
		# 使用 -v 在容器内创建数据卷，使用-v 标记可以创建多个
		docker run -d -P --name web -v /webapp training/webapp python app.py
		# 使用 inspect 查看容器信息
		docker inspect web
		# "Volumes": {
		#                "/webapp": {}
		#            },
		```
	- 挂载一主机目录作为数据卷
		``` sh
		# 挂载一个本地 /src/webapp 目录到容器中的 /opt/webapp 作为数据卷
		docker run -d -P --name wen1 -v /src/webapp:/opt/webapp training/webapp python app.py
		# 挂载的数据卷默认权限是读写的，可以通过ro指定为只读
				docker run -d -P --name wen1 -v /src/webapp:/opt/webapp:ro training/webapp python app.py		```

2. 数据卷容器: `使用特定的容器维护数据卷`
	
	```sh
	# 1.创建一个数据卷容器dbdata, 并在其中创建一个数据卷/dbdata
	docker run -it -v /data --name dbdata ubuntu
	# ls 查看目录，发现有一个 /dbdata目录
	# 2. 创建两个容器，使用 --volumes-from 来挂载dbdata中的数据卷
	docker run -it --volumes-from dbdata --name db1 ubuntu
	docker run -it --volumes-from dbdata --name db2 ubuntu
	# 此时，3个容器任何一方在改目录下的读写，其他容器都可以看到 
	# 还可以从其他已经挂载了容器卷的容器来挂载数据卷
	docker run -d --name db3 --volumes-from db1 training/postfres
	```
3. 利用数据卷容器来迁移数据
	
	``` sh
	#备份
	docker run --volumes-from dbdata -v $PWD:/backup --name worker ubuntu tar cvf /backup/backup.tar /dbdata
	
	# 回复
	# 1.创建一个带数据卷的容器dbdata2
	docker run  -it -v /dbdata --name dbdata2 ubuntu /bin/bash
	# 2.创建一个新的容器，挂载dbdata2的容器，并使用tar 命令解压备份文件到挂载容器中
	```

