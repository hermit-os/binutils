source_sh ${srcdir}/emulparams/elf64lriscv.sh
OUTPUT_FORMAT="elf64-bigriscv"

case "$target" in
  riscv64*-hermit*)
    OUTPUT_FORMAT="elf64-bigriscv-hermit"
    ;;
esac