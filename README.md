# build `Tcl.framework`

## Motivation

Build Tcl as framework for macOS.

## Building

You can run `build.sh` to build this locally. The workflow `build.yml` only provides automation around that.

There's only one special (and optional) feature here: since I usually target older macOS versions, the build process checks for the environment variable `SDKROOT` and will configure itself accordingly. For GitHub CI, you can set a repository secret `SDK_DOWNLOAD_URL` and point it to a `.tar.xz` file that contains the desired SDK.

## Download

See the releases page.

## License

[MIT](LICENSE)
