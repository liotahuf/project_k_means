#!/bin/csh -f
#* ******************************************************************** *
#* ***                                                              *** *
#* *** Copyright (c) 2003 Synopsys, Inc.  All Rights Reserved       *** *
#* *** This information is provided pursuant to a license agreement *** *
#* *** that grants limited rights of access/use and requires that   *** *
#* *** the information be treated as confidential.                  *** *
#* ***                                                              *** *
#* ******************************************************************** *
# *********************************************************
# *							  *
# *	   Script  for  Synopsys  Library  Compiler	  *
# *							  *
# *	     Compiling Common Library Definition	  *
# *							  *
# *		     rev. 3.0, Oct. 2003 	          *
# *							  *
# *							  *
# *********************************************************


#  Technology : TSL 0.18 um
#  Corner     : min, typ, max

#  Required Synopsys Library Compiler Version: 1999.10 (or higher)

#  Purpose: Compiling the library definition which is common to all
#           memory compilers of the technology mentioned above.
#
#  Input:   - tsl18_memory_min.lib (built by RapidCompiler)
#           - tsl18_memory_typ.lib (built by RapidCompiler)
#           - tsl18_memory_max.lib (built by RapidCompiler)
#
#  Output:  - make_lc_tsl18_memory.cmd    (command file for lc_shell)
#           - make_lc_tsl18_memory.log    (log file of lc_shell run)
#           - tsl18_memory_min.db	   (built by Synopsys lc_shell)
#	    - tsl18_memory_typ.db	   (built by Synopsys lc_shell)
#	    - tsl18_memory_max.db	   (built by Synopsys lc_shell)
#           - tsl18_memory_min.rpt        (timing report of lc_shell)
#           - tsl18_memory_typ.rpt        (timing report of lc_shell)
#           - tsl18_memory_max.rpt        (timing report of lc_shell)





set filename_min = tsl18_memory_min.lib
set libname_min  = tsl18_memory_min
set report_min   = tsl18_memory_min.rpt
set synoplib_min = tsl18_memory_min.db
set filename_typ = tsl18_memory_typ.lib
set libname_typ  = tsl18_memory_typ
set report_typ   = tsl18_memory_typ.rpt
set synoplib_typ = tsl18_memory_typ.db
set filename_max = tsl18_memory_max.lib
set libname_max  = tsl18_memory_max
set report_max   = tsl18_memory_max.rpt
set synoplib_max = tsl18_memory_max.db
set script       = make_lc_tsl18_memory.cmd
set lc_log       = make_lc_tsl18_memory.log
set synversion   = 2002.05 




if (-e $script) then
  \rm -f $script
endif




echo "Generating input script '$script' for lc_shell (v 1999.05 or higher) ..."
echo "echo "Compiling $libname_min ..."" >> $script
echo "read_lib $filename_min" >> $script
echo "report_lib $libname_min > $report_min" >> $script
echo "write_lib -output $synoplib_min $libname_min" >> $script
echo "echo "Compiling $libname_typ ..."" >> $script
echo "read_lib $filename_typ" >> $script
echo "report_lib $libname_typ > $report_typ" >> $script
echo "write_lib -output $synoplib_typ $libname_typ" >> $script
echo "echo "Compiling $libname_max ..."" >> $script
echo "read_lib $filename_max" >> $script
echo "report_lib $libname_max > $report_max" >> $script
echo "write_lib -output $synoplib_max $libname_max" >> $script
echo "quit" >> $script





echo "Executing '$script' in lc_shell ..."
lc_shell < $script > $lc_log



