# full-stack-k8s

[![Build Status](https://travis-ci.com/miloofcroton/full-stack-k8s.svg?branch=master)](https://travis-ci.com/miloofcroton/full-stack-k8s)

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
- had to fix ~/./travis/config.yml as follows (note the last line, it was `.org`):
    ```
    repos:
    miloofcroton/full-stack-k8s:
        endpoint: https://api.travis-ci.com/
    ```
- as part of the above fix, I had to re-login using `travis login --pro` instead of just `travis login`
- ran this in the gcloud shell to set context before creating secret
    ```
    gcloud config set project full-stack-k8s
    gcloud config set compute/zone us-west1-a
    gcloud container clusters get-credentials k8s-cluster
    ```
- ran this in the gcloud shell to generate actual secret (with actual password)
    ```
    kubectl create secret generic pgpassword --from-literal PGPASSWORD=<password>
    ```
- installed helm and tiller via https://helm.sh/docs/using_helm/#installing-helm in the gcloud console
- create service account and cluster role binding, then assign cluster role binding to service account

    ```
    kubectl create serviceaccount --namespace kube-system tiller
    kubectl create clusterrolebinding tiller-cluster-role --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
    ```

- run `helm init --service-account tiller --upgrade` in gcloud console
- run `helm install stable/nginx-ingress --name my-nginx --set rbac.create=true` in gcloud console
