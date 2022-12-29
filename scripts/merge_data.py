import json
import argparse
import os

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="merge FiD input file.")
    parser.add_argument("--dir", type=str, default=None)
    args = parser.parse_args()

    preds = (
        ["train_1.json", "train_2.json", "train_3.json", "train_4.json",],
        ["dev_1.json", "dev_2.json", "dev_3.json", "dev_4.json",],
        ["test_1.json", "test_2.json", "test_3.json", "test_4.json",],
    )
    out_names = ("train.json", "dev.json", "test.json")

    for p, name in zip(preds, out_names):
        output = []
        for s in p:
            with open(os.path.join(args.dir, s)) as f:
                data = json.load(f)
                output += data

        with open(os.path.join(args.dir, name), "w") as f:
            json.dump(output, f)

    print("done")
