### Generate gpg key
```zsh
gpg --full-gen-key
```

### List-public-keys
```zsh
gpg -k
```

### List-secret-keys
```zsh
gpg -K
```

### Encrypt file.txt (-e) in armor format (-a) for recipient (-r) [keyID] with output to file.txt.asc
```zsh
gpg -ear email@email.xyz file.txt
```

### Decrypt (-d) file.txt.asc with output to (-o) file.txt
```zsh
gpg -do file.txt file.txt.asc
```

## Export keys
### Export public key [keyID] in armor format (-a)
```zsh
gpg --export -a email@email.xyz > public.gpg
```

### Export-secret-key [keyID] in armor format (-a)
```zsh
gpg --export-secret-key -a email@email.xyz > secret.gpg
```

### Export-secret-subkeys [keyID] in armor format (-a)
```zsh
gpg --export-secret-subkeys -a email@email.xyz > secret_subs.gpg
```

## Import keys
### Import
```zsh
gpg --import public.gpg
gpg --import secret.gpg
gpg --import secret_subs.gpg
```

## Delete keys
### Delete-keys
```zsh
gpg --delete-keys email@email.xyz
```

### Delete-secret-keys
```zsh
gpg --delete-secret-keys email@email.xyz
```

### Add subkey
```zsh
gpg --expert --edit-key email@email.xyz
addkey
save
```

### Modify expiration date
```zsh
gpg --expert --edit-key email@email.xyz
key 1 # select key 1
expire
key 1 # deselect key 1
save
```
