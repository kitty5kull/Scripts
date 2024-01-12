#!/bin/python

import sys

def main():

    lines = sys.stdin.readlines()
    results = {}

    for line in lines:

        line = line.replace("\r","").strip()

        if len(line) < 5 or not line[:5].isdigit():
            continue

        key = line[10:81]
        value = line[81:].strip().replace(" ", "")

        if key not in results:
            results[key] = []

        results[key].append(value)
            
    # Sort the results dictionary by count in descending order
    sorted_results = sorted(results.items(), key=lambda x: len(x[1]), reverse=True)

    # Print the sorted results
    for key, values in sorted_results[1:]:
        for value in values:
            print(f"{key.strip()}\t{value}")

if __name__ == "__main__":
    main()
