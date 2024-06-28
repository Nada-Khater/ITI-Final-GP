# Jenkins CI/CD Pipeline for Node.js App Deployment on Kubernetes - ITI Final GP 

## 📝 Overview
This project automates the CI/CD pipeline using Jenkins for deploying a Node.js application on Kubernetes. The setup involves creating and managing local Kubernetes instances with Minikube, deploying Jenkins and Nexus, and running Node.js and MySQL applications in a Kubernetes cluster.

## 🚀 Features
1. **CI/CD Pipeline:** Automates building and deployment of Node.js application.

2. **Infrastructure as Code:** Uses Terraform for provisioning Kubernetes namespaces and deploying services.

3. **Containerization:** Utilizes Docker for packaging applications into containers.

4. **Artifact Management:** Nexus is used for storing Docker images.

5. **Secrets Management:** Kubernetes secrets for managing sensitive configuration data securely.

## 📷 Screenshots
### 1. Install local K8s instance using Minikub (with Ansible).
<img src="https://github.com/Nada-Khater/ITI-Final-GP/assets/75952748/33ad17a7-5dcd-4ef8-91b5-128c56ff4f3c" width="920">

### 2. K8s instance will have two Namespaces: tools and dev (installed using Terraform)

- In [variables.tf](https://github.com/Nada-Khater/ITI-Final-GP/blob/main/Terraform/variables.tf) define variable for namespaces.

```
variable "ns-names" {
  type = list(string)
  default = [ "dev", "tools" ]
}
```

- In [namespaces.tf](https://github.com/Nada-Khater/ITI-Final-GP/blob/main/Terraform/namespaces.tf) define your resource.

```
resource "kubernetes_namespace" "ns" {
  count = length(var.ns-names)
  metadata {
    name = var.ns-names[count.index]
  }
}
```

### 3. Tools namespace will have pod for Jenkins and nexus(installed using Terraform)

### 4. Dev namespace will run two pods: one for nodejs application and another for MySQL DB
<img src="https://github.com/Nada-Khater/ITI-Final-GP/assets/75952748/00d447e6-f24a-4c4b-9502-fe15eb530c51" width="920">

### 5. Create a Jenkins pipeline job to do the following:
  - Checkout code from https://github.com/mahmoud254/jenkins_nodejs_example.git
  - Build nodejs app usng dockerfile
  - Create a Docker image
  - Upload Docker image to nexus

### 6. Create another Jenkins pipeline job that run the Docker container on the requested environment from nexus on minikube.

