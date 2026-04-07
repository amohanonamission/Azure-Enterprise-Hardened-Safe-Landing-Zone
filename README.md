Azure Enterprise Landing Zone (PaC)
Technologies: Bicep, Azure Resource Manager, Infrastructure as Code (IaC)

Overview
This repository contains the Policy-as-Code (PaC) definitions for a secure Azure Landing Zone. It follows the Microsoft Cloud Adoption Framework (CAF) principles by ensuring every resource is tagged for cost-governance and configured with mandatory security baselines.

Security Features
Public Access Block: Storage accounts are deployed with allowBlobPublicAccess: false.

Encryption in Transit: Enforces TLS 1.2 and HTTPS-only traffic.
