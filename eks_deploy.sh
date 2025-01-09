#!/bin/bash

# Function to wait for a pod to be in the Running state
wait_for_pod() {
    local svc=$1
    echo "Waiting for pod associated with $svc to be ready..."
    while true; do
        pod_status=$(kubectl get pods -l app=$svc -o jsonpath='{.items[0].status.phase}' 2>/dev/null)
        if [[ $pod_status == "Running" ]]; then
            echo "Pod for $svc is ready!"
            break
        fi
        sleep 2
    done
}

# Apply Kubernetes manifests
kubectl apply -f ./k8s/ || { echo "Deployment failed!"; exit 1; }
echo "Deployment applied successfully."

 
# Wait for Flask service pod to be ready and forward the port
wait_for_pod "flask-service"
echo
echo "[Flask service is accessible at http://localhost:8080/users ]"
kubectl port-forward svc/flask-service 8080:80 || { echo "Port-forwarding for flask-service failed!"; exit 1; }


# Wait for Express service pod to be ready and forward the port
wait_for_pod "express-service"
echo 
echo "[Express service is accessible at http://localhost:8081/products ]" 
kubectl port-forward svc/express-service 8081:80 || { echo "Port-forwarding for express-service failed!"; exit 1; } 

