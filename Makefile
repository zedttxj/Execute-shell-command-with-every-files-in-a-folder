# Define the folder name and the global Python script path
SECURE_FOLDER=secure_folder
GLOBAL_SCRIPT_PATH=/usr/local/bin/execute_command_for_files.py

# Default target
all: create_secure_folder create_python_script set_permissions

# Create a folder and ensure it is secure (no write permission)
create_secure_folder:
	mkdir -p $(SECURE_FOLDER)

# Create the Python script inside the secure folder
create_python_script:
	echo "#!/usr/bin/env python3" > $(SECURE_FOLDER)/execute_command_for_files.py
	echo "import sys" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "import os" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "import subprocess" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "import importlib.util" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "def safe_import(module_name):" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "    if module_name in sys.builtin_module_names:" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "        return __import__(module_name)" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "    sys.path = [p for p in sys.path if not p == '']" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "    try:" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "        spec = importlib.util.find_spec(module_name)" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "        if spec and 'site-packages' not in spec.origin and 'dist-packages' not in spec.origin:" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "            return importlib.util.module_from_spec(spec)" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "        else:" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "            raise ImportError(f'Blocked unsafe import: {module_name}')" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "    except ImportError:" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "        raise ImportError(f'Failed to import: {module_name} from the standard library.')" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "os = safe_import('os')" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "subprocess = safe_import('subprocess')" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "def execute_command_for_files(folder_path, command):" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "    if not os.path.isdir(folder_path):" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "        print(f'Error: {folder_path} does not exist or is not a directory.')" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "        return" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "    for item in os.listdir(folder_path):" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "        item_path = os.path.join(folder_path, item)" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "        if os.path.isdir(item_path):" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "            execute_command_for_files(item_path, command)" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "        elif os.path.isfile(item_path):" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "            full_command = [command, item_path]" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "            try:" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "                result = subprocess.run(full_command, check=True, capture_output=True, text=True, errors='ignore')" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "                print(f'Executed: {full_command}\\nOutput: {result.stdout[:100]}')" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "            except UnicodeDecodeError:" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "                print(f'Skipping non-text file: {item_path}')" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "            except subprocess.CalledProcessError as e:" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "                print(f'Error executing command on {item_path}: {e}')" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "base_folder = '/path/to/your/folder'" >> $(SECURE_FOLDER)/execute_command_for_files.py
	echo "execute_command_for_files(base_folder, 'cat')" >> $(SECURE_FOLDER)/execute_command_for_files.py

	# Make the Python script executable
	chmod +x $(SECURE_FOLDER)/execute_command_for_files.py

	# Make the script global by copying it to /usr/local/bin (requires sudo)
	sudo cp $(SECURE_FOLDER)/execute_command_for_files.py $(GLOBAL_SCRIPT_PATH)

# Set the folder to read-only (no write permissions)
set_permissions:
	chmod -R 555 $(SECURE_FOLDER)

# Clean up (optional)
clean:
	rm -rf $(SECURE_FOLDER)
