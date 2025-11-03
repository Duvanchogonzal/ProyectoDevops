
pipeline {
    agent any

    environment {
        DEPLOY_SERVER = "azureuser@20.185.223.244"
        SSH_KEY = "/var/lib/jenkins/.ssh/id_rsa"
        APP_DIR = "/home/azureuser/app"  // Ruta donde se desplegará la app
    }

    triggers {
        // Detecta automáticamente cambios en GitHub
        pollSCM('H/2 * * * *') // verifica cada 2 minutos
    }

    stages {
        stage('Clonar Repositorio') {
            steps {
                git branch: 'main', url: 'https://github.com/duvanchogonzal/ProyectoDevops.git'
            }
        }

        stage('Construir Imágenes Docker') {
            steps {
                sh '''
                docker compose -f docker-compose.yml build
                '''
            }
        }

        stage('Copiar Archivos a VM2') {
            steps {
                sh '''
                scp -i $SSH_KEY -o StrictHostKeyChecking=no -r * $DEPLOY_SERVER:$APP_DIR
                '''
            }
        }

        stage('Desplegar Aplicación en VM2') {
            steps {
                sh '''
                ssh -i $SSH_KEY -o StrictHostKeyChecking=no $DEPLOY_SERVER "
                    cd $APP_DIR &&
                    docker compose down &&
                    docker compose up -d --build
                "
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Despliegue exitoso en VM2'
        }
        failure {
            echo '❌ Falló el despliegue'
        }
    }
}


