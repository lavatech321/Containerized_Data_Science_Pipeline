= Containerised Data Science Pipeline with CI/CD

This project demonstrates a complete end-to-end DevOps + Data Science pipeline where a Python-based data science application is containerised, deployed, and automated using Terraform, Ansible, Jenkins, and Docker.

== Project Overview

We are building a Containerised Data Science Pipeline in which:

* A Python data science application analyzes student data
* The application is containerised using Docker
* Jenkins CI/CD pipeline is used to build and deploy the application
* Terraform provisions infrastructure on AWS EC2
* Ansible installs and configures Docker and Jenkins automatically
* The application is deployed as a Streamlit dashboard
* Jenkins Blue Ocean UI is used to visualize the entire pipeline

== Detailed Workflow
1. Terraform
* Provisions AWS EC2 instance

2. Ansible (Triggered by Terraform)
* Installs Docker
* Installs Jenkins
* Configures Jenkins environment

3. Jenkins CI/CD Pipeline
* Pulls code from GitHub
* Builds Docker image
* Runs container
* Deploys the data science application

4. Docker
* Hosts the containerised application

5. Streamlit Application
* Runs on port 8501
* Displays analysed student data


== Application Details

* Python script analyzes student data, uses:
Pandas
NumPy
Matplotlib
Streamlit
Generates insights and visualizations
Provides an interactive dashboard
