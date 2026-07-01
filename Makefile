build:
	nix-build _build.nix
	mv _site/.git _tmp
	rm -rf _site/
	mkdir _site
	cp -r result/* _site
	cp -r result/.* _site
	mv _tmp _site/.git

trace:
	nix-build _build.nix --show-trace

serve:
	python3 -m http.server 8000 --directory ./_site
