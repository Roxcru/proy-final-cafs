pipeline {
    agent {
        docker {
            image 'node:20-alpine'
        }
    }

    stages {
        stage('Instalar dependencias') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Validar código') {
            steps {
                sh 'node --check index.js'
            }
        }
    }
}