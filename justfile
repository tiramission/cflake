f:
        alejandra .

a: f
        git add .

c MSG: a
	git commit -m "{{MSG}}"

r:
        nix repl --extra-experimental-features 'flakes' .
