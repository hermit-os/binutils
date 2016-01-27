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
phys = 0x800000;
cores = 128;

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
  .init : {
    KEEP (*(SORT_NONE(.init)))
  }
  .text : {
    *(.text)
    *(.text.*)
  }
  .fini : {
    KEEP (*(SORT_NONE(.fini)))
  }
  .rodata : {
    *(.rodata)
    *(.rodata.*)
  }
  .eh_frame : ONLY_IF_RW { KEEP (*(.eh_frame)) }
  .ctors :
  {
    /* gcc uses crtbegin.o to find the start of
       the constructors, so we make sure it is
       first.  Because this is a wildcard, it
       doesn't matter if the user does not
       actually link against crtbegin.o; the
       linker won't look for a file to match a
       wildcard.  The wildcard also means that it
       doesn't matter which directory crtbegin.o
       is in.  */
    KEEP (*crtbegin.o(.ctors))
    KEEP (*crtbegin?.o(.ctors))
    /* We don't want to include the .ctor section from
       the crtend.o file until after the sorted ctors.
       The .ctor section from the crtend file contains the
       end of ctors marker and it must be last */
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*(.ctors))
  }
  .dtors :
  {
    KEEP (*crtbegin.o(.dtors))
    KEEP (*crtbegin?.o(.dtors))
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*(.dtors))
  }
  .jcr  : { KEEP (*(.jcr)) }
  .got.plt : { *(.got.plt)  *(.igot.plt) }
  .data : {
    *(.data)
    *(.data.*)
  }
  .percore : {
    . = ALIGN(64);
    percore_start = .;
    *(.percore)
    . = ALIGN(64);
    percore_end0 = .;
    /* reserve space for more cores */
    . += cores * (percore_end0 - percore_start) - (percore_end0 - percore_start);
    percore_end = .;
  }
  .tdata : {
     tls_start = .;
     *(.tdata)
  }
  .tbss : {
    hbss_start = .;
     *(.tcommon)
     *(.tbss)
    tls_end = .;
  }
  .kbss : {
    *(.kbss)
  }
  .bss : {
    __bss_start = .;
    *(.bss)
    *(.bss.*)
  }
  kernel_end = .;
}
EOF
