#!/usr/bin/env bash

# Function to print in green
print_green() {
    echo -e "\e[32m$1\e[0m"
}

# Function to print in red
print_red() {
    echo -e "\e[31m$1\e[0m"
}

# Function to print messages with color
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${reset}"
}

# Check if Zsh is available, if not, use Bash
if command -v zsh &>/dev/null; then
    profile_shell=".zshrc"
    print_message "\e[1;34m" "Zsh detected. Using Zsh configuration."
else
    profile_shell=".bashrc"
    print_message "\e[1;34m" "Zsh not detected. Using Bash configuration."
fi

# Check if Golang path is already set
if grep -q "GOROOT" "$HOME/$profile_shell"; then
    print_green "Golang path is already set in $profile_shell."
    # Verify Golang installation
    if command -v go &>/dev/null && go version | awk '{print $3}' | grep -q '^go'; then
        installed_version=$(go version | awk '{print $3}')
        print_green "Golang ${installed_version} is already installed and updated."
    else
        print_red "Golang installation is not valid. Proceeding with installation."
        install_golang=true
    fi
else
    install_golang=true
fi

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    echo "Docker is already installed."
else
    # Download and install Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
fi

# Install Golang if needed
if [ "$install_golang" = true ]; then
    # Determine OS and Architecture
    os=$(uname -s | tr '[:upper:]' '[:lower:]')
    arch=$(uname -m | tr '[:upper:]' '[:lower:]')

    # Set Golang version and URL based on architecture
    case $arch in
        "aarch64" | "arm64") arch_suffix="arm64" ;;
        "x86_64") arch_suffix="amd64" ;;
        "x86") arch_suffix="386" ;;
        "armv6") arch_suffix="armv6l" ;;
        *)
            print_red "Unsupported architecture: $arch"
            exit 1
            ;;
    esac

    version="go1.21.6"  # Change the version as needed
    go_url="https://golang.org/dl/${version}.${os}-${arch_suffix}.tar.gz"

    print_message "\e[1;34m" "Running: Installing/Updating Golang for $arch"

    # Download and install Golang using wget
    if wget "$go_url" -O /tmp/golang.tar.gz && tar -C /usr/local -xzf /tmp/golang.tar.gz; then

        # Set environment variables only if not already set
        if ! grep -q "GOROOT" "$HOME/$profile_shell"; then
            export GOROOT=/usr/local/go
            export GOPATH=$HOME/go
            export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH

            # Add Golang vars to the user's profile
            cat << EOF >> "$HOME/$profile_shell"
# Golang vars
export GOROOT=/usr/local/go
export GOPATH=\$HOME/go
export PATH=\$GOPATH/bin:\$GOROOT/bin:\$HOME/.local/bin:\$PATH
EOF
        fi

        print_green "Golang ${version} has been installed and configured for $arch."
        print_red "Please restart your shell or run 'source ~/$profile_shell' to apply changes."

        # Remove the temporary tar file
        rm -f /tmp/golang.tar.gz
    else
        print_red "Failed to install Golang. Please install it manually."
        exit 1
    fi
fi


currentDir=$(pwd)

# main directory created
mainDir="$currentDir/netraX"
if [ -d "$mainDir" ]; then
    print_green "NetraX already exists at $mainDir"
else
    mkdir "$mainDir"
    print_red "NetraX created at $mainDir"
fi

# subdirectory frontend created
front="$mainDir/frontend"
if [ -d "$front" ]; then
    print_green "Frontend already exists at $front"
else
    mkdir "$front"
    print_red "Frontend created at $front"
fi

# subdirectory scripts created
logic="$mainDir/scripts"
if [ -d "$logic" ]; then
    print_green "Scripts already exists at $logic"
else
    mkdir "$logic"
    print_red "Scripts created at $logic"
fi

# subdirectory results created
results="$mainDir/results"
if [ -d "$results" ]; then
    print_green "Results already exists at $results"
else
    mkdir "$results"
    print_red "Results created at $results"
fi

# Create bbot folder to store its results
bbot_results="$results/bbot"
if [ -d "$bbot_results" ]; then
    print_green "bbot results directory already exists at $bbot_results"
