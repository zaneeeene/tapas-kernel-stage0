# tapas Stage 0 — CI-built 5.15 kernel

Device: **Redmi Note 12 4G** — `tapas` (non-NFC) / `topaz` (NFC)  
SoC: **SM6225-AD "khaje"** (Snapdragon 685)  
Purpose: prove the **build → flash → restore** loop with a 5.15 GKI kernel, before any 6.18 work.

> This is **not** a 6.18 kernel. Xiaomi's published `topaz-t-oss` branch (5.15.41) is only the
> `msm-kernel`/GKI half: it has no vendor DTS, no `techpack/`, and no KGSL (`drivers/gpu/msm`).
> Stage 0 therefore uses the maintained ChicKernel 5.15 tree, which is the same msm-kernel base
> plus the missing build glue. Stage 1 can rebase onto Xiaomi's official tree once the pipeline works.

## Run the build

1. Open **Actions → Build tapas 5.15 kernel → Run workflow**.
2. Keep the defaults (vanilla config, `Image`, fast build).
3. When it finishes, download the **kernel-packages** artifact.
4. Inside is `build.config.gki.aarch64.chickernel.zip` (AnyKernel3 package) and the raw `Image-*`.

Build time is roughly 60–120 minutes on a GitHub-hosted runner.

## Before flashing (do this once)

Back up your stock boot partition. With root:

```sh
adb shell su -c 'dd if=/dev/block/bootdevice/by-name/boot of=/sdcard/stock-boot.img'
adb pull /sdcard/stock-boot.img
```

Or use your recovery's **Backup → Boot** option. Keep that file somewhere safe.

## Flash

1. Copy the AnyKernel3 zip to the phone.
2. Boot to recovery (OrangeFox/TWRP).
3. **Install → select the zip → flash**.
4. Reboot. First boot can take 5–10 minutes.

Verify:

```sh
adb shell uname -r
```

You should see a `5.15.189-...` string (ChicKernel base), not the stock `5.15.41-...`.

## Restore / unbrick

If it bootloops:

- Recovery: restore the **Boot** backup you made above, or
- Fastboot:

```sh
fastboot flash boot stock-boot.img
fastboot reboot
```

The kernel only replaces `boot`; `vendor_boot`, `dtbo`, and `vendor_dlkm` are untouched.

## Workflow inputs

| Input | Default | Notes |
|---|---|---|
| `build_configs` | `build.config.gki.aarch64.chickernel` | Add `...chickernel.ksun` / `...chickernel.ksun.susfs` for root variants |
| `kernel_image_type` | `Image` | `Image.gz` / `Image.lz4` also supported |
| `fast_build` | `true` | ThinLTO, faster |
| `use_latest_clang` | `false` | Keep `false` to use the branch-pinned clang; try `true` only if it fails |
| `ack_branch` | `common-android13-5.15` | Workspace + prebuilts |
| `kernel_repo` | ChicKernel tree | Swap later for your own fork/tree |
| `kernel_repo_branch` | `android13-5.15-lts` | |
| `ak3_repo` | `osm0sis/AnyKernel3` | Device logic comes from `anykernel/anykernel.sh` |

## Notes and known risks

- Bootloader must be **unlocked**. Unlocking wipes data.
- `anykernel.sh` checks `ro.product.device` against `tapas`/`topaz`. If your ROM reports
  something else, edit `device.name1`/`device.name2`.
- The stock 5.15 vendor modules must keep loading. If the device boots but hardware is missing,
  capture `dmesg` and check for `version magic` / `Unknown symbol` errors.
- Keep the stock boot image. Do not flash `vendor_boot`/`dtbo` from another firmware version.
