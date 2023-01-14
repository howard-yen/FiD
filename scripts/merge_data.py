import json
import argparse
import os

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="merge FiD input file.")
    parser.add_argument("--dir", type=str, default=None)
    args = parser.parse_args()

    preds = (
        ["train_short.json", "train_medium.json", "train_long.json", "train_yesno.json",],
        ["dev_short.json", "dev_medium.json", "dev_long.json", "dev_yesno.json",],
        ["test_short.json", "test_medium.json", "test_long.json", "test_yesno.json",],
    )
    out_names = ("train_all.json", "dev_all.json", "test_all.json")

    for p, name in zip(preds, out_names):
        output = []
        for s in p:
            with open(os.path.join(args.dir, s)) as f:
                data = json.load(f)
                output += data

        with open(os.path.join(args.dir, name), "w") as f:
            json.dump(output, f)

    print("done")
