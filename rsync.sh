#!/bin/bash

# The purpose of this program is to transfer and synchronize the eer images from the mounted device to the HPC workstation.

# Change the following tow paths name before synchronizing!

src_dic="/path to the source_directorary"  
dst_dic="/path to the destination_directorary" 

######

# Check
echo -e "\n\e[31mCheck the paths carefully! \e[0m"
echo -e "\nSource: \e[32m$src_dic\e[0m"
echo -e "\nDestination: \e[32m$dst_dic\e[0m\n"

# Confirm
  read -p "Continue? (Y/N): " confirm
  if [ "$confirm" = "Y" ]; then

# List the number of eer files
eer_count=$(ls "$src_dic"/* | grep -c ".*\.eer")
echo -e "\n\e[32m$eer_count \e[0meer files detected.\n"

# Existed files
existed_count=0

# Get the filename
for file in "$src_dic"/*/*.eer; do
  filename="$(basename "$file")"

  # Count the existed file number
  if [ -f "$dst_dic/$filename" ]; then
    existed_count=$((existed_count + 1))
  fi
done
  echo -e "\e[32m$existed_count \e[0meer files existed.\n"

# Ask user for confirmation to copy the files
  read -p "Do you want to copy the rest $(($eer_count - $existed_count)) files? (Y/N): " confirm
  if [ "$confirm" = "Y" ]; then

# Initialize the count of successfully copied files
eercopied_count=0

# Initialize the count of matching file
matching_file_count=0

# Iterate over all files ending with "eer" in the data path
for file in "$src_dic"/*/*.eer; do
  # Check if the file exists
  if [ ! -f "$file" ]; then
    echo "$file does not exist."
    continue
  fi

  # Get the filename
  filename="$(basename "$file")"

  # Check if the file already exists in the destination directory
  if [ ! -f "$dst_dic/$filename" ]; then
    # If not, copy the file and increment the count
    if (rsync -avrzu --progress "$file" "$dst_dic"); then
      eercopied_count=$((eercopied_count + 1))
    fi
  else
    matching_file_count=$((matching_file_count + 1))
  fi
done

# Output a message once all files have been processed
echo -e "\n\e[31mReport:\e[0m\n"
echo -e "\e[32m$eer_count \e[0meer files detected.\n"
echo -e "\e[32m$matching_file_count \e[0meer files existed.\n"
echo -e "\e[32m$eercopied_count \e[0meer files copied.\n"

# Final output
  if [ $eercopied_count -eq 0 ]; then
    echo -e "No files were copied!\n"
  else
    echo -e "Congrats!\n"
  fi
fi
fi

# THE END
# THANK YOU!
