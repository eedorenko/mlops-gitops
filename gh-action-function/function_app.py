import logging
import json
import azure.functions as func
import requests
import os


app = func.FunctionApp()


@app.event_grid_trigger(arg_name="azeventgrid")
def GHCDTrigger(azeventgrid: func.EventGridEvent):

    logging.info('Python GHCDTrigger trigger is processing an event: %s', azeventgrid)

    # get models map from the MODEL_MAP environment variable
    model_map = json.loads(os.environ["MODEL_MAP"])
    
    # get the model name from the event subject innthe format models/{modelName}:{modelVersion}
    model_name = azeventgrid.subject.split('/')[-1].split(':')[0]
    # get the model version from the event subject
    model_version = azeventgrid.subject.split('/')[-1].split(':')[1]

    # get the model repo from the model map 
    model_repo = model_map[model_name]

    # compose a request payload in the format required by the GitHub API
    payload = {
        "ref": "main",
        "inputs": {
            "model_version": model_version
        }
    }

    gh_url = f"https://api.github.com/repos/{model_repo}/actions/workflows/ci.yml/dispatches"

    # get the GitHub token from the environment variable
    gh_token = os.environ["GH_TOKEN"]

    headers = {
            "Accept": "application/vnd.github.v3+json",
            "Authorization": f"Bearer {gh_token}"
        }
    # invoke GitHub rrest API to trigger the workflow
    response = requests.post(gh_url, headers=headers, json=payload)

    # check if the request was successful
    if response.status_code != 204:
        logging.error(f"Failed to trigger the workflow: {response.text}")
        return func.HttpResponse(f"Failed to trigger the workflow: {response.text}", status_code=500)
    
    # log the response
    logging.info(response.text)

    