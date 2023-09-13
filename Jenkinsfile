pipeline {
    agent any

    tools {
         
        maven "mymaven"
    }

    environment{
        BUILD_SERVER_IP='ec2-user@13.234.217.139'
        TEST_SERVER_IP='ec2-user@3.7.46.68'
        
        //Used this environment variable for Docker Image.Build Number is inbuilt variable which is suffixed with 
        //every image which will build when the pipeline runs and maintain the version docker images.
        IMAGE_NAME='mudassir12/java-mvn-private-repos'
    }

    

    stages {
        stage('Compile') {

            steps {
                
                git 'https://github.com/MudassirKhan22/addressbook.git'

                
                sh "mvn compile"
                echo "Env to deploy: ${params.Env}"

                
            }

           
        }
        
         stage('UnitTest') {

            steps {
                
                sh "mvn test"

            }

            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }

           
        }
        
         stage('Package+Build the Docker Image+Push to registry') {

            agent any


            // when{
            //     expression{
            //         BRNACH_NAME == 'dev' || BRNACH_NAME == 'develop'
            //     }
            // }
            steps {
                script{
                    sshagent(['build-server-key']){

                        //withCredentials is used to bind your Docker Hub Credentials with the variables so that your credentials is encrypted. 
                        withCredentials([usernamePassword(credentialsId: 'DockerHubCredentials', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]){

                        echo "Packaging the code on new slave"

                        sh "scp -o StrictHostKeyChecking=no server-config.sh ${BUILD_SERVER_IP}:/home/ec2-user"
                        sh "ssh  ${BUILD_SERVER_IP} 'bash /home/ec2-user/server-config.sh ${IMAGE_NAME} ${BUILD_NUMBER}'"

                        //  sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER_IP} sudo yum install docker -y"
                        //  sh "ssh  ${BUILD_SERVER_IP} sudo systemctl start docker"
                        //  sh "ssh  ${BUILD_SERVER_IP} sudo docker build -t ${IMAGE_NAME} /home/ec2-user/addressbook-v2"
                         sh "ssh  ${BUILD_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                         sh "ssh  ${BUILD_SERVER_IP} sudo docker push ${IMAGE_NAME}:${BUILD_NUMBER}"

                        } 

                    }

                }
                
                

            }
        }

        stage('Deploy'){
            agent {label 'Linux-slave'}

            input{
                    message "Please approve to deploy"
                    ok "yes, to deploy"
                    parameters{
                        choice(name:'NEWVERSION', choices:['1.2','1.3','1.4'])
                    }
                }

            steps{

                script{
                    sshagent(['build-server-key']){

                        //withCredentials is used to bind your Docker Hub Credentials with the variables so that your credentials is encrypted. 
                        withCredentials([usernamePassword(credentialsId: 'DockerHubCredentials', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]){
                        echo "Deploying to test"
                        sh "ssh  ${TEST_SERVER_IP} sudo yum install docker -y"
                        sh "ssh  ${TEST_SERVER_IP} sudo systemctl start docker"
                        sh "ssh  ${TEST_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                        sh "ssh  ${TEST_SERVER_IP} sudo docker run -itd -P ${IMAGE_NAME}:${BUILD_NUMBER}"

                        

                        }
                    }
                }
            }
        }
    }
}
