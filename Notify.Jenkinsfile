// Implement a job that runs every 15 minutes and sends you a list of all active environments by mail.
// terraform workspace list 

pipeline {

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


    stages {

        stage ('checkout'){
            steps{
                checkout scm
            }
        }
        stage ("Alert") {

            steps {

                script {

                        // Get list of workspace
                        env.TERRAFORM_WORKSPACE_QUERY = sh (
                            script: """ terraform init -reconfigure && terraform workspace list""",
                            returnStdout: true).trim()

                        println("================ ACTIVE TERRAFORM WORKSPACE / INFRASTRUCTURES =============")
                        println(env.TERRAFORM_WORKSPACE_QUERY)

                        emailext attachLog: true,
                        body: EmailBodyActiveWkSpaces(),
                        replyTo: 'do-not-reply@develep-bootcampghana1.com', 
                        subject: "Active Infrastructures - Job \'${env.JOB_NAME}:${env.BUILD_NUMBER}\'", 
                        to: 'rojedkay@gmail.com'

                }

            }
        }

    }


    post{

        always{
            
                emailext attachLog: true,
                body: EmailBody(),
                compressLog: true,
                replyTo: 'do-not-reply@develep-bootcampghana1.com', 
                subject: "Status: ${currentBuild.result?:'SUCCESS'} - Job \'${env.JOB_NAME}:${env.BUILD_NUMBER}\'", 
                to: 'rojedkay@gmail.com'

        }
    }



}


def EmailBody(){
   return """
             <p>EXECUTED: Job <b>\'${env.JOB_NAME}:${env.BUILD_NUMBER})\'</b></p>

             <p>View console output at "<a href="${env.BUILD_URL}">${env.JOB_NAME}:${env.BUILD_NUMBER}</a>"</p> 

             <p><i>(Build log is attached.)</i></p>   
         """
}

def EmailBodyActiveWkSpaces(){
   return """
             <p>View console output at "<a href="${env.BUILD_URL}">${env.JOB_NAME}:${env.BUILD_NUMBER}</a>"</p> 
             <div>
               <p>Active WKSpaces</p> 
               ${env.TERRAFORM_WORKSPACE_QUERY}
             </div>   
         """
}