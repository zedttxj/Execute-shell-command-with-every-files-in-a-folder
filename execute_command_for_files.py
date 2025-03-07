#!/usr/bin/env python3
import os
import subprocess
import argparse
import logging
import shlex

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def execute_command_for_files(folder_path, command, num_lines=None):
    """Recursively run a shell command on all files in a directory and its subdirectories."""
    # Iterate over each item in the folder
    for item in os.listdir(folder_path):
        item_path = os.path.join(folder_path, item)

        if os.path.isdir(item_path):
            # If the item is a directory, call the function recursively
            execute_command_for_files(item_path, command, num_lines)
        elif os.path.isfile(item_path):
            # If the item is a file, execute the command
            if num_lines:
                # Show exactly 'num_lines' from the file
                try:
                    with open(item_path, 'r', errors='ignore') as f:
                        lines = [next(f) for _ in range(num_lines)]  # Get the specified number of lines
                    logging.info(f"File: {item_path} - Output (first {num_lines} lines):\n{''.join(lines)}")
                except Exception as e:
                    logging.error(f"Error reading file {item_path}: {e}")
            else:
                # Execute the command if not specified to show number of lines
                full_command = shlex.split(command) + [item_path]
                try:
                    result = subprocess.run(full_command, check=True, capture_output=True, text=True, errors="ignore")
                    logging.info(f"Executed: {' '.join(full_command)}\nOutput: {result.stdout[:100]}")  # Limit output length
                except UnicodeDecodeError:
                    logging.warning(f"Skipping non-text file: {item_path}")
                except subprocess.CalledProcessError as e:
                    logging.error(f"Error executing command on {item_path}: {e}")

def main():
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description="Execute shell commands on all files in a directory and its subdirectories.")
    parser.add_argument("folder", help="Path to the folder where the files are located.")
    parser.add_argument("command", help="The shell command to execute on each file (e.g., 'cat').")
    parser.add_argument("num_lines", nargs='?', type=int, default=None, help="The number of lines to print from each file.")
    args = parser.parse_args()

    # Execute command for all files, passing the number of lines argument if present
    execute_command_for_files(args.folder, args.command, args.num_lines)

if __name__ == "__main__":
    main()
