import pymupdf4llm
import sys
from pathlib import Path

pdf_path = sys.argv[1]
output_path = Path(pdf_path).with_suffix(".md")

md_text = pymupdf4llm.to_markdown(pdf_path)

output_path.write_text(md_text, encoding="utf-8")
print(f"Готово: {output_path}")
