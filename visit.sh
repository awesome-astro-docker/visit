#!/bin/sh
###############################################################################
#
# Purpose:
#   This is the primary front end launcher for programs in the VisIt toolchain.
#   It is separate from the pieces than change on a per-version basis. This 
#   script's job is to load frontendlauncher.py using VisIt's python interpreter.
#
#   NOTE: The "current" link, when it is present, will be used to select the 
#         Python interpreter. When "current" does not exist, the script will
#         iterate through some possible version numbers, keeping the latest
#         that has a Python interpreter.
#
# Programmer:  Brad Whitlock
# Date      :  Wed Mar 13 11:25:42 PDT 2013
#
# Modifications:
#   Jeremy Meredith, Wed Mar 20 14:57:54 EDT 2013
#   More sh-compliant version of tests.
#
#   Brad Whitlock, Wed Apr  3 14:48:05 PDT 2013
#   Set LD_LIBRARY_PATH so VisIt's python interpreter will work.
#
#   Eric Brugger, Tue Dec 10 14:06:38 PST 2013
#   Modified the script to use the the python that goes with the version of
#   visit specified rather than the python that goes with the newest visit.
#
###############################################################################

# Determine VisIt architecture
osname=$(uname)
if test "$osname" = "Linux"; then
    proc=$(uname -m)
    if test "$proc" = "x86_64"; then
        platform="linux-x86_64"
    elif test "$proc" = "ppc"; then
        platform="linux-ppc"
    elif test "$proc" = "ppc64"; then
        platform="linux-ppc64"
    else
        platform="linux-intel"
    fi
elif test "$osname" = "Darwin"; then
    platform="darwin-x86_64"
elif test "$osname" = "AIX"; then
    if test "$OBJECT_MODE" = "32"; then
        platform="ibm-aix-pwr"
    else
        platform="ibm-aix-pwr64"
    fi
elif test "$osname" = "freebsd"; then
    version=$(uname -r)
    proc=$(uname -m)
    platform="freebsd-${version}-${$proc}"
else
    echo "$osname is not a supported platform."
    exit -1
fi

# Come up with a list of versions, starting with current
versions="current"
for minor in 9 8 7 6 5 4 3 2 1 0; do
    for patch in 4 3 2 1 0; do
        versions="$versions 3.$minor.$patch"
    done
done
for minor in 15 14 13 12 11 10 9 8 7 6; do
    for patch in 4 3 2 1 0; do
        versions="$versions 2.$minor.$patch"
    done
done

# Find the most recent VisIt python
visitpython=""
dir="$(dirname $0)"
for ver in $versions; do
    thispython="$dir/../$ver/$platform/bin/python"
    if test -x "$thispython"; then
        visitpython="$thispython"
        break
    fi
done

# If the user specified a specific version then use the python that
# goes with it. This logic is overly complex, but it leaves the command
# line arguments untouched. The first loop finds a version specified with
# -v, the second loop finds a version specified with -forceversion, and
# the last if test sets visitpython if a version was specified and the
# python that goes with it exists. 
version=""
have_version=no
for arg in $@
do
    if test "$have_version" = "yes"; then
        version=$arg
        have_version=no
    fi
    if test "$arg" = "-v"; then
        have_version=yes
    fi
done
have_version=no
for arg in $@
do
    if test "$have_version" = "yes"; then
        version=$arg
        have_version=no
    fi
    if test "$arg" = "-forceversion"; then
        have_version=yes
    fi
done
if test "$version" != ""; then
    thispython="$dir/../$version/$platform/bin/python"
    if test -x "$thispython"; then
        visitpython="$thispython"
    fi
fi

# Execute VisIt's Python or system Python, depending on what's available
frontendlauncherpy="$(dirname $0)/frontendlauncher.py"
unset PYTHONHOME
if test -n "$visitpython"; then
    visitdir="$(dirname $(dirname $visitpython))"

    # Which Python was VisIt built against? Look for python<ver> executable
    # next to the python binary we located already.
    pyver=""
    for ver in 2.4 2.5 2.6 2.7; do
        if test -x "$visitpython$ver"; then
            pyver=$ver
            break
        fi
    done

    # VisIt's Python interpreter probably uses a shared Python library.
    if test -n "$LD_LIBRARY_PATH" ; then
        export LD_LIBRARY_PATH="$visitdir/lib:$LD_LIBRARY_PATH"
    else
        export LD_LIBRARY_PATH="$visitdir/lib"
    fi

    # Set up Python variables so the binary will look for modules in their new
    # home inside the VisIt installation instead of where Python was compiled.
    if test -d "$visitdir/lib/python" ; then
        export PYTHONHOME="$visitdir/lib/python"
        unset PYTHONPATH
        export PYTHONPATH="$PYTHONHOME/lib/python$pyver:$PYTHONHOME/lib/python$pyver/lib-dynload"
    fi

    >&2 echo "VisIt Python: $visitpython $frontendlauncherpy $0 ${1+"$@"}"
    >&2 echo "zero-bucks: $0"
    >&2 echo "at-bucks: ${1+"$@"}"

    exec "$visitpython" $frontendlauncherpy $0 ${1+"$@"}
else
    >&2 echo "System python $frontendlauncherpy $0 ${1+"$@"}"
    >&2 echo "zero-bucks: $0"
    >&2 echo "at-bucks: ${1+"$@"}"

    exec python $frontendlauncherpy $0 ${1+"$@"}
fi
$0 = shift @ARGV;
