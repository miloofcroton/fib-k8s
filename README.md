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

## work flow

### local

    ```
    minikube up
    minikube addons enable ingress
    kubectl create secret generic pgpassword --from-literal PGPASSWORD=<password>
    ```

see local dev fix at bottom, or change rewrite rules in ingress controller (there is an api mismatch with minikube at the moment)

### google cloud

#### creating setup

- had to make travis use the new api. First, fix ~/.travis/config.yml as follows (note the last line, it was `.org`):
    ```
    repos:
    miloofcroton/full-stack-k8s:
        endpoint: https://api.travis-ci.com/
    ```
  then, I had to re-login using `travis login --pro` instead of just `travis login`

- ran this to encrypt gcloud secret:
    ```
    travis encrypt-file service-account.json -r miloofcroton/full-stack-k8s
    ```

- ran this in the gcloud shell to set context and then create the secret
    ```
    gcloud config set project full-stack-k8s
    gcloud config set compute/zone us-west1-a
    gcloud container clusters get-credentials k8s-cluster
    kubectl create secret generic pgpassword --from-literal PGPASSWORD=<password>
    ```
- installed helm and tiller via https://helm.sh/docs/using_helm/#installing-helm, then created service account and cluster role binding, then assigned cluster role binding to service account. This is all in the glcoud console.

    ```
    curl -LO https://git.io/get_helm.sh
    chmod 700 get_helm.sh
    ./get_helm.sh
    kubectl create serviceaccount --namespace kube-system tiller
    kubectl create clusterrolebinding tiller-cluster-role --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
    helm init --service-account tiller --upgrade
    helm install stable/nginx-ingress --name my-nginx --set rbac.create=true
    ```

#### after setup

- push to master (or merge PR)
- travis automatically deploys to gcloud

## notes

- using `ingress-nginx` by `kubernetes` (github.com/kubernetes/ingress-nginx), not `kubernetes-ingress` by `nginx`


## local dev fix (work in progress)

This is a work in progress to make minikube use the latest version of ingress-nginx via helm.

    ```
    minikube addons disable ingress

    curl -LO https://git.io/get_helm.sh
    chmod 700 get_helm.sh
    ./get_helm.sh

    kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
    ```
