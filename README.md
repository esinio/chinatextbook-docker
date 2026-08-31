# 让 gemini 根据要求编写dockerfile

## dev
``` shell
目标： 编写一个基于next.js的web项目容器镜像Dockerfile

步骤：
1 以alpine:3.23为基础镜像
2 使用 git 拉取项目代码 https://github.com/wuwangzhang1216/ChinaTextbookStudyFree
3 下载资源文件, cd ChinaTextbookStudyFree 在项目代码目录下执行bash scripts/download-assets.sh来下载资源文件
4 运行容器 
	在项目代码根目录下 cd apps/web
	安装依赖包 npm install
	运行 npm run dev -- -H 0.0.0.0 -p 3000
```

## docker
``` shell
目标： 编写一个基于next.js的web项目容器镜像Dockerfile

步骤：
1 以alpine:3.23为基础镜像
2 使用 git 拉取项目代码 https://github.com/wuwangzhang1216/ChinaTextbookStudyFree
3 下载资源文件, cd ChinaTextbookStudyFree 在项目代码目录下执行bash scripts/download-assets.sh来下载资源文件
4 运行容器 
	在项目代码根目录下: cd apps/web
	编译web: npm run build


编写git workflows来帮我编译并推送到docker hub

项目使用npm run build编译后需要通过npx serve out -l 80来启动。是不是只需要复制出out目录就可以了？
如果是，我希望通过多阶段构建来缩小容器文件大小。
```
