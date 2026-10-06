@Library('cafs-shared-library') _

pipeline {

    agent any

    options {
        skipDefaultCheckout(true)
        timestamps()
    }

    environment {
        IMAGE_NAME = 'roxcruxx/img_final_cafs'
        IMAGE_TAG  = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Instalar dependencias y pruebas') {
            steps {
                sh '''
                    docker run --rm \
                    -v "$PWD:/app" \
                    -w /app \
                    node:20-alpine \
                    sh -c "npm ci && npm test --if-present"
                '''
            }
        }

        stage('Docker Build & Push') {
            steps {
                dockerBuildAndPush(
                    image: env.IMAGE_NAME,
                    tag: env.IMAGE_TAG
                )
            }
        }

        stage('Deploy Kubernetes') {
            steps {
                deployKubernetes(
                    image: "${env.IMAGE_NAME}:${env.IMAGE_TAG}",
                    namespace: 'proy-final-cafs',
                    deployment: 'backend',
                    container: 'backend'
                )
            }
        }
    }

    post {
        success {
            echo 'PIPELINE FINALIZADO CORRECTAMENTE'
        }

        failure {
            echo 'PIPELINE CON ERRORES'
        }
    }
}