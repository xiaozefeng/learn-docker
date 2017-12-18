#!/bin/bash

# 数据卷
# 1. 数据卷可以在容器之间共享和重用，容器间传递数据将变得高效方便
# 2. 对数据卷数据的修改会立马生效，无论是容器内操作还是本地操作
# 3. 对数据卷的更新不会影响镜像，解耦了应用和数据
# 4. 卷会一直存在，直到没有容器使用，可以安全的卸载它

# 挂载一个主机目录作为数据卷
mkdir -p ~/data-volume

# 
docker run --name content-nginx -d  -P -v /Users/xiaozefeng/data-volume nginx