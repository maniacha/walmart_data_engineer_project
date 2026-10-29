from databricks.sdk import WorkspaceClient
from databricks.sdk.service.jobs import RunLifeCycleState, RunResultState
import time

ws = WorkspaceClient(
    host="hostname",
    token="token_id"
)

# Trigger the job
job_trigger = ws.jobs.run_now(job_id=497798828204802)

# Wait for completion
while True:

    job_run = ws.jobs.get_run(job_trigger.run_id)

    print(
        f"job run status : {job_run.state.life_cycle_state}, "
        f"result state : {job_run.state.result_state}"
    )

    if job_run.state.life_cycle_state in (
        RunLifeCycleState.TERMINATED,
        RunLifeCycleState.SKIPPED,
        RunLifeCycleState.INTERNAL_ERROR,
    ):

        if job_run.state.result_state == RunResultState.SUCCESS:
            print("Job Completed Successfully!")
            break

        else:
            raise Exception(
                f"job failed with state : {job_run.state.result_state}"
            )

    time.sleep(10)
