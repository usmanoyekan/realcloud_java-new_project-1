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
                sh 'cd SampleWebApp && mvn clean package'
            }
        }
        
        stage('Deploy to Tomcat') {
            steps {
             deploy adapters: [tomcat9(credentialsId: 'tomcat_ID', path: '', url: 'http://3.91.2.79:8080')], contextPath: null, war: '**/*.war'            }
        }
    }
}
