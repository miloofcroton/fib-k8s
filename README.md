# fib-k8s

## architecture

![Project architecture](./architecture.png)


## installation reqs

- brew (duh)
- docker
- kubectl
- virtualbox
- minikube
- google cloud sdk cli

## service reqs

- travis
- github
- google cloud

## dev reqs

- `minikube up`

## notes

- using `ingress-nginx` by `kubernetes` (github.com/kubernetes/ingress-nginx), not `kubernetes-ingress` by `nginx`
- ran `travis encrypt-file service-account.json -r miloofcroton/full-stack-k8s` to encrypt gcloud secret