else
    mkdir "$bbot_results"
    print_red "bbot results directory created at $bbot_results"
fi

# Create mobile folder to store its results
mobile_results="$results/mobile"
if [ -d "$mobile_results" ]; then
    print_green "Mobile results directory already exists at $mobile_results"
else
    mkdir "$mobile_results"
    print_red "Mobile results directory created at $mobile_results"
fi

# Create pdf folder to store its results
pdf_results="$results/pdf"
if [ -d "$pdf_results" ]; then
    print_green "pdf results directory already exists at $pdf_results"
else
    mkdir "$pdf_results"
    print_red "pdf results directory created at $pdf_results"
fi

# subdirectory resources created
res="$mainDir/resources"
if [ -d "$res" ]; then
    print_green "Resources already exists at $res"
else
    mkdir "$res"
    print_red "Resources created at $res"
fi

# APIFactory folder conraining all API's JSON
resAPI="$mainDir/resources/APIFactory"
if [ -d "$resAPI" ]; then
    print_green "APIFactory already exists at $resAPI"
else
    mkdir "$resAPI"
    print_red "APIFactory created at $resAPI"
fi

# Check if mobile directory exists
mobileDir="$mainDir/resources/mobile"
if [ -d "$mobileDir" ]; then
    print_green "Mobile directory already exists at $mobileDir"
else
    # Create mobile directory
    mkdir "$mobileDir"
    print_red "Mobile directory created at $mobileDir"
fi

# Dummy Directory path
dummyDir="$mainDir/resources/mobile/dummy"

# Check if dummy directory exists
if [ -d "$dummyDir" ]; then
    print_green "Dummy directory already exists at $dummyDir"
else
    # Create dummy directory
    mkdir -p "$dummyDir"
    print_red "Dummy directory created at $dummyDir"
fi
# Create Modules in Scripts Folder

# OSINT
osint_dir="$logic/osint"
if [ -d "$osint_dir" ]; then
    print_green "OSINT directory already exists at $osint_dir"
else
    mkdir "$osint_dir"
    print_red "OSINT created at $osint_dir"
fi

# recon
recon_dir="$logic/recon"
if [ -d "$recon_dir" ]; then
    print_green "RECON directory already exists at $recon_dir"
else
    mkdir "$recon_dir"
    print_red "RECON created at $recon_dir"
fi

# enum
enum_dir="$logic/enum"
if [ -d "$enum_dir" ]; then
    print_green "ENUM directory already exists at $enum_dir"
else
    mkdir "$enum_dir"
    print_red "ENUM created at $enum_dir"
fi

# vulnscan
vulnscan_dir="$logic/vulnscan"
if [ -d "$vulnscan_dir" ]; then
    print_green "Vulnscan directory already exists at $vulnscan_dir"
else
    mkdir "$vulnscan_dir"
    print_red "Vulnscan created at $vulnscan_dir"
fi

# exploitation
exploit_dir="$logic/exploit"
if [ -d "$exploit_dir" ]; then
    print_green "Exploit directory already exists at $exploit_dir"
else
    mkdir "$exploit_dir"
    print_red "Exploit created at $exploit_dir"
fi

# API Module
api_dir="$logic/api"
if [ -d "$api_dir" ]; then
    print_green "API  directory already exists at $api_dir"
else
    mkdir "$api_dir"
    print_red "API Directory created at $api_dir"
fi


# Function to check if a command is available
check_command() {
    command -v "$1" >/dev/null 2>&1 || return 1
    return 0
}

# Check and install Python 3
if check_command "python3"; then
    print_green "Python 3 is already installed."
else
    sudo apt-get install python3
fi

# Check and install pip
if check_command "pip3"; then
    print_green "pip3 is already installed."
else
    sudo apt-get install python3-pip
fi

# Install Holehe tool for social media account checks from company email.
if check_command "holehe"; then
    print_green "Holehe is already installed."
else
    pip3 install holehe
fi

# Install bbot OSINT TOOL
if check_command "bbot"; then
    print_green "bbot is already installed."
else
    pip3 install bbot
fi

# Install jq
if check_command "jq"; then
    print_green "jq is already installed."
