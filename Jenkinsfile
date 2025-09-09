pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'sumanthhoskote1998'   // Your Docker Hub username
        IMAGE_NAME     = 'python-app'           // Repo name you created in Docker Hub
        IMAGE_TAG      = 'latest'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/sumanthhoskote1998/dock-kube-jenkins.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG .
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-pass', variable: 'PASS')]) {
                    sh '''
                        echo $PASS | docker login -u $DOCKERHUB_USER --password-stdin
                        docker push $DOCKERHUB_USER/$IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    kubectl rollout status deployment/python-app-deployment
                    kubectl get pods -o wide
                    kubectl get svc -o wide
                '''
            }
        }
    }

    post {
        always {
            echo "Pipeline completed. Check above output for status."
        }
    }
}
