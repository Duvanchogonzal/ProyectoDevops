pipeline {
    agent any

    stages {
        stage('Preparar entorno') {
            steps {
                echo 'Iniciando pipeline en Azure con Docker Compose...'
            }
        }

        stage('Apagar contenedores previos') {
            steps {
                dir('.') {
                    sh 'docker compose down || true'
                }
            }
        }

        stage('Construir contenedores') {
            steps {
                dir('.') {
                    sh 'docker compose build'
                }
            }
        }

        stage('Levantar aplicación') {
            steps {
                dir('.') {
                    sh 'docker compose up -d'
                }
            }
        }

        stage('Verificar contenedores') {
            steps {
                sh 'docker ps -a'
            }
        }

        stage('Limpiar imágenes antiguas') {
            steps {
                sh 'docker image prune -f'
            }
        }
    }

    post {
        always {
            echo 'Pipeline finalizado correctamente.'
        }
    }
}

 
