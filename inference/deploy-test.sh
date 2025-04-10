MODEL_NAME=custom
NAMESPACE=kubeflow
INGRESS_GATEWAY=kfserving-ingressgateway
CLUSTER_IP=$(kubectl -n istio-system get service $INGRESS_GATEWAY -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
SERVICE_HOSTNAME=$(kubectl get inferenceservice ${MODEL_NAME} -o jsonpath='{.status.url}' -n ${NAMESPACE} | cut -d "/" -f 3)


curl -v -H "Host: ${SERVICE_HOSTNAME}" -H "Content-Type: application/json" -d '{"image":"https://www.inspiredtaste.net/wp-content/uploads/2018/03/Easy-Ground-Pork-Tacos-Recipe-3-1200.jpg"}' http://$CLUSTER_IP/v1/models/${MODEL_NAME}:predict


docker build -t tacos-inference ./inference 
docker run -it -p 8000:8000 tacos-inference 

curl -H "Content-Type: application/json" -d '{"image":"https://lp-cms-production.imgix.net/image_browser/tacos_mexico_G.jpg?auto=format&fit=crop&sharp=10&vib=20&ixlib=react-8.6.4&w=850&q=20&dpr=5"}' http://localhost:8000/predict

