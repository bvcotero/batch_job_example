pipeline {
  agent {
    node {
      label 'tools'
    }
    
  }
  stages {
    stage('build') {
      steps {
        sh 'ls -la'
        sh 'echo $USER'
        sh 'aws --version'
        sh 'sh ./scripts/install_docker.sh'
        sh 'sudo docker info'
        sh 'sh ./scripts/install_terraform.sh'
        sh 'terraform --version'
      }
    }
    stage('test deployment') {
      steps {
        sh 'export ECR_REPO_NAME=batch_service_wos_dev-u6047692_unzip_save_to_s3'
        sh 'export ECR_REPO_URL=078897461510.dkr.ecr.us-west-2.amazonaws.com/batch_service_wos_dev-u6047692_unzip_save_to_s3'
        sshagent(['572c19b8-d954-47df-afc2-fe6c57501c8c']) {
          sh 'sh ./scripts/deploy_app_container.sh'
          sh 'sh ./scripts/deploy_global_infra.sh'
        }
      }
    }
  }
  
  environment {
    USER = 'jenkins'
  }
}
