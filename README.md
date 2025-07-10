## Опис

- VPC — мережа з підмережами
- EKS — кластер Kubernetes
- ECR — репозиторій для Docker-образу
- Helm-чарт для деплою Django
- S3 + DynamoDB — зберігання стейту Terraform

### Команди

```bash
terraform init
terraform apply

```bash
docker build -t django-app .
docker tag django-app:latest <repo-url>
docker push <repo-url>
```
