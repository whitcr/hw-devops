# Структура проекту 

Progect/
│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB
├── outputs.tf               # Загальні виводи ресурсів
│
├── modules/                 # Каталог з усіма модулями
│   ├── s3-backend/          # Модуль для S3 та DynamoDB
│   │   ├── s3.tf            # Створення S3-бакета
│   │   ├── dynamodb.tf      # Створення DynamoDB
│   │   ├── variables.tf     # Змінні для S3
│   │   └── outputs.tf       # Виведення інформації про S3 та DynamoDB
│   │
│   ├── vpc/                 # Модуль для VPC
│   │   ├── vpc.tf           # Створення VPC, підмереж, Internet Gateway
│   │   ├── routes.tf        # Налаштування маршрутизації
│   │   ├── variables.tf     # Змінні для VPC
│   │   └── outputs.tf  
│   ├── ecr/                 # Модуль для ECR
│   │   ├── ecr.tf           # Створення ECR репозиторію
│   │   ├── variables.tf     # Змінні для ECR
│   │   └── outputs.tf       # Виведення URL репозиторію
│   │
│   ├── eks/                      # Модуль для Kubernetes кластера
│   │   ├── eks.tf                # Створення кластера
│   │   ├── aws_ebs_csi_driver.tf # Встановлення плагіну csi drive
│   │   ├── variables.tf     # Змінні для EKS
│   │   └── outputs.tf       # Виведення інформації про кластер
│   │
│   ├── rds/                 # Модуль для RDS
│   │   ├── rds.tf           # Створення RDS бази даних  
│   │   ├── aurora.tf        # Створення aurora кластера бази даних  
│   │   ├── shared.tf        # Спільні ресурси  
│   │   ├── variables.tf     # Змінні (ресурси, креденшели, values)
│   │   └── outputs.tf  
│   │ 
│   ├── jenkins/             # Модуль для Helm-установки Jenkins
│   │   ├── jenkins.tf       # Helm release для Jenkins
│   │   ├── variables.tf     # Змінні (ресурси, креденшели, values)
│   │   ├── providers.tf     # Оголошення провайдерів
│   │   ├── values.yaml      # Конфігурація jenkins
│   │   └── outputs.tf       # Виводи (URL, пароль адміністратора)
│   │ 
│   └── argo_cd/             # Mодуль для Helm-установки Argo CD
│       ├── argo_cd.tf       # Helm release для Argo CD
│       ├── variables.tf     # Змінні (версія чарта, namespace, repo URL тощо)
│       ├── providers.tf     # Kubernetes+Helm.  переносимо з модуля jenkins
│       ├── values.yaml      # Кастомна конфігурація Argo CD
│       ├── outputs.tf       # Виводи (hostname, initial admin password)
│		    └──charts/                  # Helm-чарт для створення app'ів
│ 	 	    ├── Chart.yaml
│	  	    ├── values.yaml          # Список applications, repositories
│			    └── templates/
│		        ├── application.yaml
│		        └── repository.yaml
├── charts/
│   └── django-app/
│       ├── templates/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── configmap.yaml
│       │   └── hpa.yaml
│       ├── Chart.yaml
│       └── values.yaml     # ConfigMap зі змінними середовища





# Команди:

terraform init

terraform plan

terraform apply

terraform destroy

# Модулі :

s3-backend -  модуль для зберігання стан інфраструктури в AWS S3
vpc - створення приватних та публічних підмереж, шлюза та роутінг таблиця
ecr - репозиторій для контейнерів

1. Збірка та завантаження 

Аунтетіфікація Docker в ECR:
aws ecr get-login-password --region <your-region> | docker login --username AWS --password-stdin <your-account-id>.dkr.ecr.<your-region>.amazonaws.com

Створення Docker image:
docker build -t django-app .

Додавання тега до image:
docker tag django-app:latest <your-account-id>.dkr.ecr.<your-region>.amazonaws.com/lesson-5-ecr-nat:latest

Завантаження image в ECR:
docker push <your-account-id>.dkr.ecr.<your-region>.amazonaws.com/lesson-5-ecr-nat:latest

2. Конфігурація kubectl

Оновлення kubeconfig в EKS кластері:
aws eks --region <your-region> update-kubeconfig --name <your-cluster-name>

Перевірка доступу к кластеру:
kubectl get nodes

3. Deploy Django App за допомогою Helm

Перейти в Helm chart directory:
cd charts/django-app

