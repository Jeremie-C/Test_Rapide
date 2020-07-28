#!/bin/sh
set -e
# Default command (assuming container start)
if [ "$1" = 'supervisord' ]; then
	host_conf="/etc/dnsmasq.d/dockerhost.conf"
	if [ -f $host_conf ]; then
		rm -f $host_conf
	fi
	echo "Generating configuration in $host_conf"
	touch $host_conf
	echo "address=/${HOST_NAME}/${HOST_IP}" | tee -a $host_conf
	echo $HOST_IP | awk -v dzone=${HOST_NAME} -F . '{print "ptr-record="$4"."$3"."$2"."$1".in-addr.arpa,"dzone}' | tee -a $host_conf
	
	# Turn /etc/resolv.conf on
	if [ "$DNS_NORESOLV" = true ]; then
		sed -i '/no-resolv/ s/^#*//' /etc/dnsmasq.conf
	else
		sed -i '/no-resolv/ s/^#*/#/' /etc/dnsmasq.conf
	fi
	# Turn /etc/hosts on
	if [ "$DNS_NOHOSTS" = true ]; then
		sed -i '/no-resolv/ s/^#*//' /etc/dnsmasq.conf
	else
		sed -i '/no-resolv/ s/^#*/#/' /etc/dnsmasq.conf
	fi
	# Turn query loggin on
	if [ "$LOG_QUERIES" = true ]; then
		sed -i '/log-queries/ s/^#*//' /etc/dnsmasq.conf
	else
		sed -i '/log-queries/ s/^#*/#/' /etc/dnsmasq.conf
	fi
	# Start supervisord
	exec /usr/bin/supervisord -n -u root -c /etc/supervisord.conf
fi
# Any other command (assuming container already running)
exec "$@"
