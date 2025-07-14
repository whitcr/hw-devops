
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
