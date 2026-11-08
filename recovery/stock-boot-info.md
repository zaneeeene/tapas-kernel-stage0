# Stock boot images (verified)

Location used: `/home/Gold/Downloads/StockBootImages/` — **not** an `hmos2tapas` copy.

## boot.img

| Field | Value |
|---|---|
| Size | 100,663,296 bytes (96 MiB) |
| SHA-256 | `816029b9afac6adb640195e35f4bcea5f6f844eabea1c31115892525c2d0ac2b` |
| Magic | `ANDROID!` |
| Header version | 4 |
| Kernel size | 47,577,600 bytes |
| Ramdisk size | 0 (ramdisk lives in `init_boot`/`vendor_boot`) |
| Kernel version | `5.15.194-android13-8-00019-gf4321180a397-ab15212794` |
| KMI generation | 8 |

The `-android13-8-` suffix matches `KMI_GENERATION=8` in the ChicKernel tree, so the stock
vendor modules are expected to load against a custom 5.15 kernel that preserves the KMI.

## Other partitions (reference)

| File | Size | SHA-256 |
|---|---:|---|
| `init_boot.img` | 8,388,608 | `828d3bb72990345d0eae44684fefae5f0f8960596920b0b2c7a3e84c0fbfabcd` |
| `vendor_boot.img` | 100,663,296 | `29ff1732bdcdc4e208e3c57c94b85c178b31e0118bdb84c31433682fdebb874f` |
| `dtbo.img` | 8,388,608 | `6a600bc087af08879d79fe8270e9ad72fbcdbf29a2b11c68cf30cdc88c4f02ba` |
| `vbmeta.img` | 8,192 | `a3d7e3512cd3751f27dc47c41d78e765fecd1e6549ad11f38eb6cc77afa8d167` |

The Stage 0 AnyKernel3 zip only replaces `boot`; `init_boot`, `vendor_boot`, `dtbo`, and
`vendor_dlkm` stay as shipped. Restore with:

```sh
fastboot flash boot Downloads/StockBootImages/boot.img
fastboot reboot
```

## Note for Stage 1

The running stock kernel is **5.15.194**, not the 5.15.41 in Xiaomi's `topaz-t-oss` branch.
ChicKernel's tree is at 5.15.189. When rebasing onto Xiaomi's official source, merge
`common-android13-5.15-lts` up to at least 5.15.194 so the kernel matches the firmware the
vendor modules were built against.
