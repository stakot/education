def appName = "my-app"
def appVersion = "1.0-SNAPSHOT"


node('docker_slave'){
    tool name: 'maven', type: 'maven'
    stage('Check prerequests'){
        withEnv(["PATH=${env.PATH}:${tool 'maven'}/bin"]){
            sh 'env | grep PATH'
//          echo "${tool 'maven'}"
            sh 'mvn -v'
        }
    }
    stage('Get sources'){
        git(url: 'git@github.com:jenkins-docs/simple-java-maven-app.git', branch: "master", credentialsId: 'github-key')
    }
    stage('Build'){
        withEnv(["PATH=${env.PATH}:${tool 'maven'}/bin"]){
            sh 'mvn -B -DskipTests clean package'
//            appName = sh(script: 'mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.name', returnStdout: true).trim()
//            appVersion = sh(script: "mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version", returnStdout: true).trim()
        }        
    }
    stage('Test'){
        withEnv(["PATH=${env.PATH}:${tool 'maven'}/bin"]){
            sh 'mvn test'
            stash includes: 'target/my-app-1.0-SNAPSHOT.jar', name: 'artifactStash'
        }        
    }
}
node('docker_slave1'){
    tool name: 'docker-latest', type: 'org.jenkinsci.plugins.docker.commons.tools.DockerTool'
    stage('Ckeck prerequest'){
        echo "${tool name: 'docker-latest'}"
        sh "ls -lah"
        withEnv(["PATH=${env.PATH}:${tool name: 'docker-latest'}/bin"]){
            sh 'docker -v'
        } 
    }
    stage('Get Dockerfile'){
        git(url: 'git@github.com:stakot/education.git', branch: "master", credentialsId: 'github-key')
    }
    stage('unstash our application'){
        unstash 'artifactStash'
    }
    stage('Build our Docker'){
        withEnv(["PATH=${env.PATH}:${tool name: 'docker-latest'}/bin"]){        
            sh "docker build --no-cache --build-arg APP_NAME=${appName} --build-arg APP_VERSION=${appVersion} -t madstas/myappdocker ."
        }
    }
     stage('Push our Docker to dockerhub'){
        withEnv(["PATH=${env.PATH}:${tool name: 'docker-latest'}/bin"]){ 
        docker.withRegistry( '', 'dockerhub' ) {
            docker.image('madstas/myappdocker')
            docker.image.push
        }
    }
}
}