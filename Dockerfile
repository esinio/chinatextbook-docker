# ==========================================
# 阶段 1：构建阶段 (Builder)
# ==========================================
FROM node:20-alpine AS builder

WORKDIR /app

# 1. 安装基础系统工具（新增 python3 解决第 41 行报错）
RUN apk add --no-cache git bash curl wget unzip tar ca-certificates python3

# 2. 全局安装 pnpm 和 bun
RUN npm install -g pnpm bun

# 3. 拉取项目源码
RUN git clone https://github.com/wuwangzhang1216/ChinaTextbookStudyFree.git .

# 4. 赋予权限并执行资源下载脚本
RUN chmod +x scripts/download-assets.sh && bash scripts/download-assets.sh

# 5. 安装项目依赖并构建静态 web 文件
RUN npm install
RUN cd apps/web && npm run build

# ==========================================
# 阶段 2：运行阶段 (Runner)
# ==========================================
FROM node:20-alpine AS runner

WORKDIR /app

# 1. 安装轻量级静态 HTTP 服务器
RUN npm install -g serve

# 2. 从构建阶段复制 Next.js 生成的静态文件目录 out
COPY --from=builder /app/apps/web/out ./out

# 3. 暴露 80 端口
EXPOSE 80

# 4. 启动静态服务器
CMD ["serve", "out", "-l", "80"]
