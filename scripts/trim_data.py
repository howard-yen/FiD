import json
import argparse
import os
import random

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="trim FiD training file for debugging.")
    parser.add_argument("--input_file", type=str, default=None)
    parser.add_argument("--size", type=int, default=100)
    parser.add_argument("--seed", type=int, default=20220825)
    args = parser.parse_args()
    random.seed(args.seed)

    with open(args.input_file) as f:
        data = json.load(f)

    with open(f"{args.input_file.replace('.json', '')}_{args.size}.json", "w") as f:
        json.dump(random.sample(data, args.size), f)

    print("done")
