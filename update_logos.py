#!/usr/bin/env python3
import re

# Read the file
with open('lib/constants.dart', 'r') as f:
    content = f.read()

# Map of channel IDs to their file extensions
jpg_channels = {'live-3', 'live-16', 'live-19', 'live-46'}

# Replace all logoUrl lines
lines = content.split('\n')
new_lines = []
current_id = None

for line in lines:
    # Track current channel ID
    if "id: '" in line:
        match = re.search(r"id: '([^']+)'", line)
        if match:
            current_id = match.group(1)
    
    # Replace logoUrl lines
    if 'logoUrl:' in line and 'https://' in line and current_id:
        ext = '.jpg' if current_id in jpg_channels else '.png'
        new_lines.append(f"    logoUrl: 'assets/images/channels/{current_id}{ext}',")
    else:
        new_lines.append(line)

# Write back
with open('lib/constants.dart', 'w') as f:
    f.write('\n'.join(new_lines))

print('✓ Updated constants.dart with local logo paths')
