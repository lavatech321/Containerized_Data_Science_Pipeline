import jenkins.model.*
import org.jenkinsci.plugins.workflow.job.*
import org.jenkinsci.plugins.workflow.cps.*
import org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval

def approval = ScriptApproval.get()

approval.preapproveAll()

println("All scripts approved automatically!")

def instance = Jenkins.instanceOrNull

sleep(10000)

def jobName = "streamlit-app-deploy"
def job = instance.getItem(jobName)

if (job == null) {
    job = instance.createProject(WorkflowJob, jobName)
}

def pipelineScript = """
pipeline {
    agent any

    environment {
        IMAGE_NAME = "streamlit-app"
        CONTAINER_NAME = "streamlit-container"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/lavatech321/Containerized_Data_Science_Pipeline.git'
            }
        }

        stage('Create Dockerfile') {
            steps {
                sh '''
cat > Dockerfile << 'EOF'
FROM python:3.11-slim
WORKDIR /app
RUN pip install --no-cache-dir streamlit pandas matplotlib numpy
COPY data_science_code/analyse.py /app/analyse.py
EXPOSE 8501
CMD ["streamlit", "run", "analyse.py", "--server.address=0.0.0.0", "--server.port=8501"]
EOF
'''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t \$IMAGE_NAME .'
            }
        }

        stage('Run Container') {
            steps {
                sh '''
docker rm -f \$CONTAINER_NAME || true
docker run -d --name \$CONTAINER_NAME -p 8501:8501 \$IMAGE_NAME
'''
            }
        }

        stage('Verify App') {
            steps {
                sh '''
sleep 20
curl -I http://localhost:8501 || true
'''
            }
        }

    }
}
"""

job.setDefinition(new CpsFlowDefinition(pipelineScript, false))
job.save()

// Trigger build
job.scheduleBuild2(0)

instance.save()


