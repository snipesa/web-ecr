Containerized and highly available web application
The project describes an architecture where the application code or architecture is been created 
Any pull request or push to the main branch triggers github actions
Github actions has two workflow files: one for the vpc architecture and ecr repo by terraform code; and another for the web application to be pushed to the ecr registory created.
The terraform code is a highly available solution with public and private subnets. The terraform workflow file does a terraform fmt, init, validate, plan and subsequently a push upon a merge with the main or master branch.
The app workflow file, with the help of the docker file builds the docker image and pushes to the ECR registry. 
 

The image could be pulled and deployed to the vpc environment

