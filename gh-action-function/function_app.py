import logging
import json
import azure.functions as func


app = func.FunctionApp()


@app.event_grid_trigger(arg_name="azeventgrid")
def GHCDTrigger(azeventgrid: func.EventGridEvent):
    result = json.dumps({
        'id': azeventgrid.id,
        'data': azeventgrid.get_json(),
        'topic': azeventgrid.topic,
        'subject': azeventgrid.subject,
        'event_type': azeventgrid.event_type,
    })

    # get models map from the MODEL_MAP environment variable
    model_map = json.loads(os.environ["MODEL_MAP"])
    # get the model name from the event subject
    model_name = azeventgrid.subject.split('/')[-1]

    # get the model repo from the model map 
    model_repo = model_map[model_name]

    # send dispatch event to the GHCD
    dispatch_event = {
        "model_name": model_name,
        "model_repo": model_repo,
        "event": azeventgrid.get_json()
    }
    app.send_event(dispatch_event)


    logging.info('Python EventGrid trigger processed an event: %s', result)