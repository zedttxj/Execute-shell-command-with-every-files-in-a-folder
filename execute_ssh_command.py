import argparse
import paramiko

def execute_ssh_command(host, username, private_key_path, command, timeout=10):
    try:
        # Create the SSH client
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        # Use private key for authentication
        if private_key_path:
            private_key = paramiko.RSAKey.from_private_key_file(private_key_path)
            ssh.connect(host, username=username, pkey=private_key, timeout=timeout)
        else:
            raise ValueError("Private key path must be provided.")

        # Execute the command
        stdin, stdout, stderr = ssh.exec_command(command, timeout=timeout)
        
        # Get the output and handle errors
        output = stdout.read().decode().splitlines()
        error = stderr.read().decode()
        
        ssh.close()

        if error:
            print(f"Error: {error}")
        
        return output
    except Exception as e:
        print(f"Error: {e}")
        return None

def main():
    # Set up argparse
    parser = argparse.ArgumentParser(description='Run an SSH command on a remote server.')
    parser.add_argument("--command", required=True, help="The shell command to execute on each file (e.g., 'cat').")
    parser.add_argument('--host', required=True, help='The SSH host (e.g. example.com)')
    parser.add_argument('--username', required=True, help='The SSH username')
    parser.add_argument('--private-key', required=True, help='The path to the private key file')
    parser.add_argument('--folder-path', required=True, help='The folder path to search files in')
    parser.add_argument('--timeout', type=int, default=10, help='The timeout for the SSH command in seconds')

    # Parse arguments
    args = parser.parse_args()

    # Construct the find command
    command = f"find {args.folder_path} -type f"

    # Execute the SSH command with the provided arguments
    files = execute_ssh_command(args.host, args.username, args.private_key, command, timeout=args.timeout)
    
    if files:
        for i in files:
            print(execute_ssh_command(args.host, args.username, args.private_key, args.command + " " + i, timeout=args.timeout))
    else:
        print("No files found or an error occurred.")

if __name__ == "__main__":
    main()
