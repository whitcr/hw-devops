
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
