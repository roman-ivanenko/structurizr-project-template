#!/bin/bash

# PROJECT_DIR='.'
# PROJECT_DIR='project_name'
PROJECT_DIR='structurizr_project_template'

PLANTUML_DIR="$PROJECT_DIR/docs/diagrams"

# Function to display usage
usage() {
    # echo "Usage: $0 [-p|--plantuml] [-w|--workspace] [-d|--doc] [-c|--clean] [-h|--help]"
    echo -e "\nUsage: $0 [OPTION]"
    echo "Options:"
    echo "  -p, --plantuml   Create PlantUML project layout"
    echo "  -w, --workspace  Create Structurizr workspace template"
    echo "  -d, --doc        Generate Structurizr project documentation template"
    echo "  -c, --clean      Clean (delete) project directory"
    echo "  -h, --help       Display this help message"
    echo -e "\nBy default, without any option provided, the script creates both the PlantUML project layout and Structurizr workspace and documentation template.\n"
}

# Create PlantUML Project Layout
# --------------------------
# PROJECT_DIR
# └── docs
#     └── diagrams
#         ├── out
#         └── src
create_plantuml_layout() {
    echo -e "\nCreating PlantUML Project Layout..."
    mkdir -pv $PLANTUML_DIR/{out,src}
    DIAGRAMS_SRC="$_"
    tree "$PROJECT_DIR"
    echo "DIAGRAMS_SRC: $DIAGRAMS_SRC"
}

# Create Structurizr Workspace Template
create_workspace() {
    echo -e "\nCreating Structurizr Workspace Template..."
    if [ -n "$DIAGRAMS_SRC" ]; then
        echo "The variable DIAGRAMS_SRC is defined and its value is: $DIAGRAMS_SRC"
        WORKSPACE_DIR=$DIAGRAMS_SRC
    else
        echo "The variable DIAGRAMS_SRC is not defined or is empty."
        WORKSPACE_DIR=$PROJECT_DIR
    fi
    echo "WORKSPACE_DIR: $WORKSPACE_DIR"
    export WORKSPACE_DIR

    mkdir -pv "$WORKSPACE_DIR"/{styles,themes}
    touch "$WORKSPACE_DIR"/{constants,roles,model,views,workspace}.dsl
    touch "$WORKSPACE_DIR"/styles/styles.dsl
    touch "$WORKSPACE_DIR"/themes/theme.json
    tree "$WORKSPACE_DIR"
    echo "Structurizr Workspace Template generated successfully."
}

# Generate Structurizr documentation template
generate_documentation() {
    echo -e "\nGenerating Structurizr Documentation..."
    if [ ! -d "$PROJECT_DIR" ]; then
        echo "Error: Project directory does not exist."
        echo "Please create the directory or check the path."
        exit 1
    fi

    WORKSPACE_DIR=$PROJECT_DIR
    if [ -d "$PLANTUML_DIR" ]; then
        WORKSPACE_DIR="$PLANTUML_DIR/src"
    fi
    echo "WORKSPACE_DIR: $WORKSPACE_DIR"

    # if [ ! -d "$WORKSPACE_DIR" ]; then
    #     echo "Error: Structurizr Workspace directory does not exist."
    #
    #     exit 1
    # fi

    mkdir -pv "$WORKSPACE_DIR"/{adrs,docs/images}
    touch "$WORKSPACE_DIR"/adrs/architecture-decision-record-0001.md
    touch "$WORKSPACE_DIR"/docs/{context,functional-overview,quality-attributes}.md
    tree "$WORKSPACE_DIR"
    echo "Structurizr Documentation templates generated successfully."
}

# Clean the project directory
clean() {
    echo -e "\nRemoving project directory..."
    if [ -d "$PROJECT_DIR" ]; then
        rm -rf "$PROJECT_DIR" && echo "Project directory deleted successfully."
    else
        echo "Project directory does not exist."
    fi
    tree .
}

# Main function
main() {
    local arg=
    if [ $# -eq 0 ]; then
        create_plantuml_layout
        create_workspace
        generate_documentation
    elif [ "$#" -gt 1 ]; then
        echo "Error: Multiple options provided. Only one option is allowed."
        usage
        exit 1
    else
        arg="$1"
        case "$arg" in
        -p | --plantuml)
            create_plantuml_layout
            ;;
        -w | --workspace)
            create_workspace
            ;;
        -d | --doc)
            generate_documentation
            ;;
        -c | --clean)
            clean
            ;;
        -h | --help)
            usage
            ;;
        *)
            echo "Error: Unknown option '$arg'"
            usage
            exit 1
            ;;
        esac
    fi
}

# Entry point
main "$@"
