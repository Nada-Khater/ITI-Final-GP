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

  ``` python
  variable "ns-names" {
    type = list(string)
    default = [ "dev", "tools" ]
  }
  ```

- In [namespaces.tf](https://github.com/Nada-Khater/ITI-Final-GP/blob/main/Terraform/namespaces.tf) define your resource.

  ``` python
  resource "kubernetes_namespace" "ns" {
    count = length(var.ns-names)
    metadata {
      name = var.ns-names[count.index]
    }
  }
  ```
  - Verify namespace creation.


  ![Screenshot from 2024-06-28 20-14-28](https://github.com/Nada-Khater/ITI-Final-GP/assets/71197108/4d39e33f-1c2f-4340-85af-ec270bfbc889)


### 3. Tools namespace will have pod for Jenkins and Nexus(installed using Terraform)

- create [Jenkins Deployment](https://github.com/Nada-Khater/ITI-Final-GP/blob/main/Terraform/jenkins-deploy.tf) and [Nexus Deployment](https://github.com/Nada-Khater/ITI-Final-GP/blob/main/Terraform/nexus-deploy.tf) .

![deploys](https://github.com/Nada-Khater/ITI-Final-GP/assets/71197108/fd21db12-3646-409e-89cf-37357b837607)


- create services for Jenkins , Nexus , Docker.

```
resource "kubernetes_service" "services" {
  for_each = var.svc-data
  metadata {
    name      = each.value.name
    namespace = var.ns-names[each.value.namespace]
    labels = each.value.labels
  }
  spec {
    selector = each.value.labels
    port {
      port        = each.value.port
      target_port = each.value.target_port
    }
    type = each.value.type
  }
}
```

![services](https://github.com/Nada-Khater/ITI-Final-GP/assets/71197108/187db74b-aa88-4696-bfbe-319b08e81447)


- create Service Account For Jenkins.

```
resource "kubernetes_service_account" "jenkins-SA" {
  metadata {
    name = "jenkins-service-account"
    namespace = var.ns-names[1]
  }
}
```


![SA](https://github.com/Nada-Khater/ITI-Final-GP/assets/71197108/32e8f641-a1bf-4cda-b47d-c3ab29575e2c)


- create Role and Bind it to Jenkins.

 ```
 resource "kubernetes_role" "jenkins_role" {
  metadata {
    name      = "jenkins-role"
    namespace = var.ns-names[1]
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "pods/log", "services", "deployments", "configmaps", "secrets"]
    verbs      = ["get", "list", "create", "update", "delete"]
  }
}
 ```

![role](https://github.com/Nada-Khater/ITI-Final-GP/assets/71197108/0b6aef5c-a0ac-4063-aa30-e3e4f9cdf4ab)


 ```
 resource "kubernetes_role_binding" "jenkins_role_binding" {
  metadata {
    name      = "jenkins_role_binding"
    namespace = var.ns-names[1]
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.jenkins-SA.metadata[0].name
    namespace = var.ns-names[1]
  }

  role_ref {
    kind     = "Role"
    name     = kubernetes_role.jenkins_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}
 ```

![rb](https://github.com/Nada-Khater/ITI-Final-GP/assets/71197108/f9157728-cb30-423f-9130-d72e36a50e6f)


### 4. Dev namespace will run two pods: one for nodejs application and another for MySQL DB
- Create k8s deployment for mysql in `dev` namespace. [mysql-deploy.tf](https://github.com/Nada-Khater/ITI-Final-GP/blob/main/Terraform/mysql-deploy.tf)
- Define k8s services for both `mysql` and `nodejs app`. [variables.tf](https://github.com/Nada-Khater/ITI-Final-GP/blob/main/Terraform/services.tf)

  - MySql default values:
    ``` python 
    mysql = {
        name        = "mysql"
        port        = 3306
        target_port = 3306
        namespace   = 0     // dev ns
        type        = "ClusterIP"
        labels      = {
          app = "mysql"
        }
      }
    ```
  - Nodejs app default values:
    ``` python 
    nodejs = {
          name        = "nodejs"
          port        = 80
          target_port = 3000
          namespace   = 0     // dev ns
          type        = "NodePort"
          labels      = {
            app = "nodejs"
          }
        }
    ```
- Configured the needed mysql credentials as `k8s secret`. [mysql-secret.tf](https://github.com/Nada-Khater/ITI-Final-GP/blob/main/Terraform/mysql-secret.tf)
  - Add your mysql credentials here:
    ``` python
    mysql_root_password = "your-root-password"
    mysql_db_name       = "your-db-name"
    mysql_user_name     = "your-username"
    mysql_user_password = "your-user-password"
    ```

  - To run the terraform code 
    ```
    terraform init
    terraform apply --var-file mysql.tfvars
    ```
- Check all resources in `dev` namespace.

  <img src="https://github.com/Nada-Khater/ITI-Final-GP/assets/75952748/00d447e6-f24a-4c4b-9502-fe15eb530c51" width="920">

### 5. Create a Jenkins pipeline job to do the following:
  - Checkout code from https://github.com/mahmoud254/jenkins_nodejs_example.git
  - Build nodejs app usng dockerfile
  - Create a Docker image
  - Upload Docker image to nexus

### 6. Create another Jenkins pipeline job that run the Docker container on the requested environment from nexus on minikube.

