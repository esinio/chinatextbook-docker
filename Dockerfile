# ==========================================
# 阶段 1：构建阶段 (Builder)
# ==========================================
FROM alpine:3.23 AS builder

WORKDIR /app

# 1. 安装系统依赖：新增了 curl, wget, unzip, tar, ca-certificates 等常见资源下载解压工具
RUN apk add --no-cache git bash nodejs npm curl wget unzip tar ca-certificates

# 2. 拉取项目源码
RUN git clone https://github.com/wuwangzhang1216/ChinaTextbookStudyFree.git .

# 3. 赋予脚本执行权限并运行资源下载脚本
RUN chmod +x scripts/download-assets.sh && bash scripts/download-assets.sh

# 4. 安装依赖并构建静态文件
RUN npm install
RUN cd apps/web && npm run build

# ==========================================
# 阶段 2：运行阶段 (Runner)
# ==========================================
FROM node:20-alpine AS runner

WORKDIR /app

# 全局安装静态文件服务器 serve
RUN npm install -g serve

# 复制生成的 static out 目录
COPY --from=builder /app/apps/web/out ./out

EXPOSE 80

CMD ["serve", "out", "-l", "80"]
