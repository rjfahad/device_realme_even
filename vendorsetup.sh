#!/bin/bash
clone_if_missing() {
    local repo="$1" branch="$2" dest="$3"
    if [ ! -d "$dest" ]; then
        echo "Cloning $dest ..."
        git clone --depth=1 "$repo" -b "$branch" "$dest"
    else
        echo "Already exists: $dest"
    fi
}

echo "Checking dependencies"

clone_if_missing https://github.com/LineageOS/android_hardware_mediatek.git lineage-20 ./hardware/mediatek
clone_if_missing https://github.com/rjfahad/kernel_realme_even.git los-20 ./kernel/realme/even
clone_if_missing https://github.com/HyperTeam/android_packages_apps_RealmeParts.git lineage-20 ./packages/apps/RealmeParts
# Toolchain (greenforce clang)
# NOTE: the greenforce_clang *repo* is repo-managed (.repo/local_manifests/roomservice.xml),
# so we must NOT git-clone into it here. The repo only ships the installer scripts;
# the actual binaries are fetched by get_clang.py into $CLANG_DIR.
_GF_TOP="${ANDROID_BUILD_TOP:-$(pwd)}"
CLANG_DIR="${CLANG_DIR:-$_GF_TOP/prebuilts/clang/host/linux-x86/greenforce-clang}"
if [ ! -x "$CLANG_DIR/bin/clang" ]; then
    if [ -f "$CLANG_DIR/get_clang.py" ]; then
        echo "Downloading greenforce-clang toolchain into $CLANG_DIR ..."
        (cd "$CLANG_DIR" && GREENFORCE_INSTALL_DIR="$CLANG_DIR" python3 get_clang.py) || {
            # Fallback: GitHub API rate-limit (403) - use pinned direct release URL
            _GF_URL=$(grep -o 'https://[^[:space:]]*\.tar\.gz' "$CLANG_DIR/get_latest_url.sh" 2>/dev/null | head -1)
            if [ -n "$_GF_URL" ]; then
                echo "API rate-limited, direct download: $_GF_URL"
                curl -sL "$_GF_URL" -o /tmp/gf-clang.tar.gz \
                    && tar -xzf /tmp/gf-clang.tar.gz -C "$CLANG_DIR" \
                    && rm -f /tmp/gf-clang.tar.gz
            fi
            [ -x "$CLANG_DIR/bin/clang" ] \
                || echo "WARNING: greenforce-clang download failed (build will fall back to AOSP clang)"
        }
    else
        echo "WARNING: $CLANG_DIR/get_clang.py not found - run 'repo sync' first"
    fi
else
    echo "Toolchain ready: $CLANG_DIR/bin/clang"
fi
unset _GF_TOP
clone_if_missing https://github.com/rjfahad/vendor_realme_RMX3191-ims.git thirteen ./vendor/realme/RMX3191-ims
clone_if_missing https://github.com/LineageOS/android_device_mediatek_sepolicy_vndr.git lineage-20 ./device/mediatek/sepolicy_vndr

# Auto-apply tree patches (idempotent, lunch-safe: warns, never fails lunch)
apply_tree_patch() {
    local target_dir="$1" patch_file="$2" desc="$3"
    if [ ! -d "$target_dir" ]; then
        echo "Skip patch ($desc): $target_dir not present"
        return 0
    fi
    if [ ! -f "$patch_file" ]; then
        echo "Skip patch ($desc): patch file missing: $patch_file"
        return 0
    fi
    if git -C "$target_dir" apply --reverse --check "$patch_file" >/dev/null 2>&1; then
        echo "Already applied: $desc"
    elif git -C "$target_dir" apply --check "$patch_file" >/dev/null 2>&1; then
        echo "Applying patch: $desc"
        git -C "$target_dir" apply "$patch_file" \
            || echo "WARNING: failed to apply $desc"
    else
        echo "WARNING: cannot apply $desc (target diverged - fixed upstream?)"
    fi
}

_TOP_DIR="${ANDROID_BUILD_TOP:-$(pwd)}"
_EVEN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
apply_tree_patch "$_TOP_DIR/system/tools/aidl" \
    "$_EVEN_DIR/patches/aidl_uninit_found.patch" \
    "aidl ConstReferenceFinder uninit fix (glibc 2.39 segfault)"
apply_tree_patch "$_TOP_DIR/frameworks/base" \
    "$_EVEN_DIR/patches/sqlitetokenizer_brackets.patch" \
    "SQLiteTokenizer OPTION_CHECK_BRACKETS (ContactsProvider)"
apply_tree_patch "$_TOP_DIR/packages/services/Mms" \
    "$_EVEN_DIR/patches/mms_callinguser_backport.patch" \
    "MmsService callingUser backport (match Feb-2025 IMms.aidl)"
apply_tree_patch "$_TOP_DIR/frameworks/base" \
    "$_EVEN_DIR/patches/telephony_isshell_helper.patch" \
    "TelephonyPermissions.isShell helper (Telephony backport)"
unset _TOP_DIR _EVEN_DIR

echo "Done!"
