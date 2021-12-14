#!/usr/bin/env python3
from flask import Flask
from flask import request
import json

app = Flask(__name__)

@app.route('/', methods=["POST"])
def recv():
    request_body = json.loads(request.data)
    print(request_body)

    return '{"resp": "OK"}'

def main():
    app.run(host="0.0.0.0", port=8080)

if __name__ == "__main__":
    main()