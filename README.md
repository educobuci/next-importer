# Installation -- Setting up the environment

This guide is made for linux or unix so we officialy don't support this importer on windows

## Installing the Nero AAC encoder:

* 1) Download the files from the Nero website, and unpack them into the /usr/bin/nero_aac 

* 2) Edit your /etc/bash.bashrc and include at the end of the file this expression: PATH="$PATH":/usr/bin/nero_aac

* 3) Rename the neroAacDec, neroAacEnc and neroAacTag to neroaacdec, neroaacenc and neroaactag because linux systems are case sensitive


