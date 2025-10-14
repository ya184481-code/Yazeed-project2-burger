# Burger Builder Azure 3-Tier Reference

## المتطلبات
- Azure CLI
- Docker
- Terraform
- Node.js, npm, Maven
- صلاحيات Azure (Contributor)

## البنية
- VNet مع 4 subnets (AppGW, FE, BE, DB)
- App Gateway (WAF v2) هو نقطة الدخول الوحيدة
- Web Apps (frontend/backend) بدون public access
- Azure SQL مع Private Endpoint فقط

## خطوات التشغيل

### 1. تجهيز البنية التحتية
```sh
cd terraform
terraform init
terraform plan
terraform apply
```

### 2. بناء ودفع الصور
```sh
cd backend && docker build -t <user>/yazeed-burger-backend:latest . && docker push <user>/yazeed-burger-backend:latest
cd frontend && docker build -t <user>/yazeed-burger-frontend:latest . && docker push <user>/yazeed-burger-frontend:latest
```

### 3. النشر التلقائي (CI/CD)
- يتم تلقائيًا عبر GitHub Actions عند كل push على main.
- ملفات workflow في `.github/workflows/` (infra.yml, backend.yml, frontend.yml)

### 4. اختبار التطبيق
- افتح http://[AppGW_IP] وتأكد من عمل الصفحة الرئيسية.
- جرب API عبر Postman أو curl.

## Architecture Diagram
- أضف صورة توضح البنية في docs/architecture-diagram.png

## Runbook
- خطوات استكشاف الأخطاء، إعادة النشر، مراقبة الصحة، إلخ.

## ملاحظات
- يجب إضافة secrets (Azure, Docker) في إعدادات GitHub repo.
- عدّل أسماء التطبيقات والصور حسب بيئتك.
