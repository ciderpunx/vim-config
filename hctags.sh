#! /bin/sh
# generate haskell and other ctags stuff.
# put in /usr/local/bin
# also install exhuberant-ctags and hasktags before use

# GITDIR=$(git rev-parse --git-dir)
GITDIR=.
#TAGSFILE=tags.$$
TAGSFILE=tags.tmp

mkdir $GITDIR/tags_lock 2>/dev/null || exit 0
trap "rmdir $GITDIR/tags_lock; rm $GITDIR/$TAGSFILE" EXIT

# normal ctags
ctags --tag-relative -Rf $GITDIR/$TAGSFILE --exclude=$GITDIR

# haskell ctags
if which hasktags > /dev/null ; then
  OLD_DIR=$(pwd)
  (cd $GITDIR && hasktags -c -x --ignore-close-implementation -a -f $TAGSFILE $OLD_DIR)
  LC_COLLATE=C sort $GITDIR/$TAGSFILE -o $GITDIR/$TAGSFILE
fi

mv $GITDIR/$TAGSFILE $GITDIR/tags
