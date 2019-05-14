docker pull miloofcroton/full-stack-docker-client:latest
docker pull miloofcroton/full-stack-docker-server:latest
docker pull miloofcroton/full-stack-docker-worker:latest

docker build --cache-from miloofcroton/full-stack-docker-client -t miloofcroton/full-stack-docker-client:latest -f ./client/Dockerfile ./client
docker build --cache-from miloofcroton/full-stack-docker-server -t miloofcroton/full-stack-docker-server:latest -f ./server/Dockerfile ./server
docker build --cache-from miloofcroton/full-stack-docker-worker -t miloofcroton/full-stack-docker-worker:latest -f ./worker/Dockerfile ./worker

docker tag miloofcroton/full-stack-docker-client:latest miloofcroton/full-stack-docker-client:$SHA
docker tag miloofcroton/full-stack-docker-server:latest miloofcroton/full-stack-docker-server:$SHA
docker tag miloofcroton/full-stack-docker-worker:latest miloofcroton/full-stack-docker-worker:$SHA

docker push miloofcroton/full-stack-docker-client:latest
docker push miloofcroton/full-stack-docker-server:latest
docker push miloofcroton/full-stack-docker-worker:latest

docker push miloofcroton/full-stack-docker-client:$SHA
docker push miloofcroton/full-stack-docker-server:$SHA
docker push miloofcroton/full-stack-docker-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/client-deployment client=miloofcroton/full-stack-docker-client:$SHA --record
kubectl set image deployments/server-deployment server=miloofcroton/full-stack-docker-server:$SHA --record
kubectl set image deployments/worker-deployment worker=miloofcroton/full-stack-docker-worker:$SHA --record
