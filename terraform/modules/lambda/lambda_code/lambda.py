import json

def lambda_handler(event, context):
    print(event)
    decodedBody = json.loads(event['body'])
    print("Body received and decoded")
    print(decodedBody)
    if (decodedBody['Title'] == 'Document'):
        # If I received what I wanted, then...
        return {
                "statusCode": 200,
                "headers": {
                    "Content-Type": "application/json"
                    # 'Access-Control-Allow-Origin': '*'
                },
                "body": json.dumps({
                    "success": True,
                    "Event json received": event
                }),
                "isBase64Encoded": False
            }
    else:
        return {
                "statusCode": 500,
                "headers": {
                    "Content-Type": "application/json"
                    # 'Access-Control-Allow-Origin': '*'
                },
                "body": json.dumps({
                    "success": False,
                    "Event json received": event
                }),
                "isBase64Encoded": False
            }
