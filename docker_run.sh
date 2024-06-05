#!/bin/bash
NETWORK_NAME="jupyterhub-auth" 
CONTAINER_NAME="dahub-auth" 
IMAGE_NAME="hub-image" 
IMAGE_TAG="latest"

# 删除已存在的网络（如果存在）
if docker network inspect "$NETWORK_NAME" > /dev/null 2>&1; then
    echo "Removing existing network: $NETWORK_NAME"
    docker network rm "$NETWORK_NAME" > /dev/null 2>&1 
fi

# 创建 Docker 网络
echo "Creating Docker network: $NETWORK_NAME" 
docker network create "$NETWORK_NAME"

# 删除已存在的容器（如果存在）
if docker container inspect "$CONTAINER_NAME" > /dev/null 2>&1; 
then
    echo "Removing existing container: $CONTAINER_NAME"
    docker container rm "$CONTAINER_NAME" > /dev/null 2>&1 
fi

# 删除已存在的镜像（如果存在）
if docker image inspect "${IMAGE_NAME}:${IMAGE_TAG}" > /dev/null 2>&1; 
then
    echo "Removing existing image: ${IMAGE_NAME}:${IMAGE_TAG}"
    docker image rm "${IMAGE_NAME}:${IMAGE_TAG}" > /dev/null 2>&1 
fi

# 拉取 JupyterHub 和单用户 notebook 镜像
echo "Pulling JupyterHub and singleuser images..." 
docker pull jupyterhub/jupyterhub 
docker pull jupyterhub/singleuser

# 构建镜像
echo "Building the hub-image..." 
docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .

# 运行容器
echo "Running the JupyterHub container..." 
docker run --rm\
  -v /var/run/docker.sock:/var/run/docker.sock \
  --net "$NETWORK_NAME" \
  --name "$CONTAINER_NAME" \
  -p 12346:8000 \
  "${IMAGE_NAME}:${IMAGE_TAG}" \
  jupyterhub
