pssh
====
本工具是个并发、批量执行远程服务器集群、批量上传文件到服务器集群或者下载服务器集群上的文件或目录到本地的工具，本工具简单易懂、容易上手，是你管理服务器集群的利器


安装说明
1、只需将pssh.tar.gz解压或git clone https://github.com/linhaifeng/pssh.git到你的服务器目标目录即可
env.sh
实现系统检测及其依赖软件包的安装
pssh.sh 
实现了命令的解析和转发
thread.sh：
实现并发进程调用，降低响应时间，用于和expect程序进行交互，并过滤转化返回信息
exec.exp：
主要实现密码等交互信息的自动输入


使用说明
1、添加服务器信息到hosts.list,可以使用pssh.sh -a自动添加，或者手动建立hosts.list文件
hosts.list中主机信息格式如下
host1 username password(如果是默认的22端口，可以省略:port参数)
host2:port username password
2、指定集群服务器信息文件,使用pssh.sh -h 文件名
3、执行远程命令，使用pssh.sh -c "命令 参数"
4、实现上传文件或目录到远程服务器集群，使用pssh.sh -u 源文件 目标文件
5、实现下载远程服务器集群上的文件或目录到本地，使用pssh.sh -d 源文件 目标文件
6、查看帮助，使用pssh.sh 或者pssh.sh --help