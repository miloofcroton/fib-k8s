# docker pull miloofcroton/full-stack-docker-client:latest
# docker pull miloofcroton/full-stack-docker-api:latest
# docker pull miloofcroton/full-stack-docker-worker:latest

# docker build --cache-from miloofcroton/full-stack-docker-client -t miloofcroton/full-stack-docker-client:latest -f ./client/Dockerfile ./client
# docker build --cache-from miloofcroton/full-stack-docker-api -t miloofcroton/full-stack-docker-api:latest -f ./api/Dockerfile ./api
# docker build --cache-from miloofcroton/full-stack-docker-worker -t miloofcroton/full-stack-docker-worker:latest -f ./worker/Dockerfile ./worker

# docker tag miloofcroton/full-stack-docker-client:latest miloofcroton/full-stack-docker-client:$SHA
# docker tag miloofcroton/full-stack-docker-api:latest miloofcroton/full-stack-docker-api:$SHA
# docker tag miloofcroton/full-stack-docker-worker:latest miloofcroton/full-stack-docker-worker:$SHA

docker build -t miloofcroton/full-stack-docker-client:latest -t miloofcroton/full-stack-docker-client:$SHA -f ./client/Dockerfile ./client
docker build -t miloofcroton/full-stack-docker-api:latest -t miloofcroton/full-stack-docker-api:$SHA -f ./api/Dockerfile ./api
docker build -t miloofcroton/full-stack-docker-worker:latest -t miloofcroton/full-stack-docker-worker:$SHA -f ./worker/Dockerfile ./worker

docker push miloofcroton/full-stack-docker-client:latest
docker push miloofcroton/full-stack-docker-api:latest
docker push miloofcroton/full-stack-docker-worker:latest

docker push miloofcroton/full-stack-docker-client:$SHA
docker push miloofcroton/full-stack-docker-api:$SHA
docker push miloofcroton/full-stack-docker-worker:$SHA

kubectl apply -f cluster

kubectl set image cluster/client-deployment client=miloofcroton/full-stack-docker-client:$SHA --record
kubectl set image cluster/api-deployment api=miloofcroton/full-stack-docker-api:$SHA --record
kubectl set image cluster/worker-deployment worker=miloofcroton/full-stack-docker-worker:$SHA --record
