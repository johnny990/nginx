#!/usr/bin/env groovy

node {
    stage ("Build") {
        def image
        println "Compile the last version of Nginx server with lua-nginx-module"
        git url: "https://github.com/johnny990/nginx", branch: "master"
        
        image=docker.build("aragami/nginx-lua")
        image.push()
    }
    stage ("Dockerize") {
        println "Create a docker image with adding custom nginx.conf and index.html from the repository files. Push docker image to the public Docker registry."
        
        sh """
            cd nginx_customization
            docker build -t aragami/nginx-custom --no-cache .
            docker push aragami/nginx-custom
        """
    }
    stage ("Deploy") {
        println "Deploy a Nginx container on EC2 instance using docker-machine."
        def machineName = "aws-sandbox"
        def dockerPort = "8081"
        def machineStatus = sh (script: "docker-machine status ${machineName}", returnStdout: true).trim()

        if (machineStatus != "Running") {
            sh "docker-machine create --driver amazonec2 --amazonec2-open-port ${dockerPort} --amazonec2-region us-west-2 aws-sandbox"
        }
        sh "docker-machine env --shell bash aws-sandbox"
        sh """
           docker-machine ssh aws-sandbox '''sudo docker stop nginx &2>1'''
           docker-machine ssh aws-sandbox '''sudo docker rm nginx &2>1'''
           docker-machine ssh aws-sandbox '''sudo docker run -d --name nginx -p ${dockerPort}:8080 --restart always aragami/nginx-custom'''
        """
        def url = sh (script: "docker-machine ip aws-sandbox ", returnStdout: true).trim()
        url = "http://" + url + ":" + dockerPort
        println "Access nginx via following URL: " + url
    }
    
}

