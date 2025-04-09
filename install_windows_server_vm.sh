#!/bin/bash

# VM settings
VM_NAME="WindowsServer2022"
ISO_PATH="$HOME/Downloads/WinServer2022.iso"
VM_FOLDER="$HOME/VirtualBox VMs/$VM_NAME"
VHD_PATH="$VM_FOLDER/$VM_NAME.vdi"

# Create the VM
VBoxManage createvm --name "$VM_NAME" --ostype "Windows2022_64" --register

# Set memory and CPU
VBoxManage modifyvm "$VM_NAME" --memory 4096 --vram 128 --cpus 2 --ioapic on

# Set boot order
VBoxManage modifyvm "$VM_NAME" --boot1 dvd --boot2 disk --boot3 none --boot4 none

# Create a virtual hard disk
VBoxManage createhd --filename "$VHD_PATH" --size 51200 --format VDI

# Attach storage controller
VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 \
  --device 0 --type hdd --medium "$VHD_PATH"

# Attach ISO
VBoxManage storagectl "$VM_NAME" --name "IDE Controller" --add ide
VBoxManage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 0 \
  --device 0 --type dvddrive --medium "$ISO_PATH"

# Set network
VBoxManage modifyvm "$VM_NAME" --nic1 nat

# Start the VM
VBoxManage startvm "$VM_NAME"
