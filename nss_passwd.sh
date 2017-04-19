export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
cat /etc/passwd > /passwd
echo "container:x:${USER_ID}:${GROUP_ID}:Container:/tmp/bootstrap:/bin/bash" >> /passwd
export LD_PRELOAD=libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/passwd
export NSS_WRAPPER_GROUP=/etc/group
