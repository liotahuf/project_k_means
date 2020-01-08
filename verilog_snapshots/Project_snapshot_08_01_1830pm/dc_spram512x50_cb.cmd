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
# *	     Script for Synopsys Design Compiler	  *
# *							  *
# *		  Adding Cell Description		  *
# *							  *
# *		    rev. 3.0, Oct. 2003  		  *
# *							  *
# *		                			  *
# *							  *
# *********************************************************


#   Technology : TSL 0.18 um
#   Compiler   : TSL18RS160
#   Corner     : min, typ, max
 
#   PCL Name		: spram512x50_cb
#   Configuration	: 512x50
#   Clock Polarity	: FALSE
#   Multi Banks 	: FALSE
#   Separated IOs	: TRUE
#   Selective Bit Write : FALSE
#   Output Drive	: 2X



#  Required Synopsys Design Compiler Version: 1999.05 (or higher)

#  Purpose: Adding cell description of a specific memory cut
#           (parameter specification as given above) to an already
#           compiled common library description.
#
#  Input:   - tsl18_memory_min.db         (built by Synopsys lc_shell)
#           - tsl18_memory_typ.db         (built by Synopsys lc_shell)
#           - tsl18_memory_max.db         (built by Synopsys lc_shell)
#
#  Output:  - spram512x50_cb_min.rpt                 (timing report of lc_shell)
#           - spram512x50_cb_typ.rpt                 (timing report of lc_shell)
#           - spram512x50_cb_max.rpt                 (timing report of lc_shell)
#           - make_dc_spram512x50_cb.cmd             (command file for lc_shell)
#           - make_dc_spram512x50_cb.log             (log file of lc_shell run)





set cellname     = spram512x50_cb
set filename_min = spram512x50_cb_min.lib
set report_min   = spram512x50_cb_min.rpt
set libname_min  = tsl18_memory_min
set synoplib_min = tsl18_memory_min.db
set filename_typ = spram512x50_cb_typ.lib
set report_typ   = spram512x50_cb_typ.rpt
set libname_typ  = tsl18_memory_typ
set synoplib_typ = tsl18_memory_typ.db
set filename_max = spram512x50_cb_max.lib
set report_max   = spram512x50_cb_max.rpt
set libname_max  = tsl18_memory_max
set synoplib_max = tsl18_memory_max.db
set script       = make_dc_spram512x50_cb.cmd
set dc_log       = make_dc_spram512x50_cb.log
set synversion   = 2002.05 




if !(-e $synoplib_min) then
  echo "Copying $libname_min from installation directory ..."
  \cp -f $LIBRA_HOME_DIR/$LIBRA_PROD_DIR/synopsys/$synversion/models/$synoplib_min .
  if !(-w $synoplib_min) then
    chmod 660 $synoplib_min
  endif
else
  echo "Using local copy of $libname_min to add cell $cellname ..."
  if !(-w $synoplib_min) then
    chmod 660 $synoplib_min
  endif
endif
if !(-e $synoplib_typ) then
  echo "Copying $libname_typ from installation directory ..."
  \cp -f $LIBRA_HOME_DIR/$LIBRA_PROD_DIR/synopsys/$synversion/models/$synoplib_typ .
  if !(-w $synoplib_typ) then
    chmod 660 $synoplib_typ
  endif
else
  echo "Using local copy of $libname_typ to add cell $cellname ..."
  if !(-w $synoplib_typ) then
    chmod 660 $synoplib_typ
  endif
endif
if !(-e $synoplib_max) then
  echo "Copying $libname_max from installation directory ..."
  \cp -f $LIBRA_HOME_DIR/$LIBRA_PROD_DIR/synopsys/$synversion/models/$synoplib_max .
  if !(-w $synoplib_max) then
    chmod 660 $synoplib_max
  endif
else
  echo "Using local copy of $libname_max to add cell $cellname ..."
  if !(-w $synoplib_max) then
    chmod 660 $synoplib_max
  endif
endif




if (-e $script) then
  \rm -f $script
endif




echo "Generating input script '$script' for dc_shell (v 1999.05 or higher) ..."
echo "echo "Adding $cellname to $libname_min ..."" >> $script
echo "read -format db ./$synoplib_min" >> $script
echo "add_module $filename_min $libname_min" >> $script
echo "report_lib $libname_min > $report_min" >> $script
echo "write_lib -output ./$synoplib_min $libname_min" >> $script
echo "echo "Adding $cellname to $libname_typ ..."" >> $script
echo "read -format db ./$synoplib_typ" >> $script
echo "add_module $filename_typ $libname_typ" >> $script
echo "report_lib $libname_typ > $report_typ" >> $script
echo "write_lib -output ./$synoplib_typ $libname_typ" >> $script
echo "echo "Adding $cellname to $libname_max ..."" >> $script
echo "read -format db ./$synoplib_max" >> $script
echo "add_module $filename_max $libname_max" >> $script
echo "report_lib $libname_max > $report_max" >> $script
echo "write_lib -output ./$synoplib_max $libname_max" >> $script
echo "quit" >> $script




echo "Executing '$script' in dc_shell ..."
dc_shell < $script > $dc_log

