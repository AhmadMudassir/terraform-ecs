# 🚀 Nginx Deployment on AWS ECS Fargate using Terraform

This project demonstrates how to deploy an Nginx container on AWS using ECS Fargate. All infrastructure is defined and provisioned using Terraform.

---

## 📦 Project Overview

The infrastructure includes:

- A custom VPC with a public subnet
- Internet Gateway for outbound access
- Route table with public routing
- Security group allowing HTTP (port 80)
- ECS Cluster and Fargate service
- Nginx container image pushed to Amazon ECR
- Task definition for running the container

---

## 🖼 Architecture Diagram

![ECS_Terraform_Dark](https://github.com/user-attachments/assets/f074e36b-a237-4a73-962f-05557902ca57)


---

## 🛠 Technologies Used

- **Terraform** for Infrastructure as Code
- **AWS ECS (Fargate)** to run the container
- **AWS ECR** to store the Docker image
- **Nginx** as the containerized web server
- **Docker** for image management
- **IAM Roles** for ECS execution

---

## 📁 Project Structure

```bash
.
├── main.tf               # All infrastructure definitions
├── variables.tf          # Input variables
├── outputs.tf            # Output values (e.g. public IP)
├── images/
│   └── architecture.png  # Architecture diagram
└── README.md             # Project documentation
```

---

## 🚀 Getting Started

### ✅ Prerequisites

- Terraform v1.x installed
- AWS CLI configured (`aws configure`)
- Docker installed and running
- Sufficient AWS permissions (IAM, ECS, VPC, ECR)

### ⚙️ Deployment Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/<your-repo>.git
   cd <your-repo>
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Review the execution plan**
   ```bash
   terraform plan
   ```

4. **Apply the configuration**
   ```bash
   terraform apply
   ```

5. **Verify the deployment**
   - Get the public IP from Terraform output or ECS console
   - Visit: `http://<public-ip>` in your browser

---

## 🧹 Cleanup

To tear down the resources:

```bash
terraform destroy
```

---

## 🙋 Author

**Ahmad Mudassir**  
Cloud Intern  
[LinkedIn](https://www.linkedin.com/in/your-profile)

---

## 📝 License

This project is licensed under the MIT License.
