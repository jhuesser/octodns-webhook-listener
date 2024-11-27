import os
from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)

# Retrieve API key from environment variable
API_KEY = os.getenv('API_KEY')
if not API_KEY:
    raise ValueError("Environment variable 'API_KEY' is not set. Please set it to secure the API.")

@app.before_request
def check_api_key():
    # Check if the API key in the request header matches the environment variable
    if request.headers.get('API-Key') != API_KEY:
        return jsonify({"status": "error", "message": "Unauthorized"}), 403

@app.route('/sync', methods=['POST'])
def sync():
    try:
        # Change working directory to app root
        os.chdir("/opt/octodns-webhook")
        
        # Trigger Octo-DNS sync
        result = subprocess.run(
            ["/opt/octodns-webhook/venv/bin/octodns-sync", "--config-file=./config/config.yaml", "--doit"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        
        if result.returncode == 0:
            return jsonify({"status": "success", "output": result.stdout}), 200
        else:
            return jsonify({"status": "error", "error": result.stderr}), 500

    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
    