Обновити values.yaml, додати ECR image repository та tag.

Зробити інстоляцію chart:

helm install nat .

Отримати external URL:
kubectl get svc

Відкрити Django app за допомогую броузера:
http://<external-dns>

# CI/CD для Django з Terraform + Jenkins + Argo CD

##  Як застосувати Terraform

```bash
terraform init
````

```bash
terraform apply
```

* кластер EKS;
* Jenkins і Argo CD через Helm;
* репозиторій ECR;
* VPC, S3, DynamoDB.

---

##  Як перевірити Jenkins job

1. Відкрий Jenkins у браузері:

```
http://<EXTERNAL-IP-JENKINS>:8080
```

2. Увійти з логіном/паролем (виводиться в `terraform apply` або з `kubectl`).

3. Відкрити job (pipeline), натисни “Build Now”.

4. Переконатися, що:

   * Docker-образ зібрався;
   * пуш у ECR пройшов успішно;
   * файл `values.yaml` оновлено з новим тегом;
   * зміни запушено у Git.

---

## Як побачити результат в Argo CD

1. Відкрити Argo CD:

```
http://<EXTERNAL-IP-ARGO-CD>
```

2. Увійти:

   * логін: `admin`
   * пароль: перший раз — отримай через:

```bash
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
```

3. Відкрити своє застосування в списку.
4. Натиснути “Sync” або переконатися, що статус `Synced` та `Healthy`.

---
##  RDS Module

Звичайна RDS інстанція (PostgreSQL, MySQL тощо)

Aurora Cluster (PostgreSQL-compatible, MySQL-compatible)

Автоматичне створення:

 * DB Subnet Group

 * Security Group

 * Parameter Group
 
 Змінні для створення БД:

 | Назва                           | Тип         | Обовязкова    | Опис                                                             |
| ------------------------------- | ----------- | -------------- | ---------------------------------------------------------------- |
| `name`                          | string      | ✅              | Ідентифікатор інстансу або кластера                       |
| `use_aurora`                    | bool        | ✅              | Якщо `true`, створюється Aurora Cluster                          |
| `engine`                        | string      | ✅              | Тип БД: `postgres`, `mysql`, `aurora-postgresql`, `aurora-mysql` |
| `engine_version`                | string      | ✅              | Версія СУБД                                  |
| `instance_class`                | string      | ✅              | Клас EC2 інстансу               |
| `allocated_storage`             | number      | ❌              | Розмір диску                         |
| `aurora_instance_count`         | number      | ❌              | Кількість інстансів у кластері Aurora                            |
| `db_name`                       | string      | ✅              | Назва БД             |
| `username`                      | string      | ✅              | Імя користувача для доступу                                     |
| `password`                      | string      | ✅              | Пароль користувача                                               |
| `multi_az`                      | bool        | ❌              | Якщо `true`, створюється Multi-AZ RDS                            |
| `publicly_accessible`           | bool        | ❌              | Якщо `true`, інстанс буде доступний публічно                     |
| `backup_retention_period`       | number      | ❌              | Кількість днів збереження бекапів                                |
| `parameter_group_family_rds`    | string      | ✅ (для RDS)    | Наприклад, `postgres`                                          |
| `parameter_group_family_aurora` | string      | ✅ (для Aurora) | Наприклад, `aurora-postgresql`                                 |
| `parameters`                    | map(string) | ❌              | Додаткові параметри БД                                           |
| `tags`                          | map(string) | ❌              | Теги ресурсу                                                     |

Як змінити тип БД, engine, клас інстансу


| Що змінити                    | Як                                                  |
| ----------------------------- | --------------------------------------------------- |
| Звичайна RDS ↔ Aurora      | Змінити `use_aurora` на `true/false`                |
| Engine (PostgreSQL, MySQL) | Змінити `engine` та `engine_version`                |
| Клас інстансу              | Змінити `instance_class` (наприклад, `db.t3.micro`) |
| Назву бази                 | Оновити `db_name`                                   |


# Встановлення Prometheus & Grafana:
   * kubectl create namespace monitoring
   * helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   * helm repo update
   * helm install prometheus prometheus-community/prometheus --namespace monitoring

   * helm repo add grafana <https://grafana.github.io/helm-charts>
   * helm repo update


   * helm install grafana grafana/grafana --namespace monitoring --set adminPassword=admin123
   * kubectl port-forward -n monitoring svc/grafana 3000:80
