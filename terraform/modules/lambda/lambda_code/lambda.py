import json
import boto3
import datetime

def lambda_handler(event, context):
    decodedBody = json.loads(event['body'])

    status = True
    message = "JSON saved successfully"
    # Validate json
    # Check for Title
    if ("Title" not in decodedBody.keys()):
        message = "'Title' key is missing from the json"
        status = False
    elif (decodedBody["Title"] == ""):
        message = "'Title' value is missing from the json"
        status = False
    # Check for Author
    if ("Author" not in decodedBody.keys()):
        message = "'Author' key is missing from the json"
        status = False
    elif (decodedBody["Author"] == ""):
        message = "'Author' value is missing from the json"
        status = False
    # Check for Subject
    if ("Subject" not in decodedBody.keys()):
        message = "'Subject' key is missing from the json"
        status = False
    elif (decodedBody["Subject"] == ""):
        message = "'Subject' value is missing from the json"
        status = False
    
    if (status):    
        # Replace title's spaces with underscore for structured filename purposes
        title = decodedBody["Title"].replace(" ","_")

        # S3 Bucket info 
        bucket_name = "s3filestorage1106"
        # Save file in a new folder for each day
        file_name = title + ".json"
        current_date = datetime.datetime.today().strftime('%d_%m_%Y')
        s3_path = current_date + "/" + file_name

        # Save received json to S3 bucket
        s3_resource = boto3.resource("s3")
        s3_client = boto3.client("s3")
        
        # Check if a file has already been submitted today
        response = s3_client.list_objects_v2(Bucket="s3filestorage1106")
        if "Contents" in response:
            s3_files = response["Contents"]
            dates_that_exist = [d["Key"].split("/")[0] for d in s3_files]
            
            if (current_date in dates_that_exist):
                message = "Only one file per day is permitted. Try again tomorrow!"
                status = False
            else:
                s3_resource.Bucket(bucket_name).put_object(Key = s3_path, Body = json.dumps(decodedBody))
        else:
            s3_resource.Bucket(bucket_name).put_object(Key = s3_path, Body = json.dumps(decodedBody))

    return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json"
                # 'Access-Control-Allow-Origin': '*'
            },
            "body": json.dumps({
                "success": status,
                "Filed saved to S3": status,
                "Message": message
            }),
            "isBase64Encoded": False
    }


