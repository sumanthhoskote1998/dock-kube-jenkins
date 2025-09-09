pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "sumanthhoskote1998/python-app:latest"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/sumanthhoskote1998/dock-kube-jenkins.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                  docker build -t $DOCKER_IMAGE .
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-pass',
                                                  usernameVariable: 'DOCKER_USER',
                                                  passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                      echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                      docker push $DOCKER_IMAGE
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
                  kubectl get pods -n default
                  kubectl get svc -n default
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

