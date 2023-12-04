# Huawei Foundation Architecture Terraform Implementation Reference

> [!IMPORTANT]
> A real HFA is much more complicated than this, You need to talk to your customer to understand their specific business requirements and technology constraints to design the actual HFA for them.  

## Introduction
This implementation relies on OBS bucket as the backend storage for Terraform, Terraform currenlty needs to rely on S3 backend plugin to communicate with S3-Compatible object storage and does not accept new backend contribution. The drawback of this solution is that state-locking is not possible with OBS, if you need state-locking feature of Terraform, you need to use other backend. 

## Prerequisite

You need to have the following software installed on your laptop     
* Visual Studio Code
* Terraform (For the workshop hosted by Huawei Cloud Professional Service, a Linux environment with Terraform installed will be provided)

## Connect to Terraform Execution Environment
All the steps should be executed on remote server if you participates a workshop hosted by Huawei Cloud Professional service team, Please setup your local environment by following the setup guide.

[VS Code Setup](./vscode_remote_server.md)

## Building HFA with Terraform

### Create OBS bucket in Central IAM Account
1. Log in to `Central IAM Account` 
2. Select `Object Storage Service` from `Service List` on the left side of Huawei Cloud console. 
![Create Obs Bucket](./images/obsbackend/001_Create_obs_bucket_01.png)
3. Select `Create Bucket` on the upper right corner of the console
![Create OBS Bucket](./images/obsbackend/001_Create_obs_bucket_02.png)
4. Provide the following necessary parameters to create the bucket
* `Region`: `AP-Singapore`
* `Bucket Name`: Choose any name as you like
* `Data Redundancy Policy`: `Multi-AZ storage`
* `Default Storage Class`: `Standard`
* `Bucket Policies`: `Private`
* `Server-Side Encryption`: `SSE-KMS`
* `Encryption Key Type`: `Default`

![Create OBS Bucket](./images/obsbackend/001_Create_obs_bucket_03.png)

### Create IAM User in Central IAM Account
1. Log in to `Central IAM Account` with provided root credential 
2. On Huawei Cloud console, select `Service List` on the left side pannel and search `iam`, select `Identity and Access Management` service.  
![Using IAM](./images/100-level/002-create-terraform-user-01.png)

3. On `IAM` service page, select `Permissions` -> `Policies/Roles` on the left side pannel and Click `Create Custom Policy` to create `hfa_terraform_kms` policy with following policy statement.
```
{
    "Version": "1.1",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kms:dek:encrypt",
                "kms:cmk:getMaterial",
                "kms:cmk:create",
                "kms:grant:retire",
                "kms:cmk:getRotation",
                "kms:cmkTag:create",
                "kms:cmk:decrypt",
                "kms:partition:create",
                "kms:cmk:update",
                "kms:cmk:get",
                "kms:dek:create",
                "kms:partition:list",
                "kms:partition:get",
                "kms:grant:revoke",
                "kms:cmk:encrypt",
                "kms:cmk:getQuota",
                "kms:cmk:list",
                "kms:cmk:getInstance",
                "kms:cmk:generate",
                "kms:cmk:verify",
                "kms:cmk:crypto",
                "kms:cmk:sign",
                "kms:dek:crypto",
                "kms:dek:decrypt",
                "kms:grant:create",
                "kms:grant:list",
                "kms:cmk:deleteMaterial",
                "kms:cmk:getPublicKey",
                "kms:cmkTag:list",
                "kms:cmk:enable"
            ]
        }
    ]
}
```
![Create IAM Policy](./images/obsbackend/002_Create_iam_policy_01.png)
![Create IAM Policy](./images/obsbackend/002_Create_iam_policy_02.png)

4. On `IAM` service page, select `Permissions` -> `Policies/Roles` on the left side pannel and Click `Create Custom Policy` to create `hfa_terraform_obs` policy with following policy statement. you need to change `BucketName` according to your environment.
```
{
    "Statement": [
        {
            "Action": [
                "iam:agencies:*",
                "iam:tokens:assume",
                "iam:groups:*",
                "iam:credentials:*",
                "iam:identityProviders:*",
                "iam:mfa:*",
                "iam:permissions:*",
                "iam:projects:*",
                "iam:quotas:*",
                "iam:roles:*",
                "iam:policies:*",
                "iam:users:*",
                "iam:securitypolicies:*"
            ],
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "obs:object:GetObject",
                "obs:object:DeleteObject",
                "obs:object:PutObject",
                "obs:object:ModifyObjectMetaData",
                "obs:object:GetObjectVersion"
            ],
            "Resource": [
                // Change the BucketName to the one you created in previous step
                "OBS:*:*:object:BucketName/*"
            ]
        },
        {
            "Action": [
                "obs:bucket:HeadBucket",
                "obs:bucket:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                // Change the BucketName to the one you created in previous step
                "OBS:*:*:bucket:BucketName"
            ]
        }
    ],
    "Version": "1.1"
}
```
5. On `IAM` service page, select `User Groups` on the left side pannel and Click `Create User Group` to create `hfa_terraform` user group.
![Create Group](./images/100-level/003-create-terraform-group-01.png)

