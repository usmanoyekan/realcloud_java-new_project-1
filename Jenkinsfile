pipeline {
    agent any

    stages {
        stage('Test') {
            steps {
                sh 'cd SampleWebApp mvn test'
            }
        }
        stage('Build') {
            steps {
                sh 'SampleWebApp && mvn clean package'
            }
        }
        
        stage('Deploy to Tomcat') {
            steps {
                deploy adapters: [tomcat9(credentialsId: 'tomcat', path: '', url: 'http://13.58.32.7:8080')], contextPath: 'webapp', war: '**/*.war'
            }
        }
    }
}
