# 🚀 End-to-End DevOps Project – Student Data Analytics Application

A complete DevOps implementation of a Python-based Data Science application using Docker, Jenkins, Terraform, Ansible, AWS EC2, and Streamlit.

---

# 📌 Project Overview

This project demonstrates a complete DevOps workflow for deploying a Python Data Science application on AWS infrastructure.

The application analyzes student data and displays insights using an interactive Streamlit dashboard.

The project follows Infrastructure as Code (IaC), Configuration Management, Containerization, and CI/CD best practices.

---

# ⚙️ Technologies Used

| Technology | Purpose |
|------------|----------|
| Python | Data Science Application |
| Pandas | Data Analysis |
| NumPy | Numerical Computation |
| Streamlit | Dashboard UI |
| Docker | Containerization |
| Jenkins | CI/CD Automation |
| Jenkins Blue Ocean | Pipeline Visualization |
| Terraform | Infrastructure Provisioning |
| Ansible | Configuration Management |
| AWS EC2 | Cloud Hosting |
| Git & GitHub | Version Control |

---

# 🏗️ Project Architecture Flow

```text
                         ┌────────────────────┐
                         │     Terraform      │
                         │────────────────────│
                         │ Provisions AWS EC2 │
                         └─────────┬──────────┘
                                   │
                                   ▼
                    ┌────────────────────────────┐
                    │          Ansible           │
                    │────────────────────────────│
                    │ • Installs Docker          │
                    │ • Installs Jenkins         │
                    │ • Configures Jenkins Env   │
                    └──────────┬─────────────────┘
                               │
                               ▼
                  ┌──────────────────────────────┐
                  │      Jenkins CI/CD Pipeline  │
                  │──────────────────────────────│
                  │ • Pulls code from GitHub     │
                  │ • Builds Docker image        │
                  │ • Runs container             │
                  │ • Deploys application        │
                  └───────────┬──────────────────┘
                              │
                              ▼
                    ┌──────────────────────┐
                    │        Docker        │
                    │──────────────────────│
                    │ Hosts containerised  │
                    │ application          │
                    └──────────┬───────────┘
                               │
                               ▼
                 ┌────────────────────────────┐
                 │    Streamlit Application   │
                 │────────────────────────────│
                 │ • Runs on Port 8501        │
                 │ • Displays analysed        │
                 │   student data dashboard   │
                 └────────────────────────────┘
```

---

# 🚀 End-to-End Workflow

```text
Developer Pushes Code to GitHub
                │
                ▼
Terraform Creates AWS EC2 Infrastructure
                │
                ▼
Ansible Configures Server Automatically
                │
                ├── Install Docker
                ├── Install Jenkins
                └── Configure Jenkins
                │
                ▼
Jenkins Pipeline Starts
                │
                ├── Pull Source Code
                ├── Build Docker Image
                ├── Run Docker Container
                └── Deploy Application
                │
                ▼
Docker Hosts Streamlit Application
                │
                ▼
Users Access Dashboard on:
http://<EC2-PUBLIC-IP>:8501
```
---

# ☁️ Infrastructure Deployment

## Configure Terraform Variables

Update the `terraform.tfvars` file with your AWS credentials.

```bash
cat terraform.tfvars

AWS_ACCESS_KEY="add-your-creds"
AWS_SECRET_KEY="add-your-creds"
AWS_REGION="us-east-1"
```

---

## 🚀 Deploy Infrastructure Using Terraform

### Initialize Terraform

```bash
terraform init
```

### Apply Terraform Configuration

```bash
terraform apply --auto-approve
```

---

## 📤 Terraform Outputs

After successful deployment, Terraform generates useful access details.

```bash
terraform output
```

### Example Output

```text
EC2-Instance-access-details = <<EOT
ssh -i ~/.ssh/id_rsa ubuntu@54.86.169.125
EOT

Jenkins-Credentials = <<EOT
Username: admin
Password: admin123
EOT

Jenkins-UI = <<EOT
http://54.86.169.125:8080
EOT

Streamlit-Access = <<EOT
http://54.86.169.125:8501
EOT
```

---

## 👨‍💻 Jenkins Login Credentials

```text
Username: admin
Password: admin123
```

---

## 🌐 Application Access

Once deployment is complete:

## Jenkins Dashboard

```text
http://ec2-public-ip:8080
```

## Streamlit Dashboard

```text
http://ec2-public-ip:8501
```

---

# 🔥 Features

- 📊 Student data analysis dashboard
- 🐳 Dockerized Python application
- ⚡ Automated Jenkins CI/CD pipeline
- ☁️ Infrastructure provisioning using Terraform
- 🔧 Automated server configuration using Ansible
- 🚀 Continuous deployment on AWS EC2
- 📈 Jenkins Blue Ocean visualization
- 📦 Infrastructure as Code (IaC)

---

# CI/CD Benefits Achieved

- Faster deployments
- Infrastructure automation
- Reduced manual configuration
- Scalable deployment process
- Consistent environments
- Improved monitoring and visibility

---

# 🎯 Learning Outcomes

This project demonstrates practical knowledge of:

- DevOps lifecycle
- CI/CD implementation
- Infrastructure as Code
- Containerization
- Cloud deployment
- Automation tools integration

---
