import subprocess
import time #1
import requests

def run_command(command, cwd=None):
    """Waking up: Helper function to run system commands"""
    print(f"Running: {command}")
    result = subprocess.run(command, shell=True, cwd=cwd)
    if result.returncode != 0:
        print(f"Error: {command}")
        exit(1)

run_command("localstack start -d")

HEALTH_URL = "http://localhost:4566/_localstack/health"
print("Waiting for: Localstack to run")

attempts = 0
max_attempts = 30

while attempts < max_attempts:
    try:
        response = requests.get(HEALTH_URL, timeout=2)
        if response.status_code == 200:
            health_data = response.json()
            s3_status = health_data.get("services", {}).get("s3", "")
            if s3_status in ["available", "running"]:
                print(f"Localstack is ready to setup buckets. Status is: {s3_status}")
                break
            else:
                print("Localstack is up but buckets are not ready yet")

    except requests.exceptions.ConnectionError:
        pass

    attempts += 1
    print(f"Attempt number: {attempts}. LocalStack is getting ready")
    time.sleep(1)

else:
    print("LocalStack had some trouble while getting ready")
    exit(1)

project_dir = "aws_local/02_s3_static_website"
run_command("terraform init", cwd="/home/glitch/devopsjourney/aws_local/02_s3_static_website")
run_command("terraform apply -auto-approve", cwd="/home/glitch/devopsjourney/aws_local/02_s3_static_website")