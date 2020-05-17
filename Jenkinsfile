pipeline{
    agent{
        label "jenkins-slave-docker"
    }
    environment {
            PROJECT_NAME = "letsgo"
            COMMIT = sh (script: "git rev-parse --short HEAD", returnStdout: true)
            BRANCH = "${env.BRANCH_NAME}"
            REGISTRY = "jrmanes"
    }
    stages{
        stage('\u2600 Checkout') {
            steps{
                echo "******************* '${STAGE_NAME}' ... ******************"
                checkout scm
            }
        }
        stage('\u2600 Build') {
            steps{
                echo "******************* '${STAGE_NAME}' ... ******************"
                sh "docker build -t ${PROJECT_NAME}:${envBranch} ."
            }
        }
        stage('\u2600 Tagging') {
            steps{
                echo "******************* '${STAGE_NAME}' ... ******************"
                sh "docker tag ${NAME}:${envBranch} ${REGISTRY}/${NAME}:${COMMIT}"
            }
        }
        stage('\u2600 Publish') {
            steps{
                echo "******************* '${STAGE_NAME}' ... ******************"
                sh "docker push ${REGISTRY}/${NAME}:${COMMIT}"
            }
        }
    
    
    post{
        always{
            echo "========always========"
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}