#!/bin/bash

ID1="i-0f430daf4ca8c86ed"
ID2="i-0885fcad17bf238ae"
ACTION=$1

# Check if AWS CLI can connect to the endpoint
aws ec2 describe-instances --region us-east-1 &> /dev/null
if [ $? -ne 0 ]; then
    echo "ERROR: Could not connect to AWS EC2. Exiting..."
    exit 1
fi

case "$ACTION" in
  start)
    aws ec2 start-instances --instance-ids $ID1 $ID2
    echo "Starting instances..."
    ;;
  stop)
    aws ec2 stop-instances --instance-ids $ID1 $ID2
    echo "Stopping instances..."
    ;;
  *)
    echo "Usage: $0 {start|stop}"
    exit 1
    ;;
esac

MAX_ATTEMPTS=60
ATTEMPT=0

while true; do
  STATES=($(aws ec2 describe-instances --instance-ids $ID1 $ID2 \
    --query "Reservations[*].Instances[*].State.Name" --output text))

  if [[ "$ACTION" == "start" && "${STATES[0]}" == "running" && "${STATES[1]}" == "running" ]]; then
    echo -e "Instances are running.\nGluck♥️ "
    break
  elif [[ "$ACTION" == "stop" && "${STATES[0]}" == "stopped" && "${STATES[1]}" == "stopped" ]]; then
    echo -e "Instances are stopped.\n:Gluck♥️ "
    break
  else
    echo "Waiting for instances to change state..."
    sleep 5
  fi

  ((ATTEMPT++))
  if [[ $ATTEMPT -ge $MAX_ATTEMPTS ]]; then
    echo "Timeout waiting for instances."
    exit 1
  fi
done