else
    apt install jq -y
fi


# Install chromium
if check_command "chromium"; then
    print_green "chromium is already installed."
else
    apt install chromium -y
fi


# Install nodejs
if check_command "nodejs"; then
    print_green "nodejs is already installed."
else
    apt install nodejs -y
fi

# Install npm
if check_command "npm"; then
    print_green "npm is already installed."
else
    apt install npm -y
fi

# Install EmailFinder for public emails find
emailfinder_dir="EmailFinder"
if [ -d "$emailfinder_dir" ] && check_command "emailfinder"; then
    print_green "EmailFinder is already cloned & Installed"
else
    print_red "Cloning EmailFinder..."
    git clone https://github.com/Raiders0786/EmailFinder
    cd "$emailfinder_dir" || exit 1
    pip3 install -r requirements.txt
    python3 setup.py install
    cd ..
    # Remove EmailFinder directory post-installation
    print_red "Removing EmailFinder directory..."
    rm -rf "$emailfinder_dir"
fi

bucket_brute_py="$mainDir/resources/gcpbucketbrute.py"

#Install GCPBucketbrute
bucketbrute_dir="GCPBucketBrute"
if [ -d "$bucketbrute_dir" ] && check_command "python3 $bucket_brute_py"; then
    print_green "GCPBucketBrute is already cloned & Installed"
else
    print_red "Cloning GCPBucketBrute."
    git clone https://github.com/RhinoSecurityLabs/GCPBucketBrute.git
    cd "$bucketbrute_dir" || exit 1
    pip3 install -r requirements.txt
    cp gcpbucketbrute.py $bucket_brute_py
    cd ..
    # Remove GCPbucketbrute directory post-installation
    print_red "Removing GCPBucketbrute directory..."
    rm -rf "$bucketbrute_dir"
fi

# Add Postman to Swagger Collection Python Script
res="$mainDir/resources"
scriptName="posToSwagger.py"

# Check if the script already exists
if [ -e "$res/$scriptName" ]; then
    print_green "PostToSwagger Script already exists."
else
    # Download the script using curl
    curl https://raw.githubusercontent.com/Raiders0786/PosToSwagger/main/posToSwagger.py  -o "$res/$scriptName"

    # Check if the download was successful
    if [ $? -eq 0 ]; then
        echo "Installing PosToSwagger Script..."
        print_green "Done! PosToSwagger Script is installed in $res/"
    else
        print_red "Error installing PosToSwagger Script. Please check your internet connection and try again."
    fi
fi

# Specify the package name
packageName="offat"

# Check if the package is already installed
if python -c "import $packageName" 2>/dev/null; then
    print_green "$packageName is already installed."
else
    # Install the package using pip
    python -m pip install $packageName

    # Check if the installation was successful
    if [ $? -eq 0 ]; then
        echo "Installing $packageName..."
        print_green "Done! $packageName is installed."
    else
        print_red "Error installing $packageName. Please check your internet connection and try again."
    fi
fi

# Check if wkhtmltopdf is installed
if ! command -v wkhtmltopdf &> /dev/null; then
    echo "Installing wkhtmltopdf..."
    sudo apt-get update
    sudo apt-get install -y wkhtmltopdf
else
    echo "wkhtmltopdf is already installed."
fi

# Check if pdfkit is installed
if ! command -v pip &> /dev/null; then
    echo "pip is not installed. Please install pip to continue."
    exit 1
fi

if ! pip show pdfkit &> /dev/null; then
    echo "Installing pdfkit..."
    pip install pdfkit
else
    echo "pdfkit is already installed."
fi


# Check if mobsf Docker image is already pulled
if docker inspect opensecurity/mobile-security-framework-mobsf:latest &> /dev/null; then
    echo "Mobile Security Framework (MobSF) Docker image is already pulled."
else
    # Pull the mobsf Docker image
    docker pull opensecurity/mobile-security-framework-mobsf:latest
fi

# Check if slack_sdk is already installed
if python3 -c "import slack_sdk" &> /dev/null; then
    echo "slack_sdk is already installed."
else
    # Install slack_sdk
    pip3 install slack_sdk
fi

# Run MobSF container
#docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest
