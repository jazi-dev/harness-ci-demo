# harness-ci-demo

A minimal Go web application for demonstrating a Harness CI pipeline that builds a Docker image and pushes it to Docker Hub.

## Run locally

```sh
go run .
```

The application listens on port `8080`.

## Build the Docker image

```sh
docker build -t harness-ci-demo:local .
```

## Run the Docker container

```sh
docker run --rm -p 8080:8080 harness-ci-demo:local
```

## Test the endpoints

```sh
curl http://localhost:8080/
curl http://localhost:8080/health
curl http://localhost:8080/version
```

Expected responses:

```json
{"message":"Hello from Harness CI!"}
{"status":"healthy"}
{"version":"1.0.0"}
```

## Harness CI Setup

This demo uses Harness CI to:

```text
GitHub → Harness CI → Build Docker Image → Docker Hub
```

---

## 1. Create a Harness Project

Sign in to Harness and click **Create Project**.

Use:

```text
Name: harness-ci-demo
Organization: default
```

Click **Save and Continue**.

You can skip inviting collaborators.

---

## 2. Create the GitHub Connector

Inside the `harness-ci-demo` project, go to:

**Project Settings → Connectors → New Connector**

Select:

```text
GitHub
```

Configure the connector:

```text
Name: github-connector
URL Type: Repository
Repository URL: https://github.com/johnbedeir/harness-ci-demo
```

Authenticate with GitHub.

For **Connectivity Mode**, select:

```text
Connect through Harness Platform
```

Run the **Connection Test** and finish creating the connector.

---

## 3. Create the Docker Hub Connector

Go to:

**Project Settings → Connectors → New Connector**

Select:

```text
Docker Registry
```

Choose:

```text
Provider Type: DockerHub
```

Configure:

```text
Name: dockerhub-connector
Docker Registry URL: https://index.docker.io/v2/
Authentication: Username and Password
Username: triple3a
```

For the password, create a Harness Secret containing your **Docker Hub Personal Access Token**.

Then select:

```text
Connect through Harness Platform
```

Run the **Connection Test** and finish creating the connector.

---

## 4. Open Harness Builds

Return to the project **Overview**.

Select:

```text
Builds
```

If this is your first build, Harness will show that no pipelines exist.

Click:

```text
Create a Pipeline
```

---

## 5. Create the Pipeline

Create the pipeline:

```text
Name: harness-ci-demo
```

Open the pipeline in **Pipeline Studio**.

---

## 6. Add a Build Stage

Click:

```text
Add Stage
```

Select:

```text
Build
```

Configure:

```text
Stage Name: Build Docker Image
Clone Codebase: Enabled
Git Provider: Third-party Git provider
Connector: github-connector
Repository: johnbedeir/harness-ci-demo
```

Click:

```text
Set Up Stage
```

---

## 7. Configure Build Infrastructure

Open the **Infrastructure** section of the Build stage.

Select:

```text
Infrastructure: Cloud
Operating System: Linux
```

Using **Cloud** allows Harness to run the build without requiring your own Kubernetes cluster, VM, or local runner.

Click:

```text
Continue
```

---

## 8. Add the Docker Build Step

Open the **Execution** section.

Click:

```text
Add Step
```

Select:

```text
Build and Push an image to Docker Registry
```

Configure the step:

```text
Name: Build and Push Docker Image

Registry Type:
Third-Party Artifact Registry

Docker Connector:
dockerhub-connector

Docker Repository:
triple3a/harness-ci-demo
```

---

## 9. Configure Docker Image Tags

Under **Tags**, add:

```text
latest
```

and:

```text
<+codebase.commitSha>
```

This creates images similar to:

```text
triple3a/harness-ci-demo:latest

triple3a/harness-ci-demo:<git-commit-sha>
```

Leave **Docker Layer Caching** disabled for this simple demo.

Under **Optional Configuration**, verify that the build uses the repository's root Dockerfile:

```text
Dockerfile
```

Click:

```text
Apply Changes
```

---

## 10. Save the Pipeline

Click:

```text
Save
```

The pipeline should now contain:

```text
Pipeline
   │
   └── Build Docker Image
          │
          └── Build and Push Docker Image
```

---

## 11. Run the Pipeline

Click:

```text
Run
```

Select:

```text
Branch: main
```

Start the pipeline.

Harness will now:

1. Start a Harness Cloud build environment
2. Clone the GitHub repository
3. Read the Dockerfile
4. Build the Docker image
5. Authenticate with Docker Hub
6. Tag the image
7. Push the image to Docker Hub

---

## 12. Verify the Image

Open Docker Hub and check:

```text
triple3a/harness-ci-demo
```

You should see the image pushed by Harness CI.

The completed workflow is:

```text
Developer
    │
    ▼
GitHub
    │
    ▼
Harness CI
    │
    ├── Clone Repository
    │
    ├── Build Docker Image
    │
    └── Tag Image
    │
    ▼
Docker Hub
```
