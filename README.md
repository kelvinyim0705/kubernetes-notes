# kubernetes-notes

# MiniKube Architecture with UNRAID
```
Physical Hardware
└── Unraid (Host Operating System)
   └── Arch Linux VM (Virtual Machine)
       └── Docker (Container Engine)
           └── minikube container (running Kubernetes components)
               └── Kubernetes Pod (e.g. hello-minikube)
```
![image](https://github.com/user-attachments/assets/1753ee9a-024e-4792-94ee-03f2397bbb96)


# MiniKube Setup
1. Follow the instruction to Install `miniKube` </br>
ref: [https://docs.docker.com/desktop/setup/install/linux/archlinux/](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download)

2. Follow the instruction to Install `kubectl` </br>
ref: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

3. Health Check
``` bash
minikube start --driver=docker
minikube status
kubectl version
```

---
# Basic Command
```
# create & delete
kubectl run {your_app_name} --image={image_name} 
kubectl create deployment/service {your-app-name}.yaml
kubectl delete deployment/service {your-app-name}.yaml


# debug
kubectl describe {your_app_name}
kubectl expose enpoint {your_name_name}
kubectl get pods,deployments,replicaset,svc --show-labels

# edit
kubectl scale rs {your_app_name} --replica=5
kubectl edit pod {your_app_name}

```

---
# YAML template

## Pod
``` yaml
apiVersion: v1
kind: Pod
metadata: 
  name:  #{POD_NAME}
  labels:
    name:  #{POD_NAME}
    app: #{APP_NAME}
spec:
```
## Deployment
``` yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: Enter deployment name
spec:
  replicas: Enter the number of replicas
  template:
    metadata:
      labels:
        editor: vscode
    spec:
      containers:
      - name: name
        image: Enter containers image
```

## Service
``` yaml
kind: Service
apiVersion: v1
metadata:
  name:  Service Name
spec:
  selector:
    app:  Selector Label
  type:  LoadBalancer | ClusterIP | NodePort
  ports:
  - name:  name-of-the-port
    port:  80
    targetPort:  8080
```

---
# Q & A
Kubernetes network -> NodePort vs ClusterIP vs LoadBalancer ? </br>
tbc
Deployments vs Replicaset ?
tbc


---
Hands-on labs reference:
https://github.com/dockersamples/example-voting-app/tree/main
