import json
import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert prediction file from DensePhrases to FiD input file.")
    parser.add_argument("--pred_file", type=str, default=None)
    parser.add_argument("--output_file", type=str, default=None)
    args = parser.parse_args()

    with open(args.pred_file) as f:
        data = json.load(f)

    output = []
    for id, ex in data.items():
        # optionally, we can set "target"=ex["answers"][0] instead of randomly sampling from answers for the target
        out = {"id": str(id), "question": ex["question"], "answers": ex["answer"], "ctxs": []}
        out["ctxs"] = [{"title": title[0], "text": text} for title, text in zip(ex["title"], ex["evidence"])]
        output.append(out)

    with open(args.output_file, "w") as f:
        json.dump(output, f)

