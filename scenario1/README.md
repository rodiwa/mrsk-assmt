# Scenario 1

1) The build should trigger as soon as anyone in the dev team checks in code to master branch.
- use `trigger` to fire builds based on your criteria.
- you can specify name of branches (`master`, `dev`, etc) or name of events (`pull_request`, etc). Use an array fo events if using multiple events as triggers.
```
trigger:
  - master
```
2) There will be test projects which will create and maintained in the solution along the Web and API. The trigger should build all the 3 projects - Web, API and test.
The build should not be successful if any test fails.
- to trigger all 3 projects, we create 3 different stages - `test`, `web`, `api`, that run on same/ common trigger.
```
stages:
  - test
    jobs
      - job: ...
  - web
    jobs
      - job: ...
  - api
    jobs
      - job: ...  
```
- we don't want `web`, `api` stage to run if `test` fails, so we can add condition.
```
stages:
  - test
    jobs
      - job: ...
  - web
    jobs
      - job: ...
    condition: succeeded('test')
  - api
    jobs
      - job: ...
    condition: succeeded('test')
``` 
3) The deployment of code and artifacts should be automated to Dev environment.
- in build  pipeline, we can add task to publish artifacts in every stage to a certain $LOCATION.
- to deploy automatically to dev env, we can create new release pipeline that has trigger set to artifact (based on $LOCATION) (this makes the trigger continous everytime we have new artifact).
- in release pipeline, add tasks for example, "Publish to azure webapp", where we create a azure webapp + plan and add the URI of that webapp to this task.
4) Upon successful deployment to the Dev environment, deployment should be easily promoted to QA and Prod through automated process.
- in release pipeline, we can create 2 new stages (using UI, create in sequeance, not in parallel). 1 for each QA and another for PROD.
- we can create gates (automatic) and approvals (manual intervention) at post-dev deployment stage, ie, rather than deploying to all stages simultaneously, if deploy to dev was successful, we can then deploy to QA, run post deployment checks and if successful, we can promote to prod as well (see below).
- post and pre deloyment checks can be used here to get results of integration tests, load, stress tests.
- gates can be used to query and see if all bugs are closed or if any bugs have been created by system automatically during latest deployment. if `count===0`, we can ready deployment to proceed to prod.  
5) The deployments to QA and Prod should be enabled with Approvals from approvers only.
- in release pipeline, edit PROD stage (on left side of stage-card) and add a approval setting.
- in the blade that opens, mention the names of users or groups that need to approve to promote build to prod. 
- if QA, prod deployments need to be done manually, we'll need to add `approvals`, pre deployment approvals, so somebody has to manually approve, give comment and then promote build.