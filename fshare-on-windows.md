主要说明在windows部署步骤

# 基础环境
基础环境同centos.主要包括`zookeeper`,`mysql5.7`,`minio`,`JDK1.8`

**NOTE:** 在运行之前请确保`zookeeper`,`mysql`已经部署成功. `minio`是对象存储服务器,在发送图片,文件类型类型消息时需要使用.在运行之前请检查是否安装`Jdk`

# 安装包
下载如下安装包,解压文件到任意目录即可
* [飞享windows安装包](https://media.comsince.cn/minio-bucket-file-name/fshare-chat-windows-pro.tar.gz)

# 配置
解压成功后,会看到`boot`如下目录

```shell
boot
├── download
│   └── chat-debug.apk
├── push-connector
│   ├── config
│   │   ├── application.properties
│   │   ├── chat.comsince.cn.jks
│   │   ├── chat.comsince.cn.trustkeystore.jks
│   │   └── logback.xml
│   ├── jvm.ini
│   ├── lib
│   │   └── spring-boot-dubbo-push-connector-1.2.3.jar
│   ├── logs
│   │   ├── push-connector-error.log
│   │   ├── push-connector-error.log.20201013
│   │   ├── push-connector.log
│   │   └── push-connector.log.20201013
│   ├── push-connector
│   └── push-connector.bat
└── push-group
    ├── config
    │   └── application.properties
    ├── jvm.ini
    ├── lib
    │   └── spring-boot-web-push-group-1.2.3.jar
    ├── logs
    │   ├── push-group-error.log
    │   ├── push-group-error.log.20201013
    │   ├── push-group.log
    │   └── push-group.log.20201013
    ├── push-group
    └── push-group.bat

```

## push-connector配置

> 修改`push-connector\config\application.properties`

```yaml
# wss ssl 配置,这里配置jks需要指定其绝对路径地址.测试演示可以先不起动ssl.这里做配置为空即可
push.ssl.keystore=
push.ssl.truststore=
push.ssl.password=
## Dubbo Registry
dubbo.registry.address=zookeeper://{修改这里为你的zookeeper地址}:2181

## kafka broker 
#push.kafka.broker=kafka:9092

## 多人音视频媒体服务,默认使用公网服务,可先暂时不用修改
kurento.clientUrl=ws://media.comsince.cn:8888/kurento

## minio对象存储,如果暂时不需要支持文件,图片,视频类消息发送,可以暂时不用配置
minio.url=https://media.comsince.cn
## minio access_key
minio.access_key=
## minio secret_key
minio.secret_key=
```

## push-group配置

> 修改`push-group\config\application.properties`

```yaml

## Dubbo 注册中心
dubbo.registry.address=zookeeper://{修改这里为你的zookeeper地址}:2181

## 绑定dubbo 本机host地址,防止dubbo无法绑定服务地址,导致不同机器无法访问服务,push-group与push-connector部署在不同机器时最好设置
#dubbo.protocol.host=172.16.47.60

#云短信厂商,0: 代表暂时关闭短信通道 1:代表阿里云短信 2: 代表腾讯云短信
sms.cp=0
# 应用id
sms.appid=LTAI4Ff1jtqrSr3rkHMKEnfs
# 应用key
sms.appkey=gG33mvmMAxGYol7Vd1AEG6InRK9VCD
# 模板id
sms.templateId=SMS_180355435
# 短信签名由于编码问题,请到相应的代码里面设置

# 短信超级验证码,正式上线请修改,你可以使用这个超级验证码登录任意帐号
sms.superCode=66666

# 是否使用内置数据库 1: 表示使用 0: 使用mySql
im.embed_db=0
# jdbc url
im.jdbc_url=jdbc:mysql://{你的mysql服务地址}:3306/fsharechat?useSSL=false&serverTimezone=GMT&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=utf8
# mysql数据库访问用户名
im.user=root
#mysql数据库访问密码
im.password=123456

```

# 启动服务

**NOTE:** 启动服务请到各自服务目录下启动bat脚本

* 启动`push-group`服务,到`data\push-group`目录下执行`push-group.bat`

* 启动`push-connector`服务,到`data\push-connector`目录下执行`push-connector.bat`
