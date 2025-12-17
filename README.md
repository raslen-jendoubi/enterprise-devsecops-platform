# 🛡️ Enterprise DevSecOps Platform & SOC Automation

![Build Status](https://img.shields.io/github/actions/workflow/status/raslen-jendoubi/enterprise-devsecops-platform/deploy.yml)
![Security](https://img.shields.io/badge/Security-Trivy%20%2B%20Sentinel-red)
![Infrastructure](https://img.shields.io/badge/IaC-Terraform-purple)
![Cloud](https://img.shields.io/badge/Azure-Production-blue)

---

## 📖 Executive Summary

This project implements an **enterprise-grade, secure-by-design DevSecOps platform** on Microsoft Azure.  
Unlike standard cloud deployments, this platform integrates **Security Operations Center (SOC)** capabilities, enabling **real-time detection, monitoring, and incident response**.

The objective is to demonstrate not only infrastructure deployment, but also **security enforcement, observability, and defensive readiness** against real-world attack scenarios.

---

## 🎯 Key Capabilities

- **Infrastructure as Code (IaC):**  
  Fully automated Azure provisioning using Terraform (no manual portal configuration).

- **Secure Software Supply Chain:**  
  Trivy vulnerability scanning blocks deployments containing HIGH or CRITICAL CVEs.

- **Container Hardening:**  
  Applications run as non-root users, enforcing least-privilege execution.

- **SOC & Incident Response:**  
  Centralized log ingestion and detection using **Microsoft Sentinel (SIEM)**.

---

## 🏗️ Architecture Overview

```mermaid
graph TD
    User["🌍 Public User"] -->|HTTPS| WebApp["Azure Web App (Secure Container)"]
    Attacker["👾 Attacker"] -->|Brute Force| WebApp

    subgraph Azure_Cloud ["Azure Secure Cloud"]
        WebApp -->|Logs & Metrics| LAW["📝 Log Analytics Workspace"]
        LAW -->|Ingestion| Sentinel["🛡️ Azure Sentinel (SIEM)"]
        ACR["📦 Azure Container Registry"] -->|Pull Image| WebApp
    end

    subgraph CI_CD ["GitHub DevSecOps Pipeline"]
        Dev["👨‍💻 Developer"] -->|Push Code| GH["GitHub Actions"]
        GH -->|1. Build| Docker["🐳 Docker Build"]
        GH -->|2. Scan| Trivy["🔍 Trivy Scan"]
        GH -->|3. Deploy| Terraform["🌍 Terraform Apply"]
    end

    Sentinel -->|Alert Triggered| Analyst["🚨 Security Analyst"]
    Trivy -->|Critical CVE| Block["❌ Pipeline Blocked"]
