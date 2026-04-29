import jenkins.model.*
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition
import hudson.plugins.git.*

def instance = Jenkins.instanceOrNull

sleep(15000)

def jobName = "streamlit-app-deploy"
def job = instance.getItem(jobName)

if (job == null) {
    job = instance.createProject(WorkflowJob, jobName)
}

// FIX: Proper Git SCM with explicit branch
def scm = new GitSCM(
    GitSCM.createRepoList(
        "https://github.com/lavatech321/Containerized_Data_Science_Pipeline.git",
        null
    ),
    [new BranchSpec("*/main")],   // IMPORTANT FIX
    null,
    null,
    []
)

// Jenkinsfile-based pipeline (no script approval required)
def definition = new CpsScmFlowDefinition(scm, "Jenkinsfile")
definition.setLightweight(true)

job.setDefinition(definition)
job.save()

// Auto trigger build safely
if (job != null) {
    job.scheduleBuild2(0)
}

instance.save()

println("✅ Jenkins pipeline created successfully without script approval!")
