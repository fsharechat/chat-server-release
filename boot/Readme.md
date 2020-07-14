# 飞享服务端发布说明

在部署之前,有必要对部署目录`boot`做一些说明
```shell
├── download #android客户端 Apk
│   └── chat-debug.apk
├── push-connector # 信令消息服务器目录，支持TCP,WSS链接
│   ├── jvm.ini #jvm参数配置
│   ├── lib
│   │   └── spring-boot-dubbo-push-connector-1.0.0-SNAPSHOT.jar
│   ├── logs # 日志
│   └── push-connector # 启动脚本
└── push-group # 业务相关逻辑服务，包括http登录接口
    ├── jvm.ini #jvm参数配置
    ├── lib
    │   └── spring-boot-web-push-group-1.0.0-SNAPSHOT.jar
    ├── logs # 日志
    └── push-group # 启动脚本
```

另外由于`Java`项目需要jdk支持,为了避免与系统其他jdk环境变量冲突,在shell脚本启动的时候,指定了`jdk`的目录.另外`Dubbo`需要注册中心支持,所以需要安装`zookeeper`.当然如果你们公司有现成的注册中心,可以直接配置不需要手动安装一套.因此我们推荐在`Centos`/data`施行如下的目录配置

```shell
├── boot //这里文件内容就是本项目的具体内容
├── jdk
└── zookeeper-3.4.6
```

**NOTE:** 由于`jdk`和`zookeeper`文件过大,并没有把它们包含在项目中,本项目仅仅包括boot目录中内容,有人可能要问为什么要在/data 目录下放置如上的内容,下面展示一段shell命令.

* push-connecotor脚本

```shell
#!/bin/sh
# 这里可以修改JAVA_HOME的路径
JAVA_HOME=/data/jdk

APP_NAME=$(basename "$0")
APP_DIR=/data/boot/${APP_NAME}
APP_VERSION_FILE=${APP_DIR}/version
APP_LIB=${APP_DIR}/lib
JVM_INI=${APP_DIR}/jvm.ini
JVM_INI_LOCAL=${APP_DIR}/../jvm.ini

```

**NOTE:** 上面指定了`JAVA_HOME` 目录在`/data/jdk`.当然你可以把jdk防止在任意位置,只要指定其具体位置就可以,或者你也可以修改脚本,只需要配置java环境变量即可.一切都是为了配置基础的运行环境,如果你熟悉java环境,你可以随时配置


# 参数配置

目前仅有两个服务启动既可运行,参数配置仅需关心,各个目录下config即可