# gomgr

gomgr is a binary Golang distribution manager supporting FIPS/BoringCrypto releases.

## Building

First install [`sharg`](github.com/cipherboy/sharg):

```
git clone github.com/cipherboy/sharg
cd shrag && pip install --user -e .
```

Then execute the build script in this repository:

```
./build.py
```

This writes a relocatable shell script to `bin/gomgr`. Dependencies include
`wget`, `sudo`, and `tar` or `zip` with any relevant decompression helpers
for unpacking Go release tarballs

## Usage

Fetching a specific version to the local release cache:

```
gomgr fetch 1.17.6
```

Listing presently cached Go versions:

```
gomgr list
```

Enabling (or disabling) a specific release:

```
gomgr enable 1.17.6
gomgr disable 1.17.6
```

Note that releases must be fetched locally before they can be enabled.

Removing a release from cache:

```
gomgr remove 1.17.6
```

Cleaning `$GOROOT` and associated caches (sometimes useful when debugging
compilation problems):

```
gomgr clean
```
