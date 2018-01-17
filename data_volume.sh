#!/bin/bash

# 数据卷
# 1. 数据卷可以在容器之间共享和重用，容器间传递数据将变得高效方便
# 2. 对数据卷数据的修改会立马生效，无论是容器内操作还是本地操作
# 3. 对数据卷的更新不会影响镜像，解耦了应用和数据
# 4. 卷会一直存在，直到没有容器使用，可以安全的卸载它

# 挂载一个主机目录作为数据卷
mkdir -p ~/data-volume

# 使用-v /webapp 创建一个数据卷挂载到容器内部
docker run -d -P --name web -v /webapp training/webapp python app.py


# 挂载一个本地 /src/webapp 目录到容器中的 /opt/webapp 作为数据卷
docker run -d -P --name wen1 -v /src/webapp:/opt/webapp training/webapp python app.py
# 挂载的数据卷默认权限是读写的，可以通过ro指定为只读
docker run -d -P --name wen1 -v /src/webapp:/opt/webapp:ro training/webapp python app.py

# 1.创建一个数据卷容器dbdata, 并在其中创建一个数据卷/dbdata
docker run -it -v /data --name dbdata ubuntu
# ls 查看目录，发现有一个 /dbdata目录
# 2. 创建两个容器，使用 --volumes-from 来挂载dbdata中的数据卷
docker run -it --volumes-from dbdata --name db1 ubuntu
docker run -it --volumes-from dbdata --name db2 ubuntu
# 此时，3个容器任何一方在改目录下的读写，其他容器都可以看到 
# 还可以从其他已经挂载了容器卷的容器来挂载数据卷
docker run -d --name db3 --volumes-from db1 training/postfres

#备份
docker run --volumes-from dbdata -v $PWD:/backup --name worker ubuntu tar cvf /backup/backup.tar /dbdata

# 恢复数据
# 1.创建一个带数据卷的容器dbdata2
docker run  -it -v /dbdata --name dbdata2 ubuntu /bin/bash
# 2.创建一个新的容器，挂载dbdata2的容器，并使用tar 命令解压备份文件到挂载容器中