![Create Group](./images/100-level/003-create-terraform-group-02.png)

6. Select `hfa_terraform` user group and Click `Authorize` to assign `Security Administrator`,`hfa_terraform_kms` and `hfa_terraform_obs` roles to the group

7. On `IAM` service page, select `Users` on the left side pannel and Click `Create User` to create `hfa_terraform` user. This user belongs to `hfa_terraform` user group
![Create User](./images/100-level/002-create-terraform-user-02.png)
![Create User](./images/100-level/002-create-terraform-user-03.png)
![Create User](./images/100-level/002-create-terraform-user-04.png)
![Create User](./images/100-level/002-create-terraform-user-05.png)

> [!IMPORTANT]
> Downloaded credentials should be safely kept

### Clone HFA workshop repository

1. Clone the repository with following command
```
git clone https://github.com/Huawei-APAC-Professional-Services/hfa.git
```
![Clone Repo](./images/100-level/001-clone-repo-01.png)

2.  checkout the `obsbackend` branch and check you are working on `obsbackend` branch with the following command
```
cd hfa
git checkout -b obsbackend remotes/origin/obsbackend
git branch -a
```
![Clone Repo](./images/obsbackend/003_git_clone_01.png)

3. In VS Code, Select `File` icon on the upper left corner
![Open Folder](./images/100-level/001-clone-repo-02.png)

4. Select `Open Folder` and select the repo directory `hfa`
![Open Folder](./images/100-level/001-clone-repo-03.png)

### Provisioning IAM Resources

1. Open the `HFA-IAM/terraform.tfvars` file in VS Code and change the value according to your environment.

