# build Tcl/Tk frameworks

## Motivation

Build [Tcl/Tk](https://www.tcl.tk) as frameworks for macOS.

## Building

You can run `1-build_tcl.sh` and `2-build_tk.sh` to build this locally. The workflow `build.yml` only provides automation around that.

There's only one special (and optional) feature here: since I usually target older macOS versions, the build process checks for the environment variable `SDKROOT` and will configure itself accordingly. For GitHub CI, you can set a repository secret `SDK_DOWNLOAD_URL` and point it to a `.tar.xz` file that contains the desired SDK.

## Download

See the releases page.

## License

This work is licensed under [MIT](LICENSE).

[Tcl/Tk](https://www.tcl.tk) is licensed under [Tcl/Tk License Terms](https://www.tcl.tk/software/tcltk/license.html).
