#!/bin/bash

# Get the list of ECS cluster ARNs
CLUSTERS=$(aws ecs list-clusters --query "clusterArns" --output text)

# Loop through each cluster
for CLUSTER in $CLUSTERS; do
  echo "Cluster name: $CLUSTER"
done

# Assign $CLUSTER to your own cluster name from the above
CLUSTER="pohleng-ecs-tf"  # Replace this with your actual cluster name

# Get the list of task ARNs for the current cluster
TASKS=$(aws ecs list-tasks --cluster $CLUSTER --query "taskArns" --output text)

# Loop through each task in the cluster
for TASK in $TASKS; do
  echo "Task ARN: $TASK"

  # Get ENI from ECS
  ENI=$(aws ecs describe-tasks --cluster $CLUSTER --tasks $TASK --query "tasks[0].attachments[0].details[?name=='networkInterfaceId'].value | [0]" --output text)
  echo "I believe our ENI is $ENI"

  # Get public IP address from EC2
  PUBLICIP=$(aws ec2 describe-network-interfaces --network-interface-ids $ENI --query 'NetworkInterfaces[0].Association.PublicIp' --output text)
  echo "I believe our public IP address is $PUBLICIP"

  # Set the public IP address as Terraform local value
  echo "public_ip_address = \"$PUBLICIP\"" > public_ip_address.auto.tfvars
done

# Debug information
echo "Script executed!" >> script_execution.log
