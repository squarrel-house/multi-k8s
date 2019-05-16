docker build -t squirrelhouse/multi-client:latest -t squirrelhouse/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t squirrelhouse/multi-server:latest -t squirrelhouse/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t squirrelhouse/multi-worker:latest -t squirrelhouse/multi-worker:$SHA -f ./worker/Dockerfile ./worker
docker push squirrelhouse/multi-client:latest
docker push squirrelhouse/multi-server:latest
docker push squirrelhouse/multi-worker:latest

docker push squirrelhouse/multi-client:$SHA
docker push squirrelhouse/multi-server:$SHA
docker push squirrelhouse/multi-worker:$SHA

kubectl apply -f k8s/
kubectl set image deployments/server-deployment server=squirrelhouse/multi-server:$SHA
kubectl set image deployments/client-deployment client=squirrelhouse/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=squirrelhouse/multi-worker:$SHA