#!/bin/bash

# Neovim Minimal Config Installation Script
# This script helps install the nvim-minimal-config on new machines

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Neovim is installed
check_neovim() {
    print_status "Checking Neovim installation..."
    if ! command -v nvim &> /dev/null; then
        print_error "Neovim is not installed. Please install Neovim first."
        echo "Visit: https://github.com/neovim/neovim/releases"
        exit 1
    fi

    # Check Neovim version
    nvim_version=$(nvim --version | head -n1 | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+')
    print_success "Found Neovim $nvim_version"
}

# Check if git is installed
check_git() {
    print_status "Checking Git installation..."
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi
    print_success "Git is available"
}

# Get Neovim config directory
get_config_dir() {
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Windows
        config_dir="$LOCALAPPDATA/nvim"
    else
        # Unix-like systems
        config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
    fi
    echo "$config_dir"
}

# Backup existing configuration
backup_existing_config() {
    local config_dir="$1"

    if [[ -d "$config_dir" ]]; then
        print_warning "Existing Neovim configuration found at: $config_dir"
        backup_dir="${config_dir}.backup.$(date +%Y%m%d_%H%M%S)"
        print_status "Creating backup at: $backup_dir"
        mv "$config_dir" "$backup_dir"
        print_success "Backup created successfully"
    fi
}

# Install the configuration
install_config() {
    local config_dir="$1"
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    print_status "Installing nvim-minimal-config to: $config_dir"

    # Create config directory
    mkdir -p "$config_dir"

    # Copy configuration files
    cp -r "$script_dir"/* "$config_dir/"

    # Remove the install script from the config directory
    rm -f "$config_dir/install.sh"

    print_success "Configuration files copied successfully"
}

# Clean lazy.nvim data directory (in case of corrupted installation)
clean_lazy_data() {
    print_status "Cleaning lazy.nvim data directory..."

    local data_dir
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        data_dir="$LOCALAPPDATA/nvim-data"
    else
        data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
    fi

    local lazy_dir="$data_dir/lazy"
    if [[ -d "$lazy_dir" ]]; then
        print_warning "Removing existing lazy.nvim installation at: $lazy_dir"
        rm -rf "$lazy_dir"
        print_success "Lazy.nvim data cleaned"
    fi
}

# Test the installation
test_installation() {
    print_status "Testing Neovim configuration..."

    # Test with headless mode first
    if nvim --headless -c "lua print('Config loaded successfully')" -c "qall" 2>/dev/null; then
        print_success "Headless test passed"
    else
        print_warning "Headless test failed, but this might be normal"
    fi

    print_status "Installation complete!"
    echo ""
    echo "Next steps:"
    echo "1. Run 'nvim' to start Neovim"
    echo "2. Lazy.nvim will automatically install plugins on first run"
    echo "3. Run ':checkhealth lazy' to verify the installation"
    echo "4. If you encounter issues, check the troubleshooting guide in README.md"
}

# Main installation process
main() {
    echo "========================================"
    echo "  Neovim Minimal Config Installer"
    echo "========================================"
    echo ""

    # Check prerequisites
    check_neovim
    check_git

    # Get configuration directory
    config_dir=$(get_config_dir)
    print_status "Target configuration directory: $config_dir"

    # Ask for confirmation
    echo ""
    read -p "Do you want to proceed with the installation? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Installation cancelled"
        exit 0
    fi

    # Backup existing config
    backup_existing_config "$config_dir"

    # Clean lazy.nvim data if requested
    echo ""
    read -p "Do you want to clean existing lazy.nvim data? (recommended for fresh install) (Y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        clean_lazy_data
    fi

    # Install configuration
    install_config "$config_dir"

    # Test installation
    test_installation

    print_success "Installation completed successfully!"
}

# Run main function
main "$@"

