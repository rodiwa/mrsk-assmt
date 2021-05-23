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
- There are many ways to do this, in general, these are some strategies
  - Create build pipeline to create applciation builds, run unit tests and integration tests, create feedback loop for dev, QAs. Once application is build successfully, publish it as an artifact to be consumed by the release pipeline. Add load testing, security testing, etc in this phase. Use gates and approvals to promote builds to higher envs.
  - If project is not too big, another way can be to do deployments in build pipleline itself. Esp if stages to be deployment are dev, test envs mostly. 
- High level overview (an example using terraform and azure piplelines (AP))
  - Complete dev work. Start small, start locally at first. Test and push your code to repo.
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
  - You can use different `variable` files to deploy infra to different environments (using the same tf template). 

4) Create a sample Terraform template you will use to deploy Below services:
- Services are  
  - Vnet
  - 2 Subnet
  - NSG to open port 80 and 443
  - 1 Window VM in each subnet
  - 1 Storage account
- See attached `main.tf` file for solutionn.
- In general, these are the steps you'd want to follow
  - Start with `main.tf`, `paramters.tf`, `variables.tf`.
  - Write all code inside `main.tf` file.
  - If same resource definition is being repeated, move it to it's own module for reusability.
  - Use `count`, `loop` to iterate same resources where needed.
  - `paramters.tf` is to give type definition and default values. Use default values for resources with optional values. Do not give default values for mandatory fields.
  - `variables.tf` can be used to give runtime values for deploying resources in different env with different properties for each env. For ex, diff size of VM for dev, test, prod, diff location for resources, etc.

5) Explain how will you access the password stored in Key Vault and use it as Admin Password in the VM Terraform template.
- Here are the steps
  - create a new service connection/ principal so az pipelines can communicate to az key vault securely.
  - in az key vault, goto the keys (password) that you have created and saved there and allow the service connection access to it. you specifically want to give it the `get`, `list`, `read` permissions so az pipleline can read the values.
  - in az pipelines, go to the build pipeline.
  - goto variables and create a new variable group.
  - here you can "link" your az key vault to a variable group. so basically, any key/ secret you had saved in az key vault will be available under this variabe group.
  - in terraform file, where you have mentioned the password, you can refer it using a `var` keyword. for ex, `${var.variable_group.variable_key}`.
  - see demo file for this solution.
