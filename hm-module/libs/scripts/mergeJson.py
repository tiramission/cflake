from pathlib import Path
import json
import json5
import os
import sys


def main(src_path: Path, dst_path: Path, output_file: Path):
    src = {}  # src is optional
    if src_path.exists():
        src: dict = json5.loads(src_path.read_text(encoding='utf-8'))
    # source2 must exist
    assert dst_path.exists(), f"Source file {dst_path} does not exist."
    dst: dict = json.loads(dst_path.read_text(encoding='utf-8'))
    src.update(dst)
    result = json.dumps(src, indent=2, ensure_ascii=False)
    output_file.write_text(result, encoding='utf-8')
    output_file.parent.mkdir(parents=True, exist_ok=True)
    os.chmod(output_file, 0o644)


if __name__ == "__main__":
    assert len(sys.argv) == 4, "Usage: mergeJson.py <src> <dst> <output_file>"
    src = Path(sys.argv[1])
    dst = Path(sys.argv[2])
    output_file = Path(sys.argv[3])
    main(src, dst, output_file)
