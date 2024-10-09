#!/usr/bin/env sh

# Function to remove Ansible
remove_ansible() {
    echo "Removing Ansible..."
    sudo apt-get remove --purge -y ansible
    sudo apt-add-repository --remove ppa:ansible/ansible -y
    sudo apt-get autoremove -y
    sudo apt-get clean
    echo "Ansible removed."
}

# Function to backup Semaphore config
backup_semaphore_config() {
    echo "Backing up Semaphore config..."

    # Create backup directory in home location
    BACKUP_DIR="$HOME/semaphore_backup"
    mkdir -p "$BACKUP_DIR"

    # Copy semaphore config to backup directory
    if [ -d /etc/semaphore ]; then
        sudo cp -r /etc/semaphore/* "$BACKUP_DIR"
        echo "Semaphore config backed up to $BACKUP_DIR."
    else
        echo "No Semaphore config found to backup."
    fi
}

# Function to remove Semaphore
remove_semaphore() {
    echo "Removing Semaphore..."

    # Stop Semaphore service if running
    sudo systemctl stop semaphore.service || echo "Semaphore service not running."
    sudo systemctl disable semaphore.service

    # Remove Semaphore binaries and config
    sudo apt-get remove --purge -y semaphore
    sudo rm -rf /etc/semaphore
    sudo rm -rf /var/lib/semaphore
    sudo rm -f /etc/systemd/system/semaphore.service

    # Clean up the system
    sudo apt-get autoremove -y
    sudo apt-get clean

    echo "Semaphore removed."
}

# Execute removal functions
backup_semaphore_config
remove_ansible
remove_semaphore

echo "Clean removal of Ansible and Semaphore completed."