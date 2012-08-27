安装说明
1、只需将pssh.tar.gz解压到你的服务器目录即可
pssh.sh 这个是主文件，主要用于实现服务器信息列表的自动添加及其自动检查安装expect/scp等软件，用于和expect程序进行交互，并过滤转化返回信息
exec.exp 主要实现密码等交互信息的自动输入

使用说明
1、添加服务器信息到hosts.list,可以使用pssh.sh -a自动添加，或者手动建立hosts.list文件
hosts.list中主机信息格式如下
host1 username password(如果是默认的22端口，可以省略:port参数)
host2:port username password
2、执行远程命令，使用pssh.sh -c '命令 参数'
3、实现远程文件传输，使用pssh.sh -f 源文件 目标文件
4、查看帮助，使用pssh.sh