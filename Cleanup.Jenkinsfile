// Implement a Jenkins job that fully removes any TEST environment that is older than 15 minutes and sends a report to you by mail.

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

        stage ("Cleanup ") {

            steps {

                script {

                        // Get list of workspace
                        def workspace_query = sh (
                            script: """ terraform init -reconfigure && terraform workspace list""",
                            returnStdout: true).trim()

                        println("Hello" + workspace_query)


                        def workspace_list = workspace_query.tokenize("\n")
                        println("Hello next" + workspace_list)

                        // loop over the list of workspaces
                        // and destroy infrastructure
                        // if provision time is greater
                        // then 15 minute
                        for (terraform_workspace in workspace_list){

                            // trim and format text
                            terraform_workspace = terraform_workspace.replace("*", "").trim()

                            println("terraform_workspace my list : ${terraform_workspace}")


                            if (terraform_workspace.contains("_")){

                                env.CREATION_TIME = creationTime(terraform_workspace)
                                println("terraform env.CREATION_TIME : ${env.CREATION_TIME}")


                                def duration = diffInTimeInSecs("$env.CREATION_TIME")
                                

                                if (checkIfTimeIsGreaterThanElapseTime(duration)){

                                    sh"""

                                        terraform init -reconfigure
                                    
                                        terraform workspace select "${terraform_workspace}"

                                        terraform destroy -auto-approve 

                                        terraform workspace select default
                                        terraform workspace delete "${terraform_workspace}"

                                    """

                                }
                            }



                        }




                }

            }
        }




    }

}


def creationTime(workspace_){

    println("hello we start calcutlating time appended")

    def (branch, creation_time) = workspace_.tokenize("_")

    println(creation_time.trim() + "trimvalue creation time")

    return creation_time.trim()
}

def diffInTimeInSecs(creationtimevar){

    // String str = creationtimevar;
    // Double  a = Double.parseDouble(str);

    // long creation_timevalue = Math.round(a);

    def creation_timevalue =  creationtimevar.toLong()

    println("creation_timevalue creation time")
    println(creation_timevalue)


    def now = new Date();

    println(now)

    int time_diffInSecs =  ((now.getTime() - creation_timevalue) / 1000)

    println("now creation time")

    println(time_diffInSecs )

    
    return time_diffInSecs;
}

def checkIfTimeIsGreaterThanElapseTime(time){

    def elapseTime = 15 * 60;

    if (time  > elapseTime){
        return true;
    }

    return false;
}