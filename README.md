# 🖼️ Image Processor — Serverless IaC (Terraform + AWS)

Infraestructura como código para un procesador de imágenes serverless en AWS, desplegado con Terraform.

## 🏗️ Arquitectura

```
Client → API Gateway HTTP v2 → Upload Lambda → S3 (uploads/)
                                                   ↓
                                              S3 Notification
                                                   ↓
                                              SQS Queue → Crop Lambda → S3 (processed/)
                                                   ↓ (fallos)
                                              DLQ → CloudWatch Alarm → SNS
```

## 🖼️ Imágenes de Ejemplo

Se ha incluido una imagen de ejemplo en la carpeta `assets/` para probar el flujo de procesamiento:

![The Starry Night](assets/starry_night.png)

*Nota: Esta imagen puede ser utilizada para probar la subida vía API Gateway y el posterior recorte circular por la Lambda de Crop.*

## 📁 Estructura del Proyecto

```
├── environments/
│   ├── dev/          # Entorno de desarrollo
│   ├── qa/           # Entorno de QA/testing
│   └── prod/         # Entorno de producción
├── modules/
│   ├── api_gateway/  # API Gateway HTTP v2
│   ├── compute/      # Lambda Functions (upload + crop)
│   ├── messaging/    # SQS Queues + S3 Notifications
│   ├── networking/   # VPC, Subnets, VPC Endpoints
│   ├── observability/# CloudWatch Logs, Alarms, SNS
│   ├── security/     # IAM Roles, Policies, Security Groups
│   └── storage/      # S3 Bucket con encryption + lifecycle
└── src/
    ├── crop-lambda/  # Node.js 20.x — Procesamiento de imágenes (sharp)
    └── upload-lambda/# Node.js 20.x — Upload multipart a S3
```

## 🚀 Despliegue

```bash
# 1. Ir al entorno deseado
cd environments/dev

# 2. Inicializar Terraform
terraform init

# 3. Revisar el plan
terraform plan

# 4. Aplicar
terraform apply
```

## 🔧 Configuración por Entorno

| Variable | Dev | QA | Prod |
|----------|-----|-----|------|
| `lambda_memory_crop` | 256 MB | 512 MB | 1024 MB |
| `log_retention_days` | 3 días | 7 días | 14 días |
| CORS origins | `*` | `*` | Configurable |

## 📋 Requisitos

- Terraform >= 1.5.0
- AWS Provider ~> 5.0
- Node.js 20.x (para desarrollo de Lambdas)
- AWS CLI configurado con credenciales válidas