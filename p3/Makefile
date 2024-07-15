setup:
	bash ./setup.bash

launch:
	kubectl apply -f application.yaml

argocd-login:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

port-forward-argocd:
	kubectl port-forward service/argocd-server -n argocd 8080:443

port-forward-wil-playground:
	kubectl port-forward service/wil-playground -n dev 8888:8888

test-wil-app:
	curl localhost:8888

re: clean setup

clean:
	kubectl delete all --all
	sudo kubectl delete -f application.yaml --ignore-not-found=true
	sudo kubectl delete namespace dev --ignore-not-found=true
	k3d cluster delete mycluster

.PHONY: setup launch argocd-login port-forward-argocd port-forward-wil-playground test-wil-app re clean