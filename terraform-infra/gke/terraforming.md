### Terraforming (setup google cloud infrastructure)
## 1. Install gcloud CLI and init account

```
curl https://sdk.cloud.google.com | bash

gcloud init
```

## 2. Set ENV

```
export SERVICE_ACCOUNT_NAME=*********
export PROJECT_NAME=***********
```

## 3. Create and set project
```
gcloud projects create $PROJECT_NAME

gcloud config set project $PROJECT_NAME
```

> Need to link billing account to project! 

## 4. Create service account and set roles
``` 
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME
```

```
gcloud projects add-iam-policy-binding $PROJECT_NAME --member serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_NAME.iam.gserviceaccount.com --role roles/container.admin

gcloud projects add-iam-policy-binding $PROJECT_NAME --member serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_NAME.iam.gserviceaccount.com --role roles/compute.admin

gcloud projects add-iam-policy-binding $PROJECT_NAME --member serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_NAME.iam.gserviceaccount.com --role roles/iam.serviceAccountUser

gcloud projects add-iam-policy-binding $PROJECT_NAME --member serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_NAME.iam.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin

gcloud projects add-iam-policy-binding $PROJECT_NAME --member serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_NAME.iam.gserviceaccount.com --role roles/dns.admin
```

## 5. Enable services

```
gcloud services enable compute.googleapis.com
gcloud services enable servicenetworking.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable dns.googleapis.com
```
##

## 6. Generate keyfile

```
gcloud iam service-accounts keys create terraform-gke-keyfile.json --iam-account=$SERVICE_ACCOUNT_NAME@$PROJECT_NAME.iam.gserviceaccount.com
```

## 7. Create bucket for terraform remote state 

```
gsutil mb -p $PROJECT_NAME -c regional -l us-east4 gs://virto-k8s-bucket/

gsutil versioning set on gs://virto-k8s-bucket/

gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_NAME.iam.gserviceaccount.com:legacyBucketWriter gs://virto-k8s-bucket/

```

## 8. Terraforming

```
terraform init

terraform fmt .

terrafrom plan

terrafrom apply
```

## 9. Kubeconfig

```
gcloud container clusters list
gcloud container clusters get-credentials virto-cluster --zone us-east4-a
```