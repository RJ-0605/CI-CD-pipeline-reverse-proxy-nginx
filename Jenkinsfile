
pipeline{
    agent any
    options {
        timestamps()
        timeout(time:15, unit:'MINUTES')
        gitLabConnection('gitlab_api_connection')
    }
    triggers{
        gitlab(triggerOnPush: true, triggerOnMergeRequest: true, branchFilterType: 'All')
    }
    tools{
        maven "Maven_3.6.2"
        jdk "JAVA_8"
        terraform "Terraform_21"
    }
    stages{
        stage ('checkout'){
            steps{
                checkout scm
            }
        }
        stage('build & unit tests'){
            steps{
                sh"""
                    echo "building stage has started"

                    ls

                    cd ted-search-app

                    ls

                    mvn package dockerfile:build


                """
            }
        }
        stage('Publishing'){
            when{
                changelog '.*#test.*'
            }
            steps{
                sh"""

                    echo "deploying stage has started"
                    docker image ls 

                    aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 644435390668.dkr.ecr.us-west-2.amazonaws.com
                    
                    docker tag embedash-ted-search:1.0 644435390668.dkr.ecr.us-west-2.amazonaws.com/rodney-ecr-ted-search:latest

                    docker push 644435390668.dkr.ecr.us-west-2.amazonaws.com/rodney-ecr-ted-search:latest

                    sleep 10

                    echo " #####terraform in progress######"

                    ls
                    
                """


                
            }
        }
        stage('Test Environment'){
            when{
                changelog '.*#test.*'
            }
            steps{

                script{
                    
                    env.COMMIT_ID = env.GIT_COMMIT
                    println(env.GIT_COMMIT)
                    env.WORKSPACE_NAME=sh( script: "git --no-pager show -s --format='%an <%ae>' ${env.COMMIT_ID} | awk '{print \$1 }'", returnStdout: true).trim()
                    env.TIME_NOW=TimeInSecs()
                    env.FULL_WRKSPACE_NM = "${WORKSPACE_NAME}_${TIME_NOW}"
                    
                    
                    withCredentials([[  
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'rj-aws-credentials',
                        accessKeyVariable: "AWS_ACCESS_KEY_ID",
                        secretKeyVariable: "AWS_SECRET_ACCESS_KEY"]]){

                            sh"""

                                    echo workspace_name  env.WORKSPACE_NAME

                                    terraform init 

                                    terraform validate

                                    terraform workspace list
                                    
                                    terraform workspace select "${FULL_WRKSPACE_NM}" || terraform workspace new "${FULL_WRKSPACE_NM}"

                                    terraform apply --auto-approve

                                    terraform workspace list

                                    sleep 40

                                """
                    }
                

                    
                }
            }
        }
        stage('e2e_tests'){
            when{
                changelog '.*#test.*'
            }
            steps{
                sh"""

                        echo " testing stage has started"
                        
                        chmod +x  e2e-test.sh

                        ./e2e-test.sh

                        echo " ##### done with tests ######"

                        ls
                    
                """
                
            }
        }
        
    }
    post {
        always {
            // Cleaning workspace
            cleanWs()
            emailext subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!',
                body: '''$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS:
                Check console output at $BUILD_URL to view the results.''',
                from:'jenkins',
                to: emailextrecipients([culprits(), upstreamDevelopers(), developers()])
        }
        success {
            sh """
                echo success
            """
            updateGitlabCommitStatus name: 'build', state: 'success'
        }
        failure {
            sh """
                echo failure
            """
            updateGitlabCommitStatus name: 'build', state: 'failed'
        }
    }

}


def TimeInSecs() {
    def curr_time = new Date()
    return curr_time.getTime()
}

