# 1. 基础镜像：使用 alpine:3.23
FROM alpine:3.23

# 设置工作目录
WORKDIR /app

# 安装必要的系统构建依赖（git, nodejs, npm, bash 等）
RUN apk add --no-cache git bash nodejs npm

# 2. 使用 git 拉取项目代码
RUN git clone https://github.com/wuwangzhang1216/ChinaTextbookStudyFree.git .

# 3. 执行脚本下载资源文件
# cd ChinaTextbookStudyFree 并在项目目录下运行 scripts/download-assets.sh
RUN bash scripts/download-assets.sh

# 4. 安装 Node.js 依赖并编译 Next.js web 项目
# 进入根目录安装全局/Monorepo依赖，然后进入 apps/web 进行构建
RUN npm install
RUN cd apps/web && npm run build

# 暴露端口 (Next.js 默认运行在 3000 端口)
EXPOSE 3000

# 运行容器：启动 web 应用
# (假设 apps/web 中配置了 start 脚本，进入该目录运行 npm run start)
WORKDIR /app/apps/web
CMD ["npm", "run", "start"]
