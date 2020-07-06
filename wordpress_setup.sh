cd ./srcs/wordpress/srcs
kubectl get services | grep wordpress | awk '{print $4}' > WORDPRESS_IP
kubectl get pods | grep wordpress | awk '{print $1}' > WORDPRESS_POD
export WORDPRESS_IP=$(cat < WORDPRESS_IP)
export WORDPRESS_POD=$(cat < WORDPRESS_POD)
export PENDING=\<pending\>
until [ $WORDPRESS_IP != $PENDING ]
do
	kubectl get services | grep wordpress | awk '{print $4}' > WORDPRESS_IP
	export WORDPRESS_IP=$(cat < WORDPRESS_IP)
done
sed "s/WORD_IP/$WORDPRESS_IP/g" ./data/wordpress.sql > ./wordpress.sql
sed "s/WORD_IP/$WORDPRESS_IP/g" ./data/wp-config.php > ./wp-config.php
kubectl cp wordpress.sql $WORDPRESS_POD:/tmp/
kubectl cp wp-config.php $WORDPRESS_POD:/etc/wordpress/
kubectl exec $WORDPRESS_POD -- sh /tmp/init-wordpress.sh
rm WORDPRESS_IP
rm WORDPRESS_POD
export MINIKUBE_HOME=~/goinfre
