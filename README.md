# Execute shell command with every files in a folder
## Overview
The goal is to automate tasks on every files inside a folder recursively and build an ssh tunnel where a client queries a server for information based on names provided. Additionally, it only access to sub directories with appropriate permission.
## Project Details
- Develope a Python automation script to execute commands on files securely.
- Ensured 100% accuracy with fail-secure, fail-safe, fail-open, and fail-closed mechanisms.
- Replaced os.system() with subprocess.run() to prevent security risks.
- Optimized for automation workflows, logging, and bulk file processing.
- Tech Stack: Python, Shell Scripting, Linux, Automation
- Prevented Python Module Hijacking
## Testing with `execute_command_for_files.py` (offline mode)
![{B29FF013-E3C1-495F-9766-1091BAF20C32}](https://github.com/user-attachments/assets/a8a319d2-21bc-4296-a6a7-faf21dbb5111)
![{8D6CA336-FDDD-4761-AC2B-6DDD1A0BF4F2}](https://github.com/user-attachments/assets/d94de11f-8850-4b2e-a83e-1c80adbe4c07)
![{DD6C08F7-D5E3-4BB0-B05B-64844DBC7C48}](https://github.com/user-attachments/assets/20c8943b-d34a-4ea2-a55d-2759893d23cf)
## Testing with `execute_ssh_command.py` (online mode)
![{95EEE5FD-A80F-4E24-ACCE-AE00E5C8A0C7}](https://github.com/user-attachments/assets/3cfda2b8-63ee-4cdb-bc0e-274e1d071e6e)