2. Get the AK/SK from [Create IAM User in Central IAM Account](#create-iam-user-in-central-iam-account) and Set the environment variables with the following command
```
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="ap-southeast-3"
export HW_ACCESS_KEY="anaccesskey"
export HW_SECRET_KEY="asecretkey"
export HW_REGION_NAME="ap-southeast-3"
```  

3. Open `HFA-IAM/obs.tfbackend` in  VS Code and change the `bucket` parameter to the one you created in [Create OBS bucket in Central IAM Account](#create-obs-bucket-in-central-iam-account)
![Change backend config](./images/obsbackend/004_apply_hfa_iam_01.png)

4. Open `HFA-IAM/terraform.tfvars` in VS Code and change the `hfa_terraform_state_bucket` parameter to the one you created in [Create OBS bucket in Central IAM Account](#create-obs-bucket-in-central-iam-account)
![Change backend config](./images/obsbackend/004_apply_hfa_iam_02.png)

5. Execute the following commands to init and validate the configurations
```
terraform -chdir=HFA-IAM/ init
terraform -chdir=HFA-IAM/ validate
```

6. Execute the following commands to apply the terraform configuration
```
terraform -chdir=HFA-IAM/ apply
```

### Provisioning HFA Base Resources

1. Make sure you are in `hfa` directory in the terminal
```
pwd
```
2. Get the AK/SK from [Create IAM User in Central IAM Account](#create-iam-user-in-central-iam-account) and Set the environment variables with the following command
```
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="ap-southeast-3"
```  
3. Get the AK/SK for `IAM-Base` level with the following commands
```
terraform -chdir=HFA-IAM/ output hfa_iam_pipeline_base_ak
terraform -chdir=HFA-IAM/ output hfa_iam_pipeline_base_sk
```

4. Setup environment variables for accessing OBS with AK/SK from last step
```
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="ap-southeast-3"
export HW_ACCESS_KEY="anaccesskey"
export HW_SECRET_KEY="asecretkey"
export HW_REGION_NAME="ap-southeast-3"
```

5. Open `HFA-Base/s3-backend.tf` in  VS Code and change the `bucket` parameter to the one you created in [Create OBS bucket in Central IAM Account](#create-obs-bucket-in-central-iam-account)
![Change backend config](./images/obsbackend/005_apply_hfa_base_01.png)

6. Execute the following command to format and validate the `HFA-Base` configuration, if there is any errors raised, you need to solve the error to continue the workshop
```
terraform -chdir=HFA-Base/ init
terraform -chdir=HFA-Base/ validate
```
7. Execute the following command to apply the `HFA-Base` configuration, when you are prompted to provide confirmation, type `yes`
```
terraform -chdir=HFA-Base/ apply
```

### Provisioning HFA Network Resources
1. Make sure you are in `hfa` directory in the terminal
```
pwd
```
2. Get the AK/SK from [Create IAM User in Central IAM Account](#create-iam-user-in-central-iam-account) and Set the environment variables with the following command
```
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="ap-southeast-3"
```  
3. Get the AK/SK for `IAM-Network` level with the following commands
```
terraform -chdir=HFA-IAM/ output hfa_iam_pipeline_network_ak
terraform -chdir=HFA-IAM/ output hfa_iam_pipeline_network_sk
```

4. Get the `Application Account` and `Common Account` id with the following commands
```
terraform -chdir=HFA-IAM/ output hfa_app_account_id
terraform -chdir=HFA-IAM/ output hfa_common_account_id
```

5. Setup environment variables for accessing OBS with AK/SK from step 3.
```
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="ap-southeast-3"
export HW_ACCESS_KEY="anaccesskey"
export HW_SECRET_KEY="asecretkey"
export HW_REGION_NAME="ap-southeast-3"
```

6. Open `HFA-Base/s3-backend.tf` in  VS Code and change the `bucket` parameter to the one you created in [Create OBS bucket in Central IAM Account](#create-obs-bucket-in-central-iam-account)
![Change backend config](./images/obsbackend/006_apply_hfa_network_01.png)

7. Execute the following command to format and validate the `HFA-Base` configuration, if there is any errors raised, you need to solve the error to continue the workshop
```
terraform -chdir=HFA-Network/ init
terraform -chdir=HFA-Network/ validate
```
8. Execute the following command to apply the `HFA-Network` configuration, when you are prompted to provide confirmation, type `yes`
```
terraform -chdir=HFA-Network/ apply
```
9. Log in to `Transit Account` and Search `Enterprise Router` service through `Service List` on the left side pannel
![ER Sharing](./images/100-level/006-hfa-Network-apply-01.png)

10. On the ER service page, Click `Manage Sharing`
![ER Sharing](./images/100-level/007-hfa-Network-ER-01.png)

11. Sharing the ER with `Application Account` and `Common Account` through the account ID you get in step 4.
![ER Sharing](./images/100-level/007-hfa-Network-ER-02.png)

12. Open `HFA-Base/s3-backend.tf` in  VS Code and change the `bucket` parameter to the one you created in [Create OBS bucket in Central IAM Account](#create-obs-bucket-in-central-iam-account)

13. Execute the following command to format and validate the `HFA-Network-workloads` configuration, if there is any errors raised, you need to solve the error to continue the workshop
```
terraform -chdir=HFA-Network-workloads/ init
terraform -chdir=HFA-Network-workloads/ validate
```
14. Execute the following command to apply the `HFA-Network-workloads` configuration, when you are prompted to provide confirmation, type `yes`
```
terraform -chdir=HFA-Network-workloads/ apply
```

### Provisioning HFA Application Resources in Application Account
1. Make sure you are in `hfa` directory in the terminal
```
pwd
```
2. Get the AK/SK from [Create IAM User in Central IAM Account](#create-iam-user-in-central-iam-account) and Set the environment variables with the following command
```
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="ap-southeast-3"
```  
3. Get the AK/SK for `IAM-App` level with the following commands
```
terraform -chdir=HFA-IAM/ output hfa_iam_pipeline_app_ak
terraform -chdir=HFA-IAM/ output hfa_iam_pipeline_app_sk
```
4. Setup environment variables for accessing OBS with AK/SK from step 3.
```
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="ap-southeast-3"
export HW_ACCESS_KEY="anaccesskey"
export HW_SECRET_KEY="asecretkey"
export HW_REGION_NAME="ap-southeast-3"
```

5. Open `HFA-Base/s3-backend.tf` in  VS Code and change the `bucket` parameter to the one you created in [Create OBS bucket in Central IAM Account](#create-obs-bucket-in-central-iam-account)

6. Execute the following command to format and validate the `HFA-App` configuration, if there is any errors raised, you need to solve the error to continue the workshop
```
terraform -chdir=HFA-App/ init
terraform -chdir=HFA-App/ validate
```
8. Execute the following command to apply the `HFA-App` configuration, when you are prompted to provide confirmation, type `yes`
```
terraform -chdir=HFA-App/ apply
```

### Integrating Application with HFA in Application Account
1. Make sure you are in `hfa` directory in the terminal
```
pwd
```
2. Get the AK/SK from [Create IAM User in Central IAM Account](#create-iam-user-in-central-iam-account) and Set the environment variables with the following command
```
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="ap-southeast-3"
```  
3. Get the AK/SK for `HFA-Integration` level with the following commands
```
terraform -chdir=HFA-IAM/ output hfa_iam_pipeline_integration_ak
terraform -chdir=HFA-IAM/ output hfa_iam_pipeline_integration_sk
```
4. Setup environment variables for accessing OBS with AK/SK from step 3.
```
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="ap-southeast-3"
export HW_ACCESS_KEY="anaccesskey"
export HW_SECRET_KEY="asecretkey"
export HW_REGION_NAME="ap-southeast-3"
```

5. Open `HFA-Base/s3-backend.tf` in  VS Code and change the `bucket` parameter to the one you created in [Create OBS bucket in Central IAM Account](#create-obs-bucket-in-central-iam-account)

6. Execute the following command to format and validate the `HFA-Integration` configuration, if there is any errors raised, you need to solve the error to continue the workshop
```
terraform -chdir=HFA-Integration/ init
terraform -chdir=HFA-Integration/ validate
```
8. Execute the following command to apply the `HFA-Integration` configuration, when you are prompted to provide confirmation, type `yes`
```
terraform -chdir=HFA-Integration/ apply
```