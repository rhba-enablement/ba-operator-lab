#!/bin/sh

echo "Remove the htpass-secret from OpenShift."

oc delete secret/htpass-secret -n openshift-config

# Create the htpasswd file with the developer account
htpasswd -c -B -b users.htpasswd developer developer

END=20

echo "Creating $END user accounts."

for i in $(seq 1 $END); do 
	echo "Creating user$i"
	htpasswd -b users.htpasswd user$i openshift
done

echo "Create the htpass-secret on OpenShift."
oc create secret generic htpass-secret --from-file=htpasswd=users.htpasswd -n openshift-config
