# msbdiff

## Building
You'll need zig (get a master build) and git

Latest tested zig version: `0.11.0-dev.3892+0a6cd257b`, feel free to open an issue if newer versions break

```sh
git submodule init
git submodule update
zig build
```

After that you can find the binary at zig-out/bin/msbdiff, 

Alternatively, run directly with `zig build run`