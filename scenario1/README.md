# Scenario 1

1) The build should trigger as soon as anyone in the dev team checks in code to master branch.
- use `trigger` to fire builds based on your criteria.
- you can specify name of branches (`master`, `dev`, etc) or name of events (`pull_request`, etc). Use an array fo events if using multiple events as triggers.
2) There will be test projects which will create and maintained in the solution along the Web and API. The trigger should build all the 3 projects - Web, API and test.
The build should not be successful if any test fails.
- by default, all builds run in parallel. since we do not have explicit instruction to NOT run them in parallel, we can use default.
- create 3 stages - `WEB`, `API`, `TEST`. these will run in parallel.
- create a new stage (4th stage) that has a `dependsOn` or a `needs` property that will run only after completion of previous stage (use ids to mention stages explicitly).
- in this 4th stage, we should also add a `condition = successAll` to run only if all 3 prev stages have passed.
- this 4th stage can promote builds to next stage if prev 3 were a success (publish artifacts to shared common folder, that can be picked up by release pipleline for further processing)
- OR we can create a 5th stage that has a `condition` to run if any 1 of the 1st 3 builds have failed. we can add web integrations (slack) to notify devs of failure or have integrations with JIRA to create a ticker automatically. 
3) The deployment of code and artifacts should be automated to Dev environment.
- lets say we reach 4th stage in our pipeline and all 3 prev stages have been successful. here, we can add tasks to publish artifacts to shared location (esp if we want to use az release piplelines to further deploy to dev, QA, etc) OR we can add task to publish to deploy to azure web app URI or azure AKS service using images from here only.
4) Upon successful deployment to the Dev environment, deployment should be easily promoted to QA and Prod through automated process.
- we can create gates (automatic) and approvals (manual intervention) at post-dev deployment stage, ie, rather than deploying to all stages simultaneously, if deploy to dev was successful, we can then deploy to QA, run post deployment checks and if successful, we can promote to prod as well (see below).
- post and pre deloyment checks can be used here to get results of integration tests, load, stress tests.
- gates can be used to query and see if all bugs are closed or if any bugs have been created by system automatically during latest deployment. if `count===0`, we can ready deployment to proceed to prod.  
5) The deployments to QA and Prod should be enabled with Approvals from approvers only.
- if QA, prod deployments need to be done manually, we'll need to add `approvals`, pre deployment approvals, so somebody has to manually approve, give comment and then promote build.