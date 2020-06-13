pipeline{
    // agent{
    //     label "jenkins-slave-docker"
    // }
    environment {
        PROJECT_NAME = "letsgo"
        COMMIT = sh (script: "git rev-parse --short HEAD", returnStdout: true)
        BRANCH = "${env.BRANCH_NAME}"
        REGISTRY = "jrmanes"
    }
  agent {
        kubernetes {
            label mylabel
            defaultContainer "docker"
            yaml """
                apiVersion: v1
                kind: Pod
                metadata:
                labels:
                component: ci
                spec:
                containers:
                - name: docker
                    image: jrmanes/jenkins-slave-docker:latest
                    command:
                    - cat
                    tty: true
                    resources:
                    limits:
                        cpu: 100m
                        memory: 600Mi
                    requests:
                        cpu: 100m
                        memory: 300Mi
        """
        }
  }
    stages{
        stage('\u2600 Build') {
            steps{
                echo "******************* '${STAGE_NAME}' ... ******************"
                    sh "docker build -t ${PROJECT_NAME}:${BRANCH} ."
            }
        }
        stage('\u2600 Tagging') {
            steps{
                echo "******************* '${STAGE_NAME}' ... ******************"
                sh "docker tag ${PROJECT_NAME}:${BRANCH} ${REGISTRY}/${PROJECT_NAME}:${COMMIT}"
            }
        }
        stage('\u2600 Login') {
            steps{
                echo "******************* '${STAGE_NAME}' ... ******************"
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker',
                            usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                            sh 'docker login --username=$USERNAME --password=$PASSWORD'
                        }
                }
        }
        stage('\u2600 Publish') {
            steps{
                echo "******************* '${STAGE_NAME}' ... ******************"
                sh "docker push ${REGISTRY}/${PROJECT_NAME}:${COMMIT}"
            }
        }
        stage('\u2600 Kubernetes Deployment') {
            steps{
                echo "******************* '${STAGE_NAME}' ... ******************"
                script {
                    def envBranch = getBranchName()
                    callJob(envBranch)
                }
            }
        }
        
    }
    post{
        always{
            echo "==============="
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}

////////////////////////////////////
// Functions
////////////////////////////////////
def getBranchName(){
    def branchName = env.BRANCH_NAME
    echo "The trimBranchName value recived is: ${branchName}"
    switch(branchName) {
        case "develop":
            branchName = "dev"
            break
        case "master":
            branchName = "prod"
            break
        default:
            branchName = "testing"
            break
    }
    return branchName 
}

def callJob(String branch) {
    build job: 'LetsGo_K8S',
        parameters: [
            string(name: 'environment', value: String.valueOf(branch)),
            string(name: 'project_name', value: String.valueOf(env.PROJECT_NAME)),
            string(name: 'docker_commit', value: String.valueOf(env.COMMIT))
        ]
}


def getAgent(){
agent =  """
apiVersion: v1
kind: Pod
metadata:
labels:
  #name: jenkins-slave-docker
  component: ci
spec:
  # Use service account that can deploy to all namespaces
  serviceAccountName: jenkins
  containers:
  - name: docker
    image: jrmanes/jenkins-slave-docker:latest
    workingDir: /home/jenkins
    volumeMounts:
    - name: docker-sock-volume
      mountPath: /var/run/docker.sock
    command:
    - cat
    tty: true
    volumes:
    - name: docker-sock-volume
      hostPath:
      path: /var/run/docker.sock
"""
return agent
}
