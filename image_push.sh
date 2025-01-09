#!/bin/bash

# Function to validate DockerHub username
validate_username() {
    if [[ -z "$1" || ! "$1" =~ ^[a-zA-Z0-9._-]+$ ]]; then
        echo "Invalid DockerHub Username. Only alphanumeric characters, dots, underscores, and dashes are allowed."
        return 1
    fi
    return 0
}

# Prompt for DockerHub username with validation
while true; do
    read -r -p "Enter the DockerHub Username: " username
    if validate_username "$username"; then
        break
    fi
done

# Confirm the username
read -r -p "You entered '$username'. Is this correct? (y/n): " confirmation
if [[ "$confirmation" != [yY] ]]; then
    echo "Aborting. Please run the script again."
    exit 1
fi

# Check if the user wants to reconfigure an existing setup
if [ -f "k8s/deployed_username" ]; then
    previous_username=$(cat k8s/deployed_username)
    echo "Previously configured username: $previous_username"
    read -r -p "Do you want to replace it with '$username'? (y/n): " replace_confirmation
    if [[ "$replace_confirmation" != [yY] ]]; then
        echo "Aborting. No changes were made."
        exit 1
    fi
fi

# Save the current username for future reference
echo "$username" > k8s/deployed_username

# Build and push Flask image
if [ -d "user_service" ]; then
    cd user_service || exit
    docker build -t flask-service:latest .
    docker tag flask-service:latest "$username/flask-service:latest"
    docker push "$username/flask-service:latest"
    cd ..
else
    echo "Directory 'user_service' not found. Exiting."
    exit 1
fi

# Build and push Express image
if [ -d "product_service" ]; then
    cd product_service || exit
    docker build -t express-service:latest .
    docker tag express-service:latest "$username/express-service:latest"
    docker push "$username/express-service:latest"
    cd ..
else
    echo "Directory 'product_service' not found. Exiting."
    exit 1
fi

# Update Kubernetes YAML files
if [ -d "k8s" ]; then
    echo "-={ Configuring image name in k8s/... }=-"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s|$previous_username|$username|g" k8s/*.yaml
    else
        sed -i "s|$previous_username|$username|g" k8s/*.yaml
    fi
    echo "Success"
else
    echo "Directory 'k8s' not found. Exiting."
    exit 1
fi


echo "Deployment updated successfully with new username: $username"

