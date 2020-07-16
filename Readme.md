# 飞享服务端发布说明

在部署之前,有必要对部署目录`boot`做一些说明
```shell
├── download #android客户端 Apk
│   └── chat-debug.apk
├── push-connector # 信令消息服务器目录，支持TCP,WSS链接
│   ├── jvm.ini #jvm参数配置
│   ├── lib
│   │   └── spring-boot-dubbo-push-connector-1.2.0-SNAPSHOT.jar
│   ├── logs # 日志
│   └── push-connector # 启动脚本
└── push-group # 业务相关逻辑服务，包括http登录接口
    ├── jvm.ini #jvm参数配置
    ├── lib
    │   └── spring-boot-web-push-group-1.2.0-SNAPSHOT.jar
    ├── logs # 日志
    └── push-group # 启动脚本
```

另外由于`Java`项目需要jdk支持,为了避免与系统其他jdk环境变量冲突,在shell脚本启动的时候,指定了`jdk`的目录.另外`Dubbo`需要注册中心支持,所以需要安装`zookeeper`.当然如果你们公司有现成的注册中心,可以直接配置不需要手动安装一套.因此我们推荐在`Centos`,`/data`施行如下的目录配置

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


# 部署说明

## 下载完整安装包
* [chat-server-deploy](https://media.comsince.cn/minio-bucket-file-name/fshare-centos-deploy.tar.gz)

**NOTE:** 下载完成后,请将压缩文件解压到`/data`目录下即可,注意上面的命令行都是以这个目录为标准的,切忌不要随意放置

## 下载部署服务

**NOTE:**  由于github仓库限制以及网络问题,不便上传.当你下载完下面两个服务jar包,分别放到相应服务的`lib`目录下,请选择以下最新版本下载

### push-connector服务
* [push-connector-1.2.0-SNAPSHOT](https://media.comsince.cn/minio-bucket-file-name/spring-boot-dubbo-push-connector-1.2.0-SNAPSHOT.jar)

### push-group服务
* [push-group-1.2.0-SNAPSHOT](https://media.comsince.cn/minio-bucket-file-name/spring-boot-web-push-group-1.2.0-SNAPSHOT.jar)



# 参数配置

目前仅有两个服务启动既可运行,参数配置仅需关心,各个目录下config即可,你需要配置下面的文件即可,具体在每个服务的`config`目录下

## push-connector

```yaml
# wss ssl 配置,这里配置jks需要指定其绝对路径地址
push.ssl.keystore=/data/boot/push-connector/config/chat.comsince.cn.jks
push.ssl.truststore=/data/boot/push-connector/config/chat.comsince.cn.trustkeystore.jks
push.ssl.password=123456
## Dubbo Registry
dubbo.registry.address=zookeeper://zookeeper:2181

## kafka broker 
#push.kafka.broker=kafka:9092

## kurento client url,群组音视频服务
kurento.clientUrl=ws://media.comsince.cn:8888/kurento

## minio url
minio.url=https://media.comsince.cn
## minio access_key
minio.access_key=
## minio secret_key
minio.secret_key=


```

## push-group

```yaml

## Dubbo 注册中心
dubbo.registry.address=zookeeper://zookeeper:2181


#云短信厂商,1:代表阿里云短信 2: 代表腾讯云短信
sms.cp=2
# 应用id
sms.appid=LTAI4Ff1jtqrSr3rkHMKEnfs
# 应用key
sms.appkey=gG33mvmMAxGYol7Vd1AEG6InRK9VCD
# 模板id
sms.templateId=SMS_180355435
# 短信签名由于编码问题,请到相应的代码里面设置

# 短信超级验证码,正式上线请修改
sms.superCode=6666

# 是否使用内置数据库 1: 表示使用 0: 使用mySql
im.embed_db=0
# jdbc url
im.jdbc_url=jdbc:mysql://mysql:3306/wfchat?useSSL=false&serverTimezone=GMT&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=utf8
# mysql数据库访问用户名
im.user=root
#mysql数据库访问密码
im.password=123456

```


# 启动服务

```shell
./push-group/push-group start
./push-connector/push-connector start
```