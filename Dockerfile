# ==========================================
# 阶段 1：构建阶段 (Builder)
# ==========================================
FROM node:20-alpine AS builder

WORKDIR /app

# 1. 安装基础系统工具
RUN apk add --no-cache git bash curl wget unzip tar ca-certificates python3 ffmpeg

# 2. 全局安装 pnpm 和 bun
RUN npm install -g pnpm bun

# 3. 拉取项目源码
RUN git clone https://github.com/wuwangzhang1216/ChinaTextbookStudyFree.git .

# 4. 赋予权限并执行资源下载脚本
RUN chmod +x scripts/download-assets.sh && bash scripts/download-assets.sh

# 5. 安装项目依赖并构建静态 web 文件
RUN npm install && \
    cd apps/web && \
    npm run build && \
    cd /app && \
    rm -rf node_modules apps/web/node_modules ~/.npm ~/.cache

# ==========================================
# 阶段 2：运行阶段 (Runner) - 使用 Nginx
# ==========================================
FROM nginx:alpine AS runner

# 删除默认的 nginx 静态页面
RUN rm -rf /usr/share/nginx/html/*

# 从构建阶段复制 Next.js 生成的静态文件到 Nginx 的默认目录
COPY --from=builder /app/apps/web/out /usr/share/nginx/html

# 复制自定义的 Nginx 配置文件
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露 80 端口
EXPOSE 80

# Nginx 官方镜像自带 CMD ["nginx", "-g", "daemon off;"]，无需额外指定
