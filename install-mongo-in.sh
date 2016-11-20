#!/bin/bash
echo "Executing with:"
echo "Param 1: $1"
echo "Param 2: $2"
echo "Param 3: $3"

# Array of required builds
declare -a BUILDS=("default-install")
MAIN_PLAYBOOK="mongo-in-vpc.yml"

# First let's make sure they all do in fact exist, otherwise we could waste
# a lot of time waiting on a partial build to complete.
for build in "${BUILDS[@]}"; do
	if ! [ -e "./regions/mongodb_$1_$build.yml" ]
		then echo "Required file for region $1 and deployment $build doesn't exist. Cannot continue."
		exit 1;
	fi
done

set -e
for build in "${BUILDS[@]}"; do
	ANSIBLE="ansible-playbook --extra-vars=\"target_region=$1 env=$2 deployment_group=$build\" --vault-password-file=vault-password.txt $MAIN_PLAYBOOK $3"
	echo "Running command: $ANSIBLE"
	eval "${ANSIBLE}"
done
