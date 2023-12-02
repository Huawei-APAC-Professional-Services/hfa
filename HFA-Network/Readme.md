# Introduction
`HFA-Network` will create network related resources across member across necessary member account, There won't be any workloads being deployed into master account and Central IAM account, so 

# ER Sharing
1. Login into `HFA_App` account
2. On the upper right corner of the console, click the account name and then click `My Credential` on the drop-down menu
[my Credential](./images/000_MyCredential.png)
3. Write down the account ID in the new page for future use
[accountID](./images/001_getAccountID.png)
4. Find all the member accounts id following the same process and write it down for future use
5. Login into `HFA_Transit` account and select `Enterprise Router` service
6. Select the ER created by terraform and clict `Manage Sharing` button on the console
[select and manage ER](./images/003_SelectER.png)
7. Click `Share Enterprise Router` on the new page
[Share Enterprise Router](./images/006_ShareERButton.png)
4. On the pop-up page, provide a meaningful name as `Sharing Name` and fill the filed of `Resource User Account ID` with the account id you get in the previous steps and click `OK`
[SharingERParams](./images/009_ShareERParams.png) 
5. Follow the last step to share the ER with Common Account and Security Account
6. Login into the account with wihch you have shared ER to check if ER has been shared successfully, you should find the ER in your member account under ER service
[sharedER](./images/012_SharedER.png)

# Adding Route
for
# Resources
| Name | Type |
| ----- | ----- |
| huaweicloud_er_instance | resource |
| ../modules/vpc  | module |