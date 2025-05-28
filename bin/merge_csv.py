import csv
import sys
import os

def merge_columns(input_file, output_file, col1_num, col2_num):
    # Adjust for 0-based indexing
    col1_idx = col1_num - 1
    col2_idx = col2_num - 1

    with open(input_file, 'r', newline='', encoding='utf-8') as infile, \
         open(output_file, 'w', newline='', encoding='utf-8') as outfile:
        
        reader = csv.reader(infile)
        writer = csv.writer(outfile)
        
        header = next(reader)
        # Name for the new merged column
        merged_col_name = f"{header[col1_idx]}-{header[col2_idx]}"
        # Write new header with merged column at the end
        writer.writerow(header + [merged_col_name])
        
        for row in reader:
            # Protect against rows that might be shorter than header
            if len(row) < max(col1_idx, col2_idx) + 1:
                merged_value = ""
            else:
                merged_value = f"{row[col1_idx]};{row[col2_idx]}"
            writer.writerow(row + [merged_value])

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python merge_columns.py <col1_num> <col2_num> <input_file.csv>")
        sys.exit(1)
    
    try:
        col1_num = int(sys.argv[1])
        col2_num = int(sys.argv[2])
        input_file = sys.argv[3]
        base_name = os.path.basename(input_file)
        output_file = f"merged_{base_name}"
        merge_columns(input_file, output_file, col1_num, col2_num)
        print(f"Merged file saved as {output_file}")
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

