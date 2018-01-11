#Task definition

Create test Nginx server with GitHub webhook deployment triggering, using Jenkinsfile.

## Stages:
- Build.Compile the last version of Nginx server with lua-nginx-module.
- Dockerize.Create a docker image with adding custom nginx.conf and index.html from the repository files. Push docker image to the public Docker registry.
- Deploy. Deploy a Nginx container on EC2 instance using docker-machine.
Deploy should start by push event to the master branch.

##Output:
Push the final code revision to a public GitHub repository and share URL link to it.

# Prerequisites
- aws account, keys and other configuration to allow provisioning of the instances
- Jenkins with docker engine and GitHub, pipeline plugins
- install docker-machine on jenkins

# Implementation

Original task was not described in detailed, so it was decided to implement it in a following way:

- **Build** stage was impelemted inside docker container to increase reproducibility
- Two docker images created: *aragami/nginx-lua* (default nginx with lua module) and *aragami/nginx-custom* (with customized nginx.conf and index.html)
- Customizations applied:
    - **nginx.conf**
        - listen port changed to 8080 (and it is mapped to 8081 outside) 
        - *user nginx* instead of *user nobody*
    - **index.html**    
        - <span>customized<span> with color "red" added to index.html
- Jenkins URL with r/o access: [http://ec2-54-212-221-58.us-west-2.compute.amazonaws.com:8080/](http://ec2-54-212-221-58.us-west-2.compute.amazonaws.com:8080/)
- GitHub repo URL: [https://github.com/johnny990/nginx](https://github.com/johnny990/nginx)


