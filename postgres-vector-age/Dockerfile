# 1. 使用一个包含 pgvector 的 PostgreSQL 16 基础镜像
# 你可以根据需要更改 Postgres 和 pgvector 的版本
FROM docker.1ms.run/pgvector/pgvector:0.8.1-pg18

# 2. 切换到 root 用户以安装编译依赖
USER root

# 3. 安装编译 AGE 所需的依赖
#    - postgresql-server-dev-16: PG 的开发头文件
#    - build-essential, clang, flex, bison: C 编译工具链
#    - git: 用于拉取 AGE 源码
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-server-dev-16 \
    build-essential libreadline-dev zlib1g-dev flex bison \
    clang \
    git \
    && rm -rf /var/lib/apt/lists/*

# 4. 克隆 Apache AGE 源码 (使用一个稳定的 release 标签)
RUN git clone --branch PG17/v1.6.0 https://github.com/apache/age.git /age-src

# 5. 编译和安装 AGE
WORKDIR /age-src
# 注意: PG_CONFIG 的路径必须正确指向
RUN make PG_CONFIG=/usr/bin/pg_config install

# 6. (可选) 清理编译依赖，减小镜像体积
RUN apt-get purge -y --auto-remove \
    postgresql-server-dev-16 \
    build-essential libreadline-dev zlib1g-dev flex bison \
    clang \
    git \
    && apt-get clean

# 7. 将我们的自定义初始化脚本复制到镜像的标准入口点目录
#    注意: 源路径是相对于 Dockerfile 的路径
COPY initdb/init-extensions.sh /docker-entrypoint-initdb.d/init-extensions.sh

# 8. 确保该脚本在镜像内部是可执行的
RUN chmod +x /docker-entrypoint-initdb.d/init-extensions.sh

# ----------------------------------------------------

# 9. 切换回 postgres 用户
USER postgres