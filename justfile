_default:
    @just --list

start-minikube:
    @minikube start \
        --extra-config "apiserver.cors-allowed-origins=["http://boot.dev"]"

minikube-dashboard:
    @minikube dashboard --port=63840
