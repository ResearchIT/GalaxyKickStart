#!/bin/bash
# write out environmental variables to /etc/default/supervisor,
# then source this file (to get both user-specified and default environemntal variables)
# and run ansible to adjust runtime settings. The argument to startup.sh is the location of
# the inventory file to be used
export LD_PRELOAD=libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/passwd
export NSS_WRAPPER_GROUP=/etc/group

printenv >> /etc/default/supervisor && source /etc/default/supervisor && \
           ansible-playbook galaxy.yml -c local \
           --tags "cloud_setup,persists_galaxy,nginx_config,galaxy_config_files,galaxy_extras_job_conf" --skip-tags=skip_supervisor_start_in_docker \
           --extra-vars nginx_galaxy_location=$NGINX_GALAXY_LOCATION \
           --extra-vars galaxy_admin=$GALAXY_CONFIG_ADMIN_USERS \
           --extra-vars ftp_upload_site=$IP_ADDRESS \
           --extra-vars nat_masquerade=$NAT_MAQUERADE \
           -i "$1" && \
           exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf --nodaemon
