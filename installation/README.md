# **installation** folder

This folder contains all scripts needed to build installation pacakages.

The installer for windows is based on InnoSetup (https://jrsoftware.org/isinfo.php)

- compile_all.cmd : Calls delphi commandline interface to compile the project group
- build_setup.cmd : Calls the inno setup commandline compiler to build the setup
- compile_build_all.cmd : Combines both commands to compile the release versions and build the setup
- json2pumlsetup.iss : Inno Setup script for building the setup