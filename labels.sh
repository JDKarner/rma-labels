#!/bin/bash

# CSV output path
csv_file="rma_labels.csv"

# Ask for RMA details
read -p "Enter RMA number: " rma_number
read -p "Enter description of issue: " issue_description
read -p "Enter RMA URL: " rma_url

# Write to CSV
echo "\"$rma_number\",\"$issue_description\",\"$rma_url\"" > "$csv_file"

echo "✅ CSV created: $csv_file"

# gLabels template path
template="rma-tag-v2.glabels"

# Output label file
output_ps="label_output.ps"

# Use glabels-batch to generate label file
if command -v glabels-3-batch &> /dev/null && [ -f "$template" ]; then
    glabels-3-batch -o "$output_ps" -i "$csv_file" "$template"
    echo "🖨️ Label file created: $output_ps"

    # Send label to DYMO printer via CUPS
    lp -d "DYMO_LabelWriter_450_Twin_Turbo" "$output_ps"
    echo "🚀 Label sent to DYMO printer!"
else
    echo "⚠️ Printing failed. Ensure glabels-batch and $template are properly set up."
fi
