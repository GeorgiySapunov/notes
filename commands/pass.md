## Pass
### pass init [keyID]
```zsh
pass init email@email.xyz
```

### List the store tree
```zsh
pass
```

### Insert password
```zsh
pass insert *path/to/data*
```

### Generate a new random password with a given length, and copy it to the clipboard (-c)
```zsh
pass generate -c path/to/data num
```

### Copy gpg key pair to a new machine

https://stackoverflow.com/questions/33361068/gnupg-there-is-no-assurance-this-key-belongs-to-the-named-user

I had the same issue after copying my key pair from one machine to another. The
solution for me was the set the trust level of the keys:

```
gpg --edit-key <KEY_ID>
gpg> trust
```
You will be asked to select the trust level from the following:

```
1 = I don't know or won't say
2 = I do NOT trust
3 = I trust marginally
4 = I trust fully
5 = I trust ultimately
m = back to the main menu
```
I selected 5 since I created the key so of course I trust it ultimately :). It
will ask you to confirm your decision:

```
Your decision? 5
Do you really want to set this key to ultimate trust? (y/N) y
```
After confirming, quit with:

```
gpg> quit
```
You should then be able to encrypt using that key.
