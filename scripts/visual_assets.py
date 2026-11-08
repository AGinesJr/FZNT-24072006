#!/usr/bin/env python3
"""Local-only canonical asset inventory. Does not upload, train, or publish."""
import argparse, datetime as dt, hashlib, json, pathlib, shutil, sys
KINDS={"face-front","face-three-quarter","expression-grid","body-front","body-back","outfit-reference"}
ROOT=(pathlib.Path.home()/"AppData"/"Local"/"FayZawn"/"visual-assets") if sys.platform=="win32" else pathlib.Path.home()/".local"/"share"/"FayZawn"/"visual-assets"
def main():
    p=argparse.ArgumentParser(description=__doc__)
    s=p.add_subparsers(dest="cmd",required=True)
    i=s.add_parser("ingest");i.add_argument("--source",required=True);i.add_argument("--kind",required=True,choices=sorted(KINDS))
    s.add_parser("list")
    a=p.parse_args()
    manifest=ROOT/"manifest.json"
    records=json.loads(manifest.read_text(encoding="utf-8")) if manifest.exists() else []
    if a.cmd=="list":
        print(json.dumps(records,indent=2));return
    source=pathlib.Path(a.source).resolve(strict=True)
    if not source.is_file() or source.suffix.lower() not in {".png",".jpg",".jpeg",".webp"}: raise ValueError("Supported local image file required")
    digest=hashlib.sha256(source.read_bytes()).hexdigest()
    dest=ROOT/"originals"/(digest+source.suffix.lower())
    dest.parent.mkdir(parents=True,exist_ok=True)
    if not dest.exists(): shutil.copy2(source,dest)
    if not any(r["sha256"]==digest for r in records):
        records.append({"sha256":digest,"kind":a.kind,"local_file":str(dest),"original_name":source.name,"ingested_at":dt.datetime.now(dt.timezone.utc).isoformat(),"public_release_approved":False})
    manifest.write_text(json.dumps(records,indent=2)+"\n",encoding="utf-8")
    print("Stored locally:",dest,"; public release: NOT APPROVED")
if __name__=="__main__":
    try: main()
    except (OSError,ValueError,json.JSONDecodeError) as e: print("ERROR:",e,file=sys.stderr);sys.exit(1)
