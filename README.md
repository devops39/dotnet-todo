# dotnet-todo

## Test the GET endpoints

Test the app by calling the endpoints from a browser or Postman. The following steps are for Postman.

  Create a new HTTP request.
  Set the HTTP method to GET.
  Set the request URI to https://localhost:<port>/todoitems. For example, https://localhost:5001/todoitems.
  Select Send.

The call to GET /todoitems produces a response similar to the following:

```json
[
  {
    "id": 1,
    "name": "walk dog",
    "isComplete": false
  }
]
```

  Set the request URI to https://localhost:<port>/todoitems/1. For example, https://localhost:5001/todoitems/1.

  Select Send.

  The response is similar to the following:

```json
  {
    "id": 1,
    "name": "walk dog",
    "isComplete": false
  }
```

This app uses an in-memory database. If the app is restarted, the GET request doesn't return any data. If no data is returned, POST data to the app and try the GET request again.



## Building and Running the Docker Image

```
docker build -t dotnet-todo.

docker run -d -p 5001:80 --name myapp devoops39/dotnet-todo:latest
```


## Deploying with Helm

### Prerequisites
- Helm installed on your local machine.
- Kubernetes cluster running (e.g., Minikube).

### Steps to Deploy

 **Install the Helm Chart**:
```
   helm install dotnet-todo ./helm-chart
```


## GitHub Actions Workflow

This workflow automatically builds, tests, and deploys the application using a Kubernetes cluster.

### Workflow Overview

- **Checkout Code**: Retrieves the latest code from the repository.
- **Set up Minikube**: Initializes a Minikube cluster for testing.
- **Deploy Helm Chart**: Deploys the application using the Helm chart created in Step 2.
- **Test Application**: Runs a series of tests against the deployed application endpoints.

To rerun the workflow, push a new commit to the repository.


