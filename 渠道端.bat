@echo off
echo '上传路径 /deploy/front/form/'
echo 输入密码执行上传
SET file=%~sf1
SET filename=%~n1%~x1
scp %file% root@39.108.121.54:/deploy/front/form/
echo 输入密码执行解压
ssh root@39.108.121.54 "unzip -o -d /deploy/front/form/ /deploy/front/form/%filename%"
pause