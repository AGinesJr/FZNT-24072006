#!/usr/bin/env python3
"""Offline, dependency-free fashion catalog; never scrapes, buys, or uploads."""
import argparse, datetime as dt, json, pathlib, re, sys
from urllib.parse import urlparse

ROOT = pathlib.Path.home() / "AppData" / "Local" / "FayZawn" if sys.platform == "win32" else pathlib.Path.home() / ".local" / "share" / "FayZawn"
DB = ROOT / "fashion" / "catalog.json"
REQUIRED = ("id","name","brand","retailer","url","price","currency","observed_at","category")

def validate(item):
    missing = [k for k in REQUIRED if k not in item]
    if missing: raise ValueError("Missing: " + ", ".join(missing))
    if not isinstance(item["id"], str) or not re.fullmatch(r"[a-zA-Z0-9_.-]{1,100}",item["id"]): raise ValueError("Invalid id")
    u=urlparse(item["url"])
    if u.scheme != "https" or not u.netloc: raise ValueError("Product URL must be https")
    if type(item["price"]) not in (int,float) or item["price"] < 0: raise ValueError("Invalid price")
    if not re.fullmatch(r"[A-Z]{3}",item["currency"]): raise ValueError("Currency must be ISO-style 3-letter uppercase code")
    if not all(isinstance(item[k],str) and item[k].strip() for k in ("name","brand","retailer","category")): raise ValueError("Missing text fields")
    stamp=dt.datetime.fromisoformat(item["observed_at"].replace("Z","+00:00"))
    if stamp.tzinfo is None: raise ValueError("observed_at must include timezone")
    if stamp > dt.datetime.now(dt.timezone.utc) + dt.timedelta(minutes=5): raise ValueError("Future observation timestamp")
    return item

def load():
    if not DB.exists(): return []
    data=json.loads(DB.read_text(encoding="utf-8"))
    if not isinstance(data,list): raise ValueError("Catalog must be a list")
    return data

def save(items):
    DB.parent.mkdir(parents=True,exist_ok=True)
    temp=DB.with_suffix(".tmp")
    temp.write_text(json.dumps(items,indent=2,ensure_ascii=False)+"\n",encoding="utf-8")
    temp.replace(DB)

def main():
    p=argparse.ArgumentParser(description=__doc__)
    sub=p.add_subparsers(dest="cmd",required=True)
    add=sub.add_parser("add");add.add_argument("--file",required=True)
    sub.add_parser("list");sub.add_parser("verify")
    args=p.parse_args()
    items=load()
    if args.cmd=="add":
        obj=validate(json.loads(pathlib.Path(args.file).read_text(encoding="utf-8")))
        items=[x for x in items if x["id"]!=obj["id"]]+[obj]
        save(items);print("Saved",obj["id"],"to",DB)
    elif args.cmd=="list":
        for x in items: print(f'{x["id"]}: {x["brand"]} {x["name"]} — {x["price"]} {x["currency"]} (observed {x["observed_at"]})')
    else:
        for x in items: validate(x)
        print(f"{len(items)} catalog entries validated (offline schema checks only; not live price verification)")
if __name__=="__main__":
    try: main()
    except (ValueError,OSError,json.JSONDecodeError) as e: print("ERROR:",e,file=sys.stderr);sys.exit(1)
