#!/usr/bin/env python3
"""Stage the explicitly authorized canonical JPEGs into a local git checkout.

Does not push or commit. LoRA weights are excluded. Requires explicit --confirm-public.
"""
import argparse, hashlib, json, pathlib, shutil, subprocess, sys

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument("--source",required=True,help="Directory containing the original JPEG files")
    p.add_argument("--repo",default=".",help="Existing local checkout of AGinesJr/FZNT-24072006")
    p.add_argument("--confirm-public",action="store_true",help="Acknowledge public GitHub distribution")
    a=p.parse_args()
    if not a.confirm_public: p.error("Use --confirm-public after reviewing the repository's PUBLIC visibility")
    repo=pathlib.Path(a.repo).resolve()
    source=pathlib.Path(a.source).resolve()
    manifest=json.loads((repo/"identity"/"visual"/"assets-manifest.json").read_text(encoding="utf-8"))
    url=subprocess.check_output(["git","-C",str(repo),"remote","get-url","origin"],text=True).strip().lower()
    if "aginesjr/fznt-24072006" not in url: raise RuntimeError("Unexpected git remote: "+url)
    dest=repo/"identity"/"visual"/"assets"
    staged=[]
    for item in manifest["source_assets"]:
        f=source/item["filename"]
        if not f.is_file(): raise FileNotFoundError(str(f))
        if f.stat().st_size!=item["bytes"]: raise RuntimeError("Size mismatch: "+f.name)
        if not hashlib.sha256(f.read_bytes()).hexdigest().startswith(item["sha256_prefix"]): raise RuntimeError("Hash mismatch: "+f.name)
        dest.mkdir(parents=True,exist_ok=True)
        shutil.copy2(f,dest/f.name)
        staged.append(item["repo_path"])
    subprocess.check_call(["git","-C",str(repo),"add","-f","--",*staged])
    print("Staged",len(staged),"canonical JPEGs. Review 'git diff --cached --stat', commit and push manually.")
    print("No LoRA weights staged; no commit or push performed.")
if __name__=="__main__":
    try: main()
    except (OSError,ValueError,RuntimeError,subprocess.CalledProcessError) as e:
        print("ERROR:",e,file=sys.stderr);sys.exit(1)
