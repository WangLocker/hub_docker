# 读取 allowedusers.txt 文件并初始化全局变量 allowed_users
def load_allowed_users(file_path):
    with open(file_path, 'r') as file:
        # 读取文件内容并按逗号分割，然后去除空白字符
        user_ids = file.read().strip().split(',')
        # 返回一个去重的用户 ID 集合
        return set(user_id.strip() for user_id in user_ids)

# allowedusers.txt 文件位于 JupyterHub 配置文件相同的目录下
allowed_users_file_path = 'allowedusers.txt'   
allowed_users = load_allowed_users(allowed_users_file_path)


c.JupyterHub.authenticator_class = 'native'
import os, nativeauthenticator
c.JupyterHub.template_paths = [f"{os.path.dirname(nativeauthenticator.__file__)}/templates/"]

c.NativeAuthenticator.use_allowed_users = True
c.NativeAuthenticator.allowed_users = allowed_users

# 设置需要管理员审批用户注册
c.NativeAuthenticator.open_signup = True

# 定义允许注册和登录的用户白名单
c.Authenticator.whitelist = allowed_users

# 定义管理员用户
c.Authenticator.admin_users = {'hubAdminuser02'}


# 使用 docker 加载环境
c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'

# 监听所有的 IP 地址
c.JupyterHub.hub_ip = '0.0.0.0'

# 用于连接 hub 的主机名或IP地址，这里通常是 hub 的容器名称
c.JupyterHub.hub_connect_ip = 'dahub-auth'

# 选择一个 docker 镜像，应该与 Hub 中的 jupyterhub 版本保持一致
c.DockerSpawner.image = 'jupyterhub/singleuser'

# 告诉用户容器连接 docker 网络
c.DockerSpawner.network_name = 'jupyterhub-auth'

# 服务停止时会删除容器
#c.DockerSpawner.remove = True
