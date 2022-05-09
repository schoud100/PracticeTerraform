tfstate files are used to keep record of truth

We have implicit and explicit dependencies in terraform, taking example of Modules - if there is dependency of one module on another, 
and one of the module is removed for some reason, terraform will be notified of change to be made but it will not know in which order it needs
to remove those resources.
In such case tfstate file is used as reference so that all the dependencies alongwith the resource will be removed. 


Explicit dependencies are dependencies that are set up “manually” between resources, using the depends_on keyword.


However in order to bypass refresh if needed, use this command to use cache data to recover resources - terraform plan --refresh = false, 
this will cause resource replacement. 
Benefit for collaboration when working with the team -
as for our case, tfstate file is residing on the same folder where terraform file is placed, but for the team, every user should have latest 
updated terraform state file on their system before implementing any change, else will cause errors.
So teams store tfstate file in remote location like, AWS S3, hashicorp console and terraform cloud

terraform fmt - to format and have readability

terraform show - display current state of resource

terraform providers - to view all providers list

terraform providers mirror /path_to_new_location - mirrors providers details to another project

terraform refresh - to sync terraform state file to real world infrastructure, it does not implement the changes, it simply, in case of any manual changes done out of terraform, updates tfstate file, to use in next apply

terraform graph - visual picture of dependencies in form of json - using graphviz software we will get pictorial representation

--------------------------------------
MUTABLE AND IMMUTABLE INFRASTRUCTURE
Inplace upgrade - to upgrade software in vmss, infrastructure remains same but software version changes - MUTABLE INFRASTRUCTURE

lets assume on web server 1 and 2 are upgraded, but failed on web server 3 for many reasons like network issue,so overtime each of these instance will have different versions - CONFIGURATION DRIFT, leaves infrastructure in conflict state.
Instead of upgrading the existing servers, we can spin up new server with the updated software alonwith updated infrastructure, and bring down the 
old ones - IMMUTABLE INFRASTRUCTURE - old file deletes, new is created then
However if the new server is not provisioned successfully, then old one will remain intact and the new server will be removed

By default, terraform uses immutable infrastructure

but how to provision new ones first and then delete old ones, we have to setup lifecycle rules in terraform -
in the resource block we want to update, add -
lifecycle{
    create_before_destroy = true
}

prevent_destroy = true ---> to prevent resources from getting accidentally deleted, but not safe if terrafrom destroy is executed

ignore_changes =[] (accepts list)-> will ignore changes mentioned inside the block

--------------------------------------
Terraform State Considerations -
1. State file contains sensitive data
2. terraform infrastructure config files can be stored in distributed storage like git, github and so on, but state file needs to be stored in 
    remote backend systems like google cloud storage, azure storage, aws s3, terraform cloud etc
3. Tfstate is in json structure, never edit it manually. If we want to make changes to state files, depending on scenarios we can use -
    Inspecting State - terrafrom show, terraform refresh
    Forcing Re-creation (Tainting) - taint to apply changes to a particular resource, or untaint to undo the changes
    Moving Resources - terrform mv -> to move the resource details from one module to another, terraform state rm - to stop terraform from managing resource any longer
    Importing Pre-existing Resources (documented in the Importing Infrastructure section) - import command - to manage the resources created outside terraform code
    Disaster Recovery - terraform force-unlock(should not do unless necessary) - only in scenarios where 2 parallel processes are running to ouverwrite state file, 
     terraform push = to push changes to tfstate,overwrite current state file not receommended
     
     terraform pull = to pull changes, This is useful for reading values out of state (potentially pairing this command with something like jq). It is also useful if you need to make manual modifications to state.

