# quiz App

A Flutter quiz app.

## Notes:

This app is hosted by Firebase.

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)
- [Steps to activate firebase and use it to host site](https://medium.com/flutter/must-try-use-firebase-to-host-your-flutter-app-on-the-web-852ee533a469)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Additional code for emailer in AWS Lambda

lambda_function.py

```
# using Python 3.6 runtime

# Python 3.6 runtime

import json
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail

def lambda_handler(event, context):

    method = event.get('httpMethod',{})

    headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Origin, X-Requested-With, Content-Type, Accept',
        'Access-Control-Allow-Methods': '*',
        'Access-Control-Max-Age': '2592000',
        'Access-Control-Allow-Credentials': 'true'
    }
    if method == 'POST':
        message = Mail(
            from_email='from_email@example.com',
            to_emails=<<YOUR EMAIL>>,
            subject=event['body'],
            html_content='<strong>and easy to do anywhere, even with Python</strong>')
        try:
            sg = SendGridAPIClient(<<YOUR API KEY>)
            response = sg.send(message)
        except Exception as e:
            print(str(e))
        return {
            "statusCode": 200,
            "headers": headers,
            "body": 'hi'
        }

    # Below is most important part to handle CORS - this part talks to preflight request from browser
    return {
        "statusCode": 200,
        "headers": headers,
        "body": 'hi'
        }
```

requirements.txt

```
sendgrid
```

template.yaml

```
AWSTemplateFormatVersion: "2010-09-09"
Transform: AWS::Serverless-2016-10-31
Description: >

Sample SAM Template for lambda function that sends emails

# More info about Globals: https://github.com/awslabs/serverless-application-model/blob/master/docs/globals.rst

Globals:
Function:
Timeout: 30

Resources:
minimalCode:
Type: AWS::Serverless::Function # More info about Function Resource: https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md#awsserverlessfunction
Properties: # set codeUri to nothing if lambda_function.py is in root directory # if for instance, lambda_function.py in function folder, set codeUri to function/
CodeUri: ""
Handler: lambda_function.lambda_handler
Runtime: python3.6
MemorySize: 1024
Events:
minimalCodeApi:
Type: Api # More info about API Event Source: https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md#api
Properties:
Path: /
Method: ANY
```
