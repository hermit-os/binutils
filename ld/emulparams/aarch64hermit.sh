ARCH=aarch64
MACHINE=
NOP=0

SCRIPT_NAME=elf-hermit
ELFSIZE=64
OUTPUT_FORMAT="elf64-littleaarch64-hermit"
BIG_OUTPUT_FORMAT="elf64-bigaarch64-hermit"
LITTLE_OUTPUT_FORMAT="elf64-littleaarch64-hermit"
NO_REL_RELOCS=yes

TEMPLATE_NAME=elf32
EXTRA_EM_FILE=aarch64elf

GENERATE_SHLIB_SCRIPT=no
GENERATE_PIE_SCRIPT=no

MAXPAGESIZE="CONSTANT (MAXPAGESIZE)"
COMMONPAGESIZE="CONSTANT (COMMONPAGESIZE)"
SEPARATE_GOTPLT=24
IREL_IN_PLT=

TEXT_START_ADDR=0x200000

DATA_START_SYMBOLS='PROVIDE (__data_start = .);';

# AArch64 does not support .s* sections.
NO_SMALL_DATA=yes

OTHER_BSS_SYMBOLS='__bss_start__ = .;'
OTHER_BSS_END_SYMBOLS='_bss_end__ = . ; __bss_end__ = . ;'
OTHER_END_SYMBOLS='__end__ = . ;'

OTHER_SECTIONS='.note.gnu.arm.ident 0 : { KEEP (*(.note.gnu.arm.ident)) }'
ATTRS_SECTIONS='.ARM.attributes 0 : { KEEP (*(.ARM.attributes)) KEEP (*(.gnu.attributes)) }'
# Ensure each PLT entry is aligned to a cache line.
PLT=".plt          ${RELOCATING-0} : ALIGN(16) { *(.plt)${IREL_IN_PLT+ *(.iplt)} }"
