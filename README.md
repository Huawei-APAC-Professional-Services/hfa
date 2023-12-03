# HFA Reference Architecture Implementation Workshop

HFA is a well-architected, multi-account Huawei Cloud foundation environment upon which you can deploy workloads and applications with confidence in security and infrastructure. It provides a baseline that covers multiple design areas including multi-account architecture, identity and access management, governance, data security, network design, and logging.

HFA follows key design principles across different design areas which accommodate all application portfolios and enable application migration, modernization, and innovation at scale.

## Repository Structure

```mermaid
gitGraph
    commit id: "Document"
    branch dev
    branch localbackend
    branch obsbackend
    branch k8sbackend
```


This is reference implementation of Huaweicloud HFA for workshop purpose, this implementation will initialize the following accounts in HFA:
* Centralized IAM Account
* Common Services Account
* Transit Account
* Security Account
* Production Account(workloads)

:high_brightness: In HFA, the master account also need to be initialized to implement security baseline and delegate some organization responsibilities to other accounts, Due to the accounts limitations of the training workshop environment, this implementation won't do anything to the master account, but budget will be allocated in advance to member accounts.

# HFA Terraform Implementation Introduction
Implementing all HFA elements with Terraform at this stage is not possible because of service limitations. we follow the hierarchy below to implement HFA on Huawei Cloud.

![HFA-Hierarchy](./HFA_Implementation_Hierarchy.png)

By adopting the hierarchy, the complex enterprise environment is isolated into different terraform state files. Different level will use different credential that only can access the corresponding state file and assume designated agency. In principal, Every level in this hierarchy can only write to the state file corresponding to this level but can read the state file one level down and the bottom level state file. But currently we may need to read state file from multiple underlying level due to the incomplete API support from certain services but the principle is that the dependencies on terraform state file are always top-down.

The current HFA implementation hierarchy only contains four level, but it cloud be expanded to more levels to meet customer scenario. And it is also possible that one level contains multiple state file for different purpose, like at application level, we may prefer splitting it into multiple state file by services or application to meet agile development requirements.

But with this approach, the state file still contains credentials and other sensitive information, normally the state file and relevant DevOps tools should be deployed in `Common Services Account` or dedicated `DevOps Account`, but it will make the implementation more complex, so we will store state file in `Centralized IAM Account` to reduce the complexity for the workshop.
 
The reference implementation contains multiple modules that are corresponding to the hierarchy, the following table describe this relationship
|  Module  |  Hierarchy  |
| -------- | ----------- |
| HFA-IAM  |     IAM     |
| HFA-Base |     Base    |
| HFA-Network<br />HFA-Network-workloads | Network  |
| HFA-App  | Application |
| HFA-Integration | Application |

`HFA-Network` and `HFA-Network-worklaods` are using the same credential but will write to different state file to avoid state file corruption. The splitting of network resources is the result of lacking API support from relevant network services. Before we can apply configurations in `HFA-Network-worklaods`, we need to do some manual configurations from console like sharing ER in the `Transit Account` with other member accounts that need a vpc network.

In the future, if the APIs are available, we can merge the two different modules into one.


## Workshop Guidance
If you would like to evaluate the reference HFA implementation, you can to to [workshop](./workshop/) directory for detail guidance.

