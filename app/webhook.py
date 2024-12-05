import os
import subprocess
from flask import Flask, request, jsonify

app = Flask(__name__)

# Path where all scripts and configuration files are stored
SOURCE_DIR = "/config"

def list_scripts():
    """Scan the directory for available scripts."""
    return {script: os.path.join(SOURCE_DIR, script) for script in os.listdir(SOURCE_DIR) if os.path.isfile(os.path.join(SOURCE_DIR, script))}

@app.route('/webhook/<script_name>', methods=['GET'])
def webhook(script_name):
    scripts = list_scripts()
    
    # Check if the requested script exists
    if not script_name or script_name not in scripts:
        return jsonify({"error": f"Unknown or missing script: {script_name}"}), 400

    # Parse query parameters for arguments
    script_args = request.args.getlist('arg')  # Expects multiple `arg` parameters

    try:
        script_path = scripts[script_name]
        execute_script(script_path, script_args)
        return jsonify({"status": f"Script {script_name} executed successfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

def execute_script(script_path, args):
    """Execute the specified script with the provided arguments."""
    cmd = ["python", script_path]
    cmd.extend(args)  # Add any arguments passed to the script
    subprocess.run(cmd, check=True)

@app.route('/scripts', methods=['GET'])
def get_available_scripts():
    """Return a list of all available scripts."""
    scripts = list_scripts()
    return jsonify({"scripts": list(scripts.keys())})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
