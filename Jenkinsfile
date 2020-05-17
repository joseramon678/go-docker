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
        stage('\u2600 Build') {
            steps{
                echo "******************* '${STAGE_NAME}' ... ******************"
                sh "docker build -t ${PROJECT_NAME}:${BRANCH} ."
            }
        }
        stage('\u2600 Tagging') {
            steps{
                echo "******************* '${STAGE_NAME}' ... ******************"
                sh "docker tag :${BRANCH} ${REGISTRY}/${NAME}:${COMMIT}"
            }
        }
        stage('\u2600 Publish') {
            steps{
                echo "******************* '${STAGE_NAME}' ... ******************"
                sh "docker push ${REGISTRY}/${NAME}:${COMMIT}"
            }
        }
    }
    post{
        always{
            echo "==============="
            echo "${PROJECT_NAME}"
            echo "${COMMIT}"
            echo "${BRANCH}"
            echo "${REGISTRY}"
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