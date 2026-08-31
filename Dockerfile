# ==========================================
# 阶段 1：构建阶段 (Builder)
# ==========================================
FROM alpine:3.23 AS builder

WORKDIR /app

# 安装编译阶段所需的系统工具
RUN apk add --no-cache git bash nodejs npm

# 1. 拉取项目源码
RUN git clone https://github.com/wuwangzhang1216/ChinaTextbookStudyFree.git .

# 2. 执行脚本下载资源文件
RUN bash scripts/download-assets.sh

# 3. 安装依赖并构建静态文件
# 注：根据项目实际逻辑，先安装根目录依赖，然后进入 apps/web 执行构建
RUN npm install
RUN cd apps/web && npm run build

# ==========================================
# 阶段 2：运行阶段 (Runner)
# ==========================================
FROM node:20-alpine AS runner

WORKDIR /app

# 全局安装静态文件服务器 serve
RUN npm install -g serve

# 仅从构建阶段复制 Next.js 生成的 out 静态文件目录
COPY --from=builder /app/apps/web/out ./out

# 暴露 80 端口
EXPOSE 80

# 启动静态文件服务器
CMD ["serve", "out", "-l", "80"]
