# 容器互联
# > 容器的互联是一种让`多个容器的应用进行快速交互的方式`，
# > 它会在源和接收容器之间创建连接关系，接收容器可以通过`容器名`快速访问到容器
# > 而不用指定具体的`IP`地址

# 创建db容器
docker run -d --name db training/postgres
# 创建web容器 使用 --link name:alias 建立互联关系  `name`表示要连接的容器的名称 `alias` 表示整个连接的别名
docker run -d - P --name web --link db:db training/webapp python app.py

