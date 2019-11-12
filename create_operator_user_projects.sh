#!/bin/sh

# Array with users
#declare -a users=("user40")
#declare -a users=("user3" "user4")
#declare -a users=("user5" "user6" "user7" "user8" "user9" "user10" "user11" "user12" "user13" "user14" "user15" "user16" "user17" "user18" "user19" "user20" "user21" "user22" "user23" "user24" "user25" "user26" "user27" "user28" "user29" "user30" "user31" "user32" "user33" "user34" "user35" "user36" "user37")

START=1
END=2

echo "Creating projects."

for i in $(seq $START $END); do
   echo "Setting up environment for user$i."
   PROJECT_NAME="rhpam75-operator-lab-user$i"
   oc new-project $PROJECT_NAME --display-name="RHPAM 7.5 Operators Lab - User$i" --description="RHPAM 7.5 Operators Lab for User$i."
   oc annotate namespace $PROJECT_NAME openshift.io/requester=user$i --overwrite
   oc policy add-role-to-user admin user$i -n $PROJECT_NAME

   # Create Operator subscription.
   cat subscribe-ba-operator-1.2.0.yaml | sed -e "s/namespace-placeholder/$PROJECT_NAME/g" | oc create -f -

   # Create the rolebinding to view the app in the Operator Console
   oc create rolebinding kie-operator-view-kieapps --clusterrole=view-kieapps.app.kiegroup.org-v1 --user=user$i -n $PROJECT_NAME
done
