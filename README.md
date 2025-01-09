# Microservices Deployment on Amazon EKS

This project demonstrates deploying two microservices (`product_service` and `user_service`) on an Amazon EKS (Elastic Kubernetes Service) cluster. The microservices are written in different programming languages, containerized using Docker, and deployed using Kubernetes manifests. Terraform is used to provision the EKS cluster, and Docker Hub hosts the container images.

---

## **Project Overview**

### **1. Product Service**
- **Language**: Node.js (Express.js)
- **Port**: 3000
- **Description**: Handles product-related operations.
- **Directory**: `product_service/`

### **2. User Service**
- **Language**: Python (Flask)
- **Port**: 5000
- **Description**: Handles user-related operations.
- **Directory**: `user_service/`

---


---

## **Prerequisites**

1. **Tools Required:**
   - AWS CLI
   - Terraform
   - Docker
   - Kubectl

2. **Docker Hub**:
   - Ensure you have a Docker Hub account for pushing images.
   - Authenticate Docker with:
     ```bash
     docker login
     ```

3. **AWS Setup**:
   - AWS CLI configured with proper credentials.
   - IAM role with necessary permissions for EKS and Terraform.


## **Setup Instructions**

### **1. Provision the EKS Cluster**
Use Terraform to create the EKS cluster.

1. Initialize Terraform:
   ```bash
   terraform init
   ```
2. Apply Terraform configuration:
   ```bash
   terraform apply
   ```
### **2. Starting EKS Cluster**
Use awscli to start EKS cluster.

1. Start Cluster
    ```bash
    # Region is eu-north-1

    aws eks --region eu-north-1 update-kubeconfig --name my-cluster-eks
    ```

### **3. Push Docker images to your own Dockerhub (Optional)**
Use image_push.sh to build the Docker images for the microservices and push them to Docker Hub.

1. Make the script executable:
   ```bash
   chmod +x image_push.sh
   ```

2. Run the script:
   ```bash
   ./image_push.sh
   ```

### **4. Deploy Services to EKS**
Use eks_deploy.sh to deploy the microservices to the EKS cluster.

1. Make the script executable:
   ```bash
   chmod +x eks_deploy.sh
   ```

2. Run the script:
   ```bash
   ./eks_deploy.sh
   ```

### **5. Accessing Services**
Access the services by the Links.

- user_service: http://<EXTERNAL_IP>:8080/users
- product_service: http://<EXTERNAL_IP>:8081/products

### **6. Cleaning Up**

1. Delete Kubernetes Resources:
Remove the deployments and services.

    ```bash
    kubectl delete -f k8s/
    ```

2. Destroy EKS Infrastructure:
Remove the Terraform-managed resources.

    ```bash
    terraform destroy
    ```

