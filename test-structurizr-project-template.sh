#!/bin/bash

# Path to the script you want to test
script_path="structurizr-project-template.sh"

# PROJECT_DIR='.'
# PROJECT_DIR='project_name'
PROJECT_DIR='structurizr_project_template'

# Array of available options
options=("-h" "--help" "-p" "--plantuml" "-w" "--workspace" "-d" "--doc" "-x" "--bad" "-c" "--clean")

# test_setup() {
# }

test_teardown() {
    if [ -d "$PROJECT_DIR" ]; then
        rm -rf "$PROJECT_DIR" && echo "Project directory deleted successfully."
    else
        echo "Project directory does not exist."
    fi
    echo -e "\n----------------------------------\n"
}

# Function to test the script with each option
test_option() {
    local option="$1"
    echo "Testing option: $option"
    ./"$script_path" "$option"
    test_teardown
}

# Main function
test() {
    # Run the test script with each option
    for option in "${options[@]}"; do
        test_option "$option"
    done
    # Test NO option provided
    echo "Testing with NO option:"
    ./"$script_path"
    test_teardown
}

# Entry point
test
