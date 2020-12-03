#!/bin/bash

echo "\n#--------------------------MINIKUBE SETUP--------------------------------\n"

#Detect the platform
OS="`uname`"
#Change settings depending on the platform
case $OS in
		"Linux")
			minikube start --vm-driver=docker --extra-config=apiserver.service-node-port-range=1-35000
			#sed -i '' "s/192.168.99.120:5050/172.17.0.20:5050/g" src/mysql/wordpress.sql
			FTPS_IP=172.17.0.21
		;;
		"Darwin")
			minikube start --driver=virtualbox --extra-config=apiserver.service-node-port-range=1-35000
			#sed -i '' "s/192.168.99.120:5050/192.168.99.120:5050/g" src/mysql/wordpress.sql
			FTPS_IP=192.168.99.121
		;;
		*) ;;
esac

echo "Starting Minikube (it might take a while)"
#minikube start --vm-driver=virtualbox
#FTPS_IP=192.168.99.129
eval $(minikube docker-env)
echo "#------------------ ADDONS MINIKUBE ------------------------------"

minikube addons enable dashboard
minikube addons enable metallb
minikube addons enable metrics-server



echo "\n#-------------------------- METALLB CONFIG ------------------------------\n"

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml

#ConfigMap MetalLB
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f srcs/yaml/metallb-configmap.yaml

kubectl apply -f srcs/yaml/mysqlvol.yaml
kubectl apply -f srcs/yaml/influxdbvol.yaml

echo "\n#-------------------------------- LUNCH DASHBOARD ----------------------------\n"
minikube dashboard &

docker build -t nginx_i srcs/nginx/.

kubectl apply -f srcs/yaml/mysql.yaml
docker build -t mysql_i srcs/mysql/.

docker build -t phpmyadmin_i srcs/phpmyadmin/.

docker build -t wordpress_i srcs/wordpress/.

docker build -t service_ftps --build-arg IP=${FTPS_IP} srcs/ftps

docker build -t influxdb_i srcs/influxdb/.

docker build -t grafana_i srcs/grafana/.

echo "\n#----------------------------------- SETUP K8s ----------------------------\n"
kubectl apply -f srcs/yaml/ftps.yaml

kubectl apply -f srcs/yaml/nginx.yaml

kubectl apply -f srcs/yaml/wordpress.yaml

kubectl apply -f srcs/yaml/grafana.yaml

kubectl apply -f srcs/yaml/influxdb.yaml

kubectl apply -f srcs/yaml/phpmyadmin.yaml

kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql wordpress -u root < srcs/mysql/wordpress.sql
CLUSTER_IP="$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)"
