FROM nvidia/cuda:12.4.1-runtime-ubuntu20.04
# 设置默认 Shell 为 Bash
SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive
# USER root
ENV UV_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    echo $SHELL && echo "开始安装 wget" && apt-get update -y && apt install wget -y && \
    echo "开始安装 uv" && wget -qO- https://astral.sh/uv/install.sh | sh && \
    echo "添加环境变量" && source $HOME/.local/bin/env && \
    echo "安装python3.10和3.11" && uv python install 3.10.15 3.11.10

# 将UV添加到环境变量
ENV PATH=/root/.local/bin:/root/.local/share/uv/python/cpython-3.10.15-linux-x86_64-gnu/bin:$PATH
CMD ["/bin/bash"]
