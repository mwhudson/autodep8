if [ -z "$ADTTMP" ]; then
  # only use local binaries if not testing the instaled package
  export PATH="$(readlink -f $(dirname $0))/..:$PATH"
fi

run() {
  exitstatus=0
  "$@" > stdout 2> stderr || exitstatus=$?
}

check_run() {
  run "$@"
  assertEquals "$@ failed!\n$(tail -n 10000 stderr stdout;)\n" 0 "$exitstatus"
}

has() {
  file="$1"
  shift
  mkdir -p $(dirname "$file")
  if [ $# -gt 0 ]; then
    printf "$@" > "$file"
    echo >> "$file"
  else
    touch "$file"
  fi
}

has_dir() {
  mkdir -p "$@"
}

show() {
  tail -n 100000 "$@"
}

setUp() {
  tmpdir=$(mktemp -d)
  cd "$tmpdir"
}

origdir=$(pwd)
tearDown() {
  cd "$origdir"
  rm -rf "$tmpdir"
}

