# 🛡️ Enterprise DevSecOps Platform & SOC Automation

![Build Status](https://img.shields.io/github/actions/workflow/status/raslen-jendoubi/enterprise-devsecops-platform/deploy.yml)
![Security](https://img.shields.io/badge/Security-Trivy%20%2B%20Sentinel-red)
![Infrastructure](https://img.shields.io/badge/IaC-Terraform-purple)
![Cloud](https://img.shields.io/badge/Azure-Production-blue)

---

## 📖 Executive Summary

This project creates a **secure-by-design** cloud platform on Microsoft Azure. Unlike standard web deployments, this platform integrates a full **Security Operations Center (SOC)** lifecycle. 

It demonstrates the ability to not just **deploy** infrastructure, but to **secure, monitor, and defend** it against live attacks using SIEM automation.

### 🎯 Key Capabilities
* **Infrastructure as Code:** 100% automated provisioning using Terraform (No GUI clicks).
* **Zero Trust Supply Chain:** Automated vulnerability scanning (Trivy) blocks insecure builds before deployment.
* **Container Hardening:** Least-privilege execution (Non-root users) for threat mitigation.
* **SOC & Incident Response:** Real-time log ingestion into **Azure Sentinel** to detect brute-force and application attacks.

---

## 🏗️ Architecture

```mermaid
graph TD
    User["🌍 Public User"] -->|HTTPS| WebApp["Azure Web App (Secure Container)"]
    Attacker["👾 Attacker"] -->|Brute Force| WebApp
    
    subgraph Azure_Cloud [Azure Secure Cloud]
        WebApp -->|Logs & Metrics| LAW["📝 Log Analytics Workspace"]
        LAW -->|Ingestion| Sentinel["🛡️ Azure Sentinel (SIEM)"]
        ACR["📦 Azure Container Registry"] -->|Pull Image| WebApp
    end

    subgraph CI_CD [GitHub DevSecOps Pipeline]
        Dev["Developer"] -->|Push Code| GH["GitHub Actions"]
        GH -->|1. Build| Docker[Docker Build]
        GH -->|2. Scan| Trivy[Trivy Vulnerability Scanner]
        GH -->|3. Deploy| Terraform[Terraform Apply]
   ``` end

    Sentinel -- Alert Triggered --> Admin["🚨 Security Analyst (You)"]
    Trivy -- Critical CVE --> Block["❌ Pipeline Blocked"]
🛡️ Security Implementation
1. Supply Chain Security (Trivy)
Every commit triggers a deep vulnerability scan. If a Critical or High CVE is found in the base image or dependencies, the pipeline halts immediately, preventing insecure code from reaching production.

2. Container Hardening
The application runs as a non-root user (secureuser).

Why? If an attacker compromises the application, they are trapped with low privileges and cannot modify system files or escape the container.

3. SIEM & Threat Detection (Microsoft Sentinel)
The platform does not just log errors; it detects intent.

Ingestion: HTTP and Console logs are streamed to a Log Analytics Workspace.

Detection: Custom KQL queries identify suspicious patterns (e.g., high-frequency 401 errors indicating a brute-force attempt).

📸 Operational Evidence
### 1. The Deployment Pipeline
*Infrastructure provisioning and Security Gates in action.*
![GitHub Actions Success] ![Uploading pipeline-success.png.png…]()


### 2. Attack Detection (SIEM)
*Real-time detection of a brute-force simulation against the `/login` endpoint.*
![Azure Sentinel Logs](https://via.placeholder.com/800x400.png?text=Place+Your+Sentinel+Logs+Screenshot+Here)

2. Attack Detection (SIEM)
Real-time detection of a brute-force simulation against the /login endpoint. (Place your screenshot of the Azure Sentinel Logs showing the attack here)
💻 Tech Stack
Component,Technology,Role
Cloud Provider,Microsoft Azure,Hosting & Compute
IaC,Terraform,Infrastructure Provisioning
CI/CD,GitHub Actions,Automation Pipeline
Containerization,Docker,Application Runtime
Security Scanning,Aqua Security Trivy,Static Analysis (SAST)
SIEM,Azure Sentinel,Threat Detection & Response
Language,Python (Flask),Application Logic
<h3 align="center"> Engineered by <a href="https://www.google.com/search?q=https://github.com/raslen-jendoubi">Raslen Jendoubi</a> </h3>
