import os
import shlex
import subprocess

def execute_command_for_files(folder_path, command):
    """Automates batch command execution on files in a directory securely."""
    if not os.path.isdir(folder_path):
        print("Error: Folder path does not exist.")
        return

    for file_name in os.listdir(folder_path):
        file_path = os.path.join(folder_path, file_name)

        if os.path.isfile(file_path):
            full_command = [command, file_path]  # Prevents shell injection
            try:
                subprocess.run(full_command, check=True, capture_output=True, text=True)
                print(f"Executed: {full_command}")
            except subprocess.CalledProcessError as e:
                print(f"Error executing command on {file_path}: {e.stderr}")

# Example usage:
folder_path = "/path/to/your/folder"
command = "cat"  # Replace with any safe shell command

execute_command_for_files(folder_path, command)
