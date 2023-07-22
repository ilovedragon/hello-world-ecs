# hello-world-ecs

# Get the list of ECS cluster ARNs
CLUSTERS=$(aws ecs list-clusters --query "clusterArns" --output text)

# Loop through each cluster
for CLUSTER in $CLUSTERS; do
  echo "Cluster name: $CLUSTER";done

# assign $CLUSTER to your own cluster name from the above
CLUSTER=pohleng-ecs-tf

# Get the list of task ARNs for the current cluster
TASKS=$(aws ecs list-tasks --cluster $CLUSTER --query "taskArns" --output text)

# Loop through each task in the cluster
for TASK in $TASKS; do
  echo "Task ARN: $TASK";done

# assign $CLUSTER to your own task name from the above
TASK=pohleng-ecsdemo

## get eni from from ECS
ENI=$(aws ecs describe-tasks --cluster $CLUSTER --tasks $TASK --query "tasks[0].attachments[0].details[?name=='networkInterfaceId'].value | [0]" --output text)
echo I believe our eni is $ENI

## get public ip address from EC2
PUBLICIP=$(aws ec2 describe-network-interfaces --network-interface-ids $ENI --query 'NetworkInterfaces[0].Association.PublicIp' --output text)
echo "I believe our public IP address is $PUBLICIP"