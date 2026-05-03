# 🚀 Django Blog Project – Sprint 2 (Docker + AWS Deployment)

## 📌 Overview
This sprint focuses on containerizing the Django application using Docker, running it with a database, and preparing it for deployment on AWS using ECR and EC2.

---

## 🧱 Tech Stack

- Backend: Django (Python 3.12)
- Database: MySQL / RDS
- Containerization: Docker, Docker Compose
- CI/CD: GitHub Actions
- Cloud: AWS (ECR, EC2)
- Environment: Ubuntu

---

## ⚙️ Step 1: Prerequisites

Ensure the following are installed:

```bash
sudo apt update
sudo apt install docker.io docker-compose -y
sudo systemctl start docker
sudo systemctl enable docker
```

---

## ⚙️ Step 2: Clone Repository

```bash
git clone https://github.com/rayyan-rafan/Sprint-1.git
cd Sprint-1
```

---

## ⚙️ Step 3: Configure Environment

Update your `.env` or `settings.py` with database credentials.

---

## ⚙️ Step 4: Docker Setup

Ensure you have:

- Dockerfile
- docker-compose.yml

---

## 🐳 Step 5: Build and Run Docker Container

### 🔧 Setup Docker Buildx (Multi-Architecture)

```bash
export LATEST_BUILDX=$(curl -s https://api.github.com/repos/docker/buildx/releases/latest | grep 'tag_name' | cut -d\" -f4)
ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
    DOWNLOAD_ARCH="amd64"
elif [ "$ARCH" = "aarch64" ]; then
    DOWNLOAD_ARCH="arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/buildx/releases/download/"${LATEST_BUILDX}"/buildx-"${LATEST_BUILDX}".linux-"${DOWNLOAD_ARCH}" -o ~/.docker/cli-plugins/docker-buildx
chmod +x ~/.docker/cli-plugins/docker-buildx
```

Restart Docker:

```bash
sudo systemctl restart docker
```

Initialize buildx:

```bash
docker buildx create --use
```

---

### 🏗 Build Docker Images

```bash
sudo docker buildx build --platform linux/amd64 -t blog_project-web:latest-amd64 --load .
sudo docker buildx build --platform linux/arm64 -t blog_project-web:latest-arm64 --load .
```

---

### 🚀 Run Docker Container

Make sure your database/RDS is running:

```bash
sudo docker compose up
```

Visit:
```
http://localhost:8000
```

---

### 🧪 Verify Database Connection

#### Option 1: Django Shell
```bash
docker compose run web python manage.py shell
```

```python
from django.db import connection
connection.ensure_connection()
print("Connection successful")
```

---

#### Option 2: SQL Check
```python
from django.db import connection
with connection.cursor() as cursor:
    cursor.execute("SELECT 1")
    print(cursor.fetchone())
```

---

#### Option 3: Admin Panel

```
http://localhost:8000/admin/
```

---

### 🛠 Useful Commands

```bash
docker buildx ls
sudo docker ps -a
docker container prune --force
docker compose up --remove-orphans
```

---

## 📸 Screenshots

1. Docker containers running:

![Docker containers running](images/docker-containers-running.png)

2. Django app homepage:

![Django app homepage](images/django-homepage.png)

3. Database connection successful:

![Database connection](images/database-connection.png)

---

## ⚙️ Step 6: Prepare for EC2 Deployment

### IAM Permission Setup

1. Go to AWS IAM Console  
2. Select Users → Your User  
3. Go to Permissions tab  
4. Click "Add permissions"  
5. Attach policy: `AmazonEC2ContainerRegistryReadOnly`  

---

### Create ECR Repository

```bash
aws ecr create-repository --repository-name blog_project-web --region us-east-1
```

---

### Authenticate Docker to ECR

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.us-east-1.amazonaws.com
```

---

### Tag Docker Image

```bash
docker tag blog_project-web:latest-amd64 $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.us-east-1.amazonaws.com/blog_project-web:latest-amd64
```

---

### Push Image to ECR

```bash
docker push $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.us-east-1.amazonaws.com/blog_project-web:latest-amd64
```

---

### Verify Upload

```bash
aws ecr describe-images --repository-name blog_project-web --region us-east-1
```

---

### Useful Cleanup Commands

```bash
docker images
docker container prune -f
```

---

## ✅ Sprint 2 Checklist

- Docker container built successfully  
- Application running via Docker  
- Database connected  
- Images pushed to ECR  
- Ready for EC2 deployment  




## ⭐ Notes

- Ensure Docker is running before executing commands  
- Ensure database is accessible from container  
- Use environment variables for secrets  
