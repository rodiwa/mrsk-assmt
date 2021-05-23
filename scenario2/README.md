# Scenario 2

1) What are different artifacts you need to create - name of the artifacts and its purpose
- Here we can create an artifact for terraform files only (since no application code has been mentioned). When you are creating a build pipeline, and your code is on a github/ azure repo, there is an option to copy files from repo directly to artifact path.
- Generally artifacts are needed if you're trying to share data from one job, task, pipeline to another (think of it as a moving data to a shared folder which can be accessed by other entites).
- Usually you have an artifact created if you're creating an application build (dotnet gives you ZIP, node gives you `./build` folder, etc).

2) List the tools you will to create and store the Terraform templates.
- To Create
  - IMO, best to start from an existing template (online/ community/ existing project), and then update it as per your own requirement, instead of starting from scratch. Some scaffolding tools are available (for ex, Yeoman).
- To Store
  - Recommended way is to save it alongside your `src` code in your repo, maybe in a folder named `infra`.
  - Or if its a common architecture you want to enforce on other teams in your organization, you can store terraform templates/ modules of specific instances in its own repo and other projects can include it in their project.
  - Another option can be to store all your terraform template files in storage account and secure it using RBAC.
3) Explain the process and steps to create automated deployment pipeline.
- High level overview (using terraform and azure piplelines (AP))
  - Start small, start locally at first. Test and push your code to repo.
  - Create `infra` folder in your repo and create 3 new files `main.tf`, `paramters.tf`, `variables.tf`
    - Or depending on project structure, you can create 1 folder each for your environments (`dev`, `stage`, `prod`) and start building from there.
    There are many ways to create your folder structure for infra.
  - Write complete code for your infra and commit this to your repo (see actual code sample in next question)
  - Create a storage account to store your tfstate (you can do this step using code also, but just to keep it simple for now, lets assume we make storage account using az portal).
  - create service principal so terraform can talk to az services.
  - you get some values (client id, secret id, tenant id, subsrciption id) when you create service principal. Save these to your azure keyvault as secrets.
  - goto AP > new release pipeline > create new a project. goto edit pipeline.
  - inside AP > project > release pipeline, where you're editing, add a step to fetch the keys from vault and store them in you pipeline variables. Best to create a variable group so all your values can be passed into code together under the variable group name.
  - make sure you're binding the build number as a tag in your code. this ensures that every new build is a fresh build and new infra gets created.
  - in the build pipeine, we can add either copy terraform files as artifact and use it from there, or we can use the terraform files directly from the repo as well.
  - add tasks to your stage. hashicorp has some tasks to `init`, `plan` and `validate and apply` already written. or you can also write your own script here to do this. if writing script, mention `auto-approve` and `input=false` in `terraform apply` step.

4) Create a sample Terraform template you will use to deploy Below services:
Vnet
2 Subnet
NSG to open port 80 and 443
1 Window VM in each subnet
1 Storage account
5) Explain how will you access the password stored in Key Vault and use it as Admin Password in the VM Terraform template.