$! Copyright (c) 2004, 2009 Ingres Corporation
$!
$!
$! This script builds VMS versions of `bzarch.h,' a file containing
$! all configuration dependent definitions and included by <compat.h>.
$! It is only valid for INGRES 6.1 and above.  For earlier versions,
$! bzarch.h should be created with the "mkhdr" program.
$!
$! This new version defines only public entities.  Another program,
$! mkclconf.sh, builds the cl private cl/cl/hdr/secrets.h file that
$! contains definitions that known only to the CL.
$!
$! The following things are defined in bzarch.h as needed.
$!
$! Config string machine identifier:
$!
$!	sun.u42 -> sun_u42
$!	3bx_us5 -> x3bx_us5
$!
$! Obsolescent machine identifiers:
$!
$!	VAX
$!	PYRAMID
$!	Power6		(cci tahoe)
$!	ELXSI
$!	CONCEPT32	(gould PN, not NP)
$!	SUN		(really wrong)
$!	BURROUGHS
$!	CT_MEGA
$!	x3B5
$!
$! Machine/OS common flavors:
$!
$!	MEGAFRAME	(burroughs or CT)
$!	UNIPLUS		(A/UX, BT, etc.)
$!	SEQUENT		(Balance or Symmetry)
$!	DOMAINOS	(apollo)
$!	AIX		(ibm)
$!
$! Things that don't really change on Unix:
$!
$!	UNIX		(for all UNIX platforms)
$!	BAD_BITFIELDS	(use masks for tid manipulation)
$!	GLOBALREF	(extern)
$!	GLOBALDEF	(null on non-VMS)
$!	NODY		(DY not used)
$!	II_DMF_MERGE	(use single server executable)
$!
$! Arch/compiler specific:
$!
$!	LITTLE_ENDIAN_INT  (Integers are little-endian)
$!	BIG_ENDIAN_INT	(Integers are big-endian)
$!	NO_64BIT_INT	(No 64 bit integer in hardware or compiler emulation)
$!	IEEE_FLOAT	(might not need extra-CL visibility)
$!	FLT_OPEQ_BUF	(common compiler problem)
$!	INTERNAT	(obsolete?)
$!	NEED_ZERO_FILL	(Must initialize all variables)
$!	DUALUBSD	(Dual universe)
$!	NODSPTRS	(Can't to 0->element offsetof(element) trick)
$!	xHARDMATH	(EXCONTINUE from math exceptions won't work).
$!	OS_THREADS_USED	(Operating system threads)
$!	SYS_V_THREADS	(SystemV/Unix International/Solaris threads)
$!	POSIX_THREADS	(POSIX threads)
$!	HAS_VARIADIC_MACROS (Compiler supports variadic macro forms)
$!
$! Special types:
$!
$!	READONLY	"const" or ""
$!	WSCREADONLY	"const" or ""	(obsolescent)
$!	GLOBALCONSTDEF	"const" or ""
$!	GLOBALCONSTREF	"extern const" or extern
$!
$! Alignment/Size related:
$!
$!	BITSPERBYTE	(better be 8!)
$!	ALIGN_I2	(1)
$!	ALIGN_I4	(1 | 3)
$!	ALIGN_I8	(1 | 3 | 7)
$!	ALIGN_F4	(1 | 3)
$!	ALIGN_F8	(1 | 3 | 7)
$!
$!	ALIGN_RESTRICT	(char | short | int | double)
$!
$! Assignment Macros:
$!
$!	BA(a,i,b)	Byte aligned move of i bytes from a to b
$!	I2_ASSIGN_MACRO
$!	I4_ASSIGN_MACRO
$!	I8_ASSIGN_MACRO
$!	F4_ASSIGN_MACRO
$!	F8_ASSIGN_MACRO
$!
$! Byte ordering, etc:
$!
$!	TID_SWAP	if "reverse" bitfield ordering
$!
$! Unsigned char manipulation
$!
$!	UNS_CHAR	if chars are unsigned only
$!	I1_CHECK_MACRO	6.1 flavor of above
$!
$! Size of pointer, and equivalent sized scalar type for use only within CL
$!	
$!	PTR_BITS_64	if pointers are 64 bits
$!	SCALARP		scalar type same size as a pointer, usually int or long
$!	SCALARP_IS_LONG	if SCALARP is defined to be "long"
$!
$!! History:
$!!	01-sep-2004 (abbjo03)
$!!	    Created from mkbzarch.sh (original UNIX comments left for
$!!	    reference).
$!!	25-may-2005 (abbjo03)
$!!	    Read the output from running unschar.
$!!	28-Oct-2008 (jonj)
$!!	    SIR 120874: Add test for variadic macro support (ISO 99), emit
$!!	    HAS_VARIADIC_MACROS
$!!	31-Oct-2008 (jonj)
$!!	    Fix typos in compiled variadic macro test code.
$!!	25-nov-2008 (abbjo03)
$!!	    Add support for OS threads under VMS, Alpha and Itanium.
$!!     12-dec-2008 (joea)
$!!         Remove BYTE_SWAP (use BIG/LITTLE_ENDIAN_INT instead).
$!!     22-dec-2008 (stegr01)
$!!         Itanium VMS port.
$!!         If II_THREAD_TYPE defined (on Alpha) then the compilation should build
$!!         OS threads support - the setting of this logical to INTERNAL (on Alpha)
$!!         indicates that Ingres threads are to be used.
$!!	11-jun-2009 (joea)
$!!	    Replace II_THREAD_TYPE with BUILD_WITH_POSIX_THREADS.
$!!     14-jan-2010 (joea)
$!!         Change default build on IA64 to BUILD_WITH_KPS and also allow it
$!!         on Alpha.
$!!     19-jan-2010 (joea)
$!!         Fix typo on IA64 section of change above.
$!!
$ echo := write sys$output
$ define /nolog tmp SYS$SCRATCH
$ header="bzarch.h"
$ date=f$time()
$! create header with correct permissions
$ create 'header
$ open /app out 'header
$! don't leave it around if we have trouble
$! FIXME: need "on warning"
$! version file generated by running the source transfer script
$! generated by mkreq.sh.  GV_VER and GV_ENV used in gver.roc.
$ @ING_TOOLS:[bin]readvers
$ vers=IIVERS_config
$ if vers .eqs. "i64_aix"
$ then	CC="xlc_r"
$ else	CC="cc"
$ endif
$ write out "# define ''vers'"
$! Alias new HP config strings to hp8_us5 to enable most current settings
$! Alias new SUN v9 config string to su4_us5 to enable most current settings
$ product="Ingres"
$! create a new target:
$ write out "/*"
$ write out "** ''product' ''header' created on ''date'"
$ write out "** by the ''f$env("procedure")' shell script"
$ write out "*/"
$!
$! obsolete machine identifiers (predate use of config string)
$!
$! These defines are mostly rehashing of the machine ID defined by the
$! cpp.  They should eventually expire as the references to them in the
$! code are changed to #ifdef's keyed either on some capability determined
$! automatically below or on the config string.
$!
$! architecture and operating system variants
$!
$! This section is for defines that identify common machine and OS variants.
$!
$!	DOMAINOS	Apollo Domain OS
$!	MEGAFRAME	CT Megaframe
$!	UNIPLUS		Unisoft UniPlus+
$!	SEQUENT		Sequent Balance and Symmetry series for BSD and Sys V
$!			Universes
$!	MIPS32		32-bit MIPS processor: R3000 or R4000 series
$!
$ i=0
$ opts=f$edit(IIVERS_opts, "trim")
$optsloop:
$	o=f$elem(i, " ", opts)
$	if o .eqs. " " then goto endopts
$	write out "# define conf_''o'"
$	i=i+1
$	goto optsloop
$endopts:
$!
$!       Define FUSEDLL if this is a fused OpenROAD build
$!
$! It can no longer be assumed that the size of a pointer is the same size
$! as an int. SCALARP is a scalar type whose size is the same as the size of
$! a pointer; it is expected that SCALARP will usually be int or long. If it
$! is long, define SCALARP_IS_LONG (useful for #defines in hdr files).
$! SCALARP and SCALARP_IS_LONG may be used ONLY inside the CL.
$!
$! It can no longer be assumed that the size of a pointer is 32 bits as this
$! can affect the size of messages (eg. in GCA). If pointer size is 64 bits
$! define PTR_BITS_64.
$!
$ close out
$ create tmp:bitsin.awk
/^ptr/ {
    ptrsize = $2
}
/^long:/ {
    longsize = $2
}
/^int/ {
    intsize = $2
}
END {
    if (ptrsize == 64)
	printf "# define PTR_BITS_64\n"
    printf "/* SCALARP, SCALARP_IS_LONG may be used ONLY inside the CL. */\n"
    if (ptrsize == intsize)
    {
	printf "# define SCALARP int\n"
    }
    else
    {
	if (ptrsize == longsize)
	{
	    printf "# define SCALARP long\n"
	    printf "# define SCALARP_IS_LONG\n"
	}
	else
	{
	    printf "/* SCALARP MUST be defined, please fix in mkbzarch.sh\n"
	}
    }
}
$ pipe bitsin | gawk -ftmp:bitsin.awk >tmp:bzarch-bitsin.tmp
$ edit /sum tmp:bzarch-bitsin.tmp /out=tmp:
$ append tmp:bzarch-bitsin.tmp 'header'
$ del tmp:bitsin.awk;*, tmp:bzarch-bitsin.tmp;*
$!
$!	Essentially invariant defines.
$!
$ open /app out 'header'
$ write out "# ifdef __cplusplus"
$ write out "# define GLOBALREF extern ""C"""
$ write out "# define GLOBALDEF
$ write out "# else  /* __cplusplus */"
$ write out "# define GLOBALREF globalref"
$ write out "# endif  /* __cplusplus */"
$ write out "# define GLOBALDEF globaldef"
$ write out "# define INGRES65"
$ write out "# define GCF65"
$!
$! other variants
$!
$! Currently, these capabilities are not determined automatically.
$!
$! If you make a special case for your machine, be sure to duplicate
$! all the defines from the generic *) case.
$!
$!	NO_64BIT_INT	No 64 bit integer in hardware or compiler emulation)
$!	IEEE_FLOAT	has ieee conforming floating point
$!	FLT_OPEQ_BUG	can't say "float1 op= float2"
$!	INTERNAT	internationalization code
$!	NEED_ZERO_FILL	ZERO_FILL must be "= {0}"
$!	DUALUBSD	Dual universe with most of the port built in BSD and
$!			a veneer of Sys V
$!	MCT		Multiple Concurrent Threads (sqs_ptx only, for now)
$!	OS_THREADS_USED	Operating System Threads (posix or sysV)
$!	SYS_V_THREADS	SystemV/Unix International/Solaris threads
$!	POSIX_THREADS	POSIX threads
$!	SIMULATE_PROCESS_SHARED 
$!			Simulate the process-shared attribute for POSIX
$!			THREAD machines that do not support sharing
$!			mutexes and condition variables between processes.
$!			POSIX_THREADS_PROCESS_SHARED. missing on rs4_us5
$!	LARGEFILE64	Support 64 bit file system access.
$!	LP64		Support for 64-bit address pointers.
$!	RAAT_SUPPORT	Support for obsolescent Record at a Time interface.
$!			Restricted to 32 bit HP, SUN, AIX, NT, and Tru64.
$! LARGEFILE64 is only required in 32-bit executables.  It in on by
$! default in 64-bit builds.
$!                echo "# define LARGEFILE64"
$ if vers .eqs. "axm_vms"
$ then
$	write out "# define IEEE_FLOAT"
$!	On Alpha, the default for now will be to build without POSIX threads
$!	unless BUILD_WITH_POSIX_THREADS is defined as a DCL boolean True.
$	if f$trnlnm("BUILD_WITH_POSIX_THREADS")
$	then
$!	    On Alpha, process-shared synchronization objects are only
$!	    available starting on VMS 8.2.
$	    ver=f$getsyi("version")-"V"
$	    ver=f$integer(f$extract(0, f$locate(".", ver), ver))
$	    if ver .lt. 8
$	    then
$		write out "# error MUST BUILD ON VMS 8.x OR LATER!!!"
$	    else
$		write out "# define OS_THREADS_USED"
$		write out "# define POSIX_THREADS"
$	    endif
$       else
$           if f$trnlnm("BUILD_WITH_KPS")
$           then
$               write out "# define KPS_THREADS"
$           endif
$	endif
$ else
$       if vers .eqs. "i64_vms"
$	then
$           write out "# define IEEE_FLOAT"
$           if f$trnlnm("BUILD_WITH_POSIX_THREADS")
$           then
$		write out "# define OS_THREADS_USED"
$		write out "# define POSIX_THREADS"
$           else
$               write out "# define KPS_THREADS"
$           endif
$	endif
$ endif
$ if "''NEED_ZERO_FILL'" .nes. ""
$ then write out "# define ZERO_FILL = {0}"
$ else write out "# define ZERO_FILL"
$ endif
$!
$! NODSPTRS - can we deference a null structure pointer at compile time?
$!
$ set noon
$ 'CC' /noobj sys$input
		struct a { int a,b; };
		int c = (int)&(((struct a *)0)->b);
$ if $severity .ne. 1 then -
	write out "# define NODSPTRS"
$ set on
$!
$! BAD_NEG_I2_CAST - check that the compiler can handle the negation
$!	of a i2 (short) cast value.  (This is known to effect more
$!	compilers than one would imagine!).
$!
$ set noon
$ 'CC' /noobj sys$input
# define ONE    (i2)1
typedef short i2;
i2 minusone = -ONE;
$ if $severity .ne. 1 then -
	write out "# define BAD_NEG_I2_CAST"
$ set on
$!
$! NO_VOID_ASSIGN - can we assign pointers to functions of type 'void' ?
$!
$ set noon
$ 'CC' /noobj sys$input
void
func()
{
    int nothing;
}

main()
{
    void(*assign)();
    assign = func;
}
$ if $severity .ne. 1 then -
	write out "# define NO_VOID_ASSIGN"
$ set on
$!
$! READONLY - can we use const type with the compiler?
$! Need to have a special case for ris_us5 because of compiler flag
$! conflicts per fredv. (seng)
$!
$ if ((vers .eqs. "axm_vms") .or. (vers .eqs. "i64_vms"))
$ then	write out "# define READONLY readonly"
$	write out "# define WSCREADONLY"
$	write out "# if defined(__cplusplus)
$	write out "# define GLOBALCONSTREF extern ""C"""
$	write out "# else /* __cplusplus */
$	write out "# define GLOBALCONSTREF globalref"
$	write out "# define GLOBALCONSTDEF globaldef {""II_ADDRESS_DATA""} noshare"
$	write out "# endif /* __cplusplus */
$ endif
$! The following tests whether the volatile keyword is supported
$! by the compiler.  The volatile keyword prevents some code from
$! being moved when it shouldn't be.  Its use is disallowed
$! outside of the CL.
$ write out "/* VOLATILE may ONLY be used inside the CL. */"
$ set noon
$ 'CC' /noobj sys$input
main()
{
      typedef volatile struct _bar bar;
      struct _bar
      {
              int test;
      };
        bar barvar;
        barvar.test = 0;
        return (barvar.test);
}
$ if $severity .eq. 1 
$ then	write out "# define VOLATILE volatile"
$ else	write out "# define VOLATILE"
$ endif
$ set on
$!
$! string prefixed to nm symbols.
$!
$! Check to see if __setjmp exists.  We check here because the define
$! is needed in the header file ex.h.
$!
$! heterogeneous processors and alignment override
$!
$! This section is used to overide automatic determination of capabilities
$! on machines distributed with different processors (e.g. processor may be
$! either 68010 or 68020) or where our "align" tool is not able to
$! correctly determine the optimal alignment requirements.
$!
$!	ALIGN=68010	Force 68010 alignment.
$!	ALIGN=SPARC	Force Sun SPARC optimal alignment.
$!	ALIGN=MIPS	Force MIPS optimal alignment.
$!	ALIGN=AXP	Force Alpha optimal alignment.
$!      ALIGN=POWER64   Force AIX PowerPC 64-bit optimal alignment.
$!
$ mach=f$extr(0, 3, vers)
$ if mach .eqs. "axp" .or. mach .eqs. "axm"
$ then	ALIGN="AXP"
$ else	if mach .eqs. "i64"
$ then	ALIGN="IA64"
$ endif
$ endif
$!
$!	Evaluation section.  Automatically determined defines.
$!
$! Integer storage format
$!
$ pipe run ING_TOOLS:[bin]endian >tmp:readvar-mkbzarch.tmp
$ gosub readvar
$ endian_type=varvalue
$ if endian_type .eqs. "little"
$ then	write out "# define LITTLE_ENDIAN_INT"
$ else	write out "# define BIG_ENDIAN_INT"
$ endif
$!
$! bits in a byte
$!
$ pipe bitsin char | gawk /comm="{print $2}" sys$pipe >tmp:readvar-mkbzarch.tmp
$ gosub readvar
$ write out "# define BITSPERBYTE	''varvalue'"
$!
$! If specified above, use overriding alignment.
$! Otherwise, determine alignment by trial & error, capturing faults:
$!
$ if "''ALIGN'" .eqs. "AXP"
$ then	ALIGN_I2=2
	ALIGN_I4=4
	ALIGN_I8=8
	ALIGN_F4=4
	ALIGN_F8=8
$ else	if "''ALIGN'" .eqs. "IA64"
$ then	ALIGN_I2=2
	ALIGN_I4=4
	ALIGN_I8=8
	ALIGN_F4=4
	ALIGN_F8=8
$ endif
$ endif
$ write out "# define	ALIGN_I2	''f$int(ALIGN_I2 - 1)'"
$ write out "# define	ALIGN_I4	''f$int(ALIGN_I4 - 1)'"
$ write out "# define	ALIGN_I8	''f$int(ALIGN_I8 - 1)'"
$ write out "# define	ALIGN_F4	''f$int(ALIGN_F4 - 1)'"
$ write out "# define	ALIGN_F8	''f$int(ALIGN_F8 - 1)'"
$!
$! Determine the software imposed alignments
$!
$ close out
$ create tmp:salign.awk
BEGIN{
        n["short:"]="I2";
        n["int:"]="I4";
        n["float:"]="F4";
        n["double:"]="F8";
        }
  n[$1] != "" {printf "SALIGN_%s=%s ", n[$1], $5;}
$ pipe salign | gawk -ftmp:salign.awk >tmp:readvar-mkbzarch.tmp
$ gosub readvar
$ saligntypes=f$edit(varvalue, "trim")
$ i=0
$alignloop:
$	at=f$elem(i, " ", saligntypes)
$	if at .eqs. " " then goto endalign
$	eqloc=f$loc("=", at)
$	'f$extr(0, eqloc, at)'='f$extr(eqloc + 1, f$len(at), at)'
$	i=i+1
$	goto alignloop
$endalign:
$ del tmp:salign.awk;*
$ open /app out 'header'
$ if ALIGN_I4 .ne. 1
$ then	write out "# define BYTE_ALIGN"
$	write out "# define BA(a,i,b)	(((char *)&(b))[i] = ((char *)&(a))[i])"
$	write out "# define I2ASSIGN_MACRO(a,b) (BA(a,0,b), BA(a,1,b))"
$	write out "# define I4ASSIGN_MACRO(a,b) (BA(a,0,b), BA(a,1,b), BA(a,2,b), BA(a,3,b))"
$	write out "# define I8ASSIGN_MACRO(a,b) (BA(a,0,b), BA(a,1,b), BA(a,2,b), \"
$	write out "		BA(a,3,b), BA(a,4,b), BA(a,5,b), BA(a,6,b), BA(a,7,b))"
$	write out "# define F4ASSIGN_MACRO(a,b) (BA(a,0,b), BA(a,1,b), BA(a,2,b), BA(a,3,b))"
$	write out "# define F8ASSIGN_MACRO(a,b) (BA(a,0,b), BA(a,1,b), BA(a,2,b), \"
$	write out "		BA(a,3,b), BA(a,4,b), BA(a,5,b), BA(a,6,b), BA(a,7,b))"
$ else
$	write out "# define I2ASSIGN_MACRO(a,b) ((*(i2 *)&b) = (*(i2 *)&a))"
$	write out "# define I4ASSIGN_MACRO(a,b) ((*(i4 *)&b) = (*(i4 *)&a))"
$	write out "# define I8ASSIGN_MACRO(a,b) ((*(i8 *)&b) = (*(i8 *)&a))"
$	write out "# define F4ASSIGN_MACRO(a,b) ((*(f4 *)&b) = (*(f4 *)&a))"
$	write out "# define F8ASSIGN_MACRO(a,b) ((*(f8 *)&b) = (*(f8 *)&a))"
$ endif
$ if	SALIGN_F8 .eq. 7
$ then	write out "# define ALIGN_RESTRICT   double"
$ else	if SALIGN_F8 .eq. 1
$ then	write out "# define ALIGN_RESTRICT   short"
$ else	if SALIGN_F8 .eq. 0
$ then	write out "# define ALIGN_RESTRICT   char"
$ else	write out "# define ALIGN_RESTRICT   int"
$ endif
$ endif
$ endif
$!
$! If Compiler does not produce bit-fields ordered as on VAX
$!
$ pipe tidswap >tmp:readvar-mkbzarch.tmp
$ gosub readvar
$ if varvalue .eqs. "TID_SWAPPED" then -
	write out "# define TID_SWAP"
$!
$! If chars are unsigned only:
$!
$!	The macro, ((i4)(x) <= MAXI1 ? (i4)(x) : ((i4)(x) - (MAXI1 + 1) * 2)),
$!	is valid for twos complement machines.
$!
$ pipe unschar >tmp:readvar-mkbzarch.tmp
$ gosub readvar
$ if "''varvalue'" .eqs. "unsigned"
$ then	write out "# define UNS_CHAR"
$	write out "# define I1_CHECK(x) ((i4)(x)<=MAXI1?(i4)(x):((i4)(x)-(MAXI1+1)*2))"
$ else	write out "# define I1_CHECK	(i4)"
$ endif
$ write out "/* 6.1 renamed this... */"
$ write out "# define I1_CHECK_MACRO( x )	I1_CHECK( (x) )"
$!
$!	Define the name of the character set being used.  This is
$!	used by cmtype.c to determine which table of values will be
$!	used to classify characters.  Choose one and only one of:
$!
$!	CSASCII		Standard ASCII
$!	CSDECMULTI	DEC Multinational
$!	CSDECKANJI	DEC kanji (double-byte CS)
$!	CSJIS		JIS kanji (double-byte CS)
$!	CSBURROUGHS 	Burroughs kanji (double-byte CS)
$!	CSIBM		IBM's Code Page 0 8 bit character set.
$!
$ if ((vers .eqs. "axm_vms") .or. (vers .eqs. "i64_vms"))
$ then
$	write out "# define CSDECMULTI"
$ endif
$!
$! 	Define LARGEFILE64 if this is a Large File enabled port.
$!	axp_osf does not need the conf_B64 option because it already
$!	supports large files with the standard file api's
$!
$!
$! 	Define BOUBLEBYTE if this is a DBCS enabled port.
$!
$ if "''IIVERS_conf_DBL'" .nes. "" then -
	write out "# define DOUBLEBYTE"
$!
$! 	Define INGRESII for Ingres II
$!
$ write out "# define INGRESII"
$!
$!	Define WORKGROUP_EDITION for Workgroup Edition
$!
$!	Define DEVELOPER_EDITION for Developer Edition
$!
$! If any math exceptions can't be continued, then we may need to
$! put in more handlers lower than we would if we could continue.
$! As declaring and deleting them isn't cheap, create an ifdef flag
$! to use around them.
$!
$!  see if <float.h> exists.
$!
$!
$! HAS_VARIADIC_MACROS - are variadic macros supported?
$!
$ set noon
$ 'CC' /noobj sys$input
# include <stdarg.h>

void
vfunc(int x, ...)
{
    int nothing;
}

int
main()
{
    int x = 0;

#define	vmac(x, ...) vfunc(x, __VA_ARGS__)

    vmac(x,1,2,3);
    return(0);
}
$ if $severity .eq. 1 then -
	write out "# define HAS_VARIADIC_MACROS"
$ set on
$ending:
$!
$! Some OS_THREADS platforms cannot successfully support
$! thread stack caching.  It can be turned off here by
$! defining xCL_NO_STACK_CACHING for your platform.
$! It's defined here, rather than in clsecret.h, so that
$! it can be picked up in st/crsfiles for processing dbms.crs.
$!
$ write out ""
$ write out "/* End of ''header' */"
$done:
$ close out
$ deas tmp
$ exit
$!
$readvar:
$ open /read varfile tmp:readvar-mkbzarch.tmp
$nextline:
$ read /end=closevar varfile varvalue
$ if varvalue .eqs. "" then goto nextline
$closevar:
$ close varfile
$ del tmp:readvar-mkbzarch.tmp;*
$ return
