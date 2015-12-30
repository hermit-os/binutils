# Copyright (C) 2015, Stefan Lankes, RWTH Aachen University
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.
#

cat <<EOF
/* Copyright (C) 2015, Stefan Lankes, RWTH Aachen University

   Copying and distribution of this script, with or without modification,
   are permitted in any medium without royalty provided the copyright
   notice and this notice are preserved.  */

OUTPUT_FORMAT("elf64-x86-64")
OUTPUT_ARCH("i386:x86-64")
ENTRY(_start)
phys = 0x200000;
cores = 40;

SECTIONS
{
  kernel_start =  phys;
  .mboot phys : AT(ADDR(.mboot)) {
    *(.mboot)
    . = ALIGN((1 << 12));
    *(.kmsg)
  }
  .ktext ALIGN(4096) : AT(ADDR(.ktext)) {
    *(.ktext)
    *(.ktext.*)
  }
  .kdata : {
    *(.kdata)
    *(.kdata.*) 
  }
  .text ALIGN(4096) : AT(ADDR(.text)) {
    *(.text)
    *(.text.*)
  }
  .rodata : {
    *(.rodata)
    *(.rodata.*)
  }
  .data : {
    *(.data)
    *(.data.*)
  }
  .tdata : {
	tls_start = .;
        *(.tdata)
  }
  .tbss : {
        *(.tbss)
  }
  tls_end = tls_start + SIZEOF(.tdata) + SIZEOF(.tbss);
  .kbss : {
    kbss_start = .;
    *(.kbss)
  }
  kbss_end = .;
  .bss : {
    __bss_start = .;
    *(.bss)
    *(.bss.*)
  }
  .percore ALIGN(4096) : AT(ADDR(.percore)) {
    percore_start = .;
    *(.percore)
    . = ALIGN(64);
    percore_end0 = .;
  }
  percore_end = percore_start + cores * SIZEOF(.percore);
  kernel_end = percore_end;
}
EOF
