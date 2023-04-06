pipeline {
    agent any

    stages {
        
        stage('Build') {
            steps {
                sh ' cd SampleWebApp && mvn clean package'
                echo 'Build with Maven
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
