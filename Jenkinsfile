pipeline {
    agent any

    stages {
        stage('Git Checkout') {
            steps {
                git 'https://github.com/seeewhy/realcloud_java-new_project.git'
            }
        }
        stage('Build') {
            steps {
                sh 'SampleWebApp && mvn clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'cd SampleWebApp mvn test'
            }
        }
        stage('Deploy to Tomcat') {
            steps {
                deploy adapters: [tomcat9(credentialsId: 'tomcat', path: '', url: 'http://18.188.105.217:8080//')], contextPath: 'path', war: '**/*.war'
            }
        }
    }
}
