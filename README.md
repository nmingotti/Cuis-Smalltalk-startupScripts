# Cuis-Smalltalk-startupScripts
A few scripts I use to start Cuis in the way i like

###  How to use it
* I call **cuis-project** the directory containing *Cuis-Smalltalk-Dev*.
* Clone this repository in the directory **cuis-project**
* enter the directory just cloned and run `./makeLinks.sh`
* Now in **cuis-project** you will have two links to scripts to run Cuis conveniently.

## Important Notes 
* This configuration makes use of **hard links**, it will work on Unix like system but not on Windows.
* Emacs by defaul breaks hard links, see [here](https://emacs.stackexchange.com/questions/4237/how-to-prevent-emacs-from-breaking-hard-links), to fix it put this in you `~/.emacs`:
```
(setq backup-by-copying-when-linked t)
```

