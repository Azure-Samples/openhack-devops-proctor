#!/bin/bash

kvstore_usage () {
  echo
  echo "kvstore <command> [<namespace>] [arguments...]"
  echo "kvstore [-h|--help]"
  echo "kvstore [-v|--version]"
  echo
  echo "Interface for a file-based transactional kv store"
  echo
  echo "Commands:"
  echo "  ls"
  echo "  list"
  echo "    List kv stores (namespaces)."
  echo "  lsinfo"
  echo "    List kv stores (namespaces) and other information."
  echo "  keys <namespace>"
  echo "    List keys in a namespace."
  echo "  vals <namespace>"
  echo "    List values in a namespace."
  echo "  dump [-v] [-r] <namespace>"
  echo "    List key/values pairs in a namespace, formatted."
  echo "    -v (verbose) prints the namespace as a heading."
  echo "    -r (raw) prints the raw file, no formatting."
  echo "  get <namespace> <key>"
  echo "    Get value of key."
  echo "  set <namespace> <key> <value>"
  echo "    Set value of key."
  echo "  rm <namespace> <key>"
  echo "    Remove key from store."
  echo "  mv [-f] <namespace> <from_key> <to_key>"
  echo "    Move (rename) key.  Fails if the destination key already"
  echo "     exists, unless -f (force) is specified."
  echo "  drop <namespace>"
  echo "    Delete the namespace file."
  echo "  load"
  echo "    Used in conjunction with sourcing the file in:"
  echo "     . \$PATH/TO/kvstore.sh load "
  echo "    or "
  echo "     source \$PATH/TO/kvstore.sh load"
  echo "    Tells the kvstore call at the end of the script not to do anything"
  echo "    because we are loading all the functions into memory for faster"
  echo "    execution later on. Add one of the above to your shell profile."
  echo
  echo "Environmental Variables:"
  echo "  KVSTORE_DIR"
  echo "    Directory where file stores will be kept, defaults to '\$HOME/.kvstore'."
  echo
  echo "Shell Initialization"
  echo "  For command completion, add the following to your shell profile:"
  echo "  # File: Shell Profile"
  echo "  \$(kvstore shellinit)"
  echo
  echo "Version - 3.0.2"
  ## Make sure to sync with the version printed below for the -v option
}

_kvstore_ns_check () {
  if [[ "$1" =~ \.lock$ ]]; then
    echo "namespace cannot end in .lock, reserved for lock protocol"
    return 1
  else
    return 0
  fi
}

_kvstore_path () {
  local file="$1"
  local dir="${KVSTORE_DIR:-$HOME/.kvstore}"
  mkdir -p "$dir"
  if [[ -z "$file" ]]; then
    echo "$dir"
  else
    echo "$dir/$file"
  fi
}

_kvstore_lock_then () {
  local lockfile="$1"
  local cmd="$2"
  shift
  shift
  if type flock &>/dev/null; then
    set -e
    (
      flock -w 5 -x 200
      "$cmd" "$@"
    ) 200>"$lockfile"
    set +e
    return
  elif type shlock &>/dev/null; then
    set -e
    shlock -f "$lockfile" -p $$
    "$cmd" "$@"
    rm -f "$lockfile"
    set +e
    return
  fi

  echo "error: could not find 'flock' or 'shlock' in PATH.  This is needed to ensure kvstore integrity." >&2
  return 1
}

_kvstore_echo_v_if_k_match() {
  local k="$1"
  local v="$2"
  local key="$3"
  if [[ "$k" == "$key" ]]; then
    found=1
    echo "$v"
  fi
}

_kvstore_echo_kv () {
  local k="$1"
  local v="$2"
  echo -n "$k"
  echo -ne "\t"
  echo "$v"
}

_kvstore_echo_kv_if_k_nomatch() {
  local k="$1"
  local v="$2"
  local key="$3"
  if [[ "$k" != "$key" ]]; then
    _kvstore_echo_kv "$k" "$v"
  fi
}

_kvstore_each_file_kv () {
  local file="$1"
  local cmd="$2"
  shift
  shift
  local OLDIFS="$IFS"
  IFS=$'\n'
  for line in $(cat "$file"); do
    IFS="$OLDIFS"
    local k=$(echo "$line" | cut -f1)
    local v=$(echo "$line" | cut -f2)
    "$cmd" "$k" "$v" "$@"
  done
}

_kvstore_nonatomic_mv () {
  local force=0
  [[ "$1" = '-f' ]] && force=1 && shift
  local path="$1"
  local key_from="$2"
  local key_to="$3"
  local val="$4"
  local tmp="${path}.tmp.knmv.$$"
  _kvstore_each_file_kv "$path" _kvstore_echo_kv_if_k_nomatch "$key_from" > "$tmp"
  if ((force)); then
    _kvstore_nonatomic_rm "$tmp" "$key_to"
  fi
  _kvstore_echo_kv "$key_to" "$val" >> "$tmp"
  mv -f "$tmp" "$path"
}

_kvstore_nonatomic_set () {
  local path="$1"
  local key="$2"
  local val="$3"
  local tmp="${path}.tmp.knset.$$"
  _kvstore_each_file_kv "$path" _kvstore_echo_kv_if_k_nomatch "$key" > "$tmp"
  _kvstore_echo_kv "$key" "$val" >> "$tmp"
  mv -f "$tmp" "$path"
}

_kvstore_nonatomic_rm () {
  local path="$1"
  local key="$2"
  local tmp="${path}.tmp.knrm.$$"
  _kvstore_each_file_kv "$path" _kvstore_echo_kv_if_k_nomatch "$key" > "$tmp"
  mv -f "$tmp" "$path"
}

kvstore_ls () {
  local dir
  dir=$(_kvstore_path)
  for file in $dir/*; do
    [[ -f "$file" ]] && \
      ! [[ "$file" =~ \.lock$ ]] && \
      basename "$file"
  done
}

kvstore_lsinfo () {
  local dir
  dir=$(_kvstore_path)
  for file in $dir/*; do
    if ! [[ "$file" =~ \.lock$ ]] && \
        ! [[ "$file" =~ \.tmp\.k.*$ ]] ;then
      basename "$file"
      printf '    entries:%-5d' $(cat "$file" | wc -l)
      if type stat &>/dev/null; then
        stat --printf=' bytes:%-5s Last updated:%y' "$file"
      fi
      echo
    fi
  done
}

_kvstore_get_either () {
  local cutarg=$1; shift
  local ns="$1"
  [[ -z "$ns" ]] && echo "Missing param: namespace" >&2 && return 1
  local path
  path=$(_kvstore_path "$ns")
  if [[ ! -f "$path" ]]; then
    echo "Error: path not found: $path" >&2
    return 2
  fi
  cut $cutarg < "$path"
}

kvstore_keys () {
  _kvstore_get_either -f1 "$@"
}

kvstore_vals () {
  _kvstore_get_either -f2 "$@"
}

kvstore_get () {
  local ns="$1"
  [[ -z "$ns" ]] && echo "Missing param: namespace" >&2 && return 1
  local key="$2"
  [[ -z "$key" ]] && echo "Missing param: key" >&2 && return 1
  local file
  file=$(_kvstore_path "$ns")
  if [[ ! -f "$file" ]]; then
    echo "Error: namespace file not found: $ns" >&2
    return 2
  fi
  found=0
  _kvstore_each_file_kv "$file" _kvstore_echo_v_if_k_match "$key"
  if (( found == 0 )); then
    echo "Error: key not found in namespace $ns: $key" >&2
    return 1
  fi
}

kvstore_set () {
  local ns="$1"
  [[ -z "$ns" ]] && echo "Missing param: namespace" >&2 && return 1
  local key="$2"
  [[ -z "$key" ]] && echo "Missing param: key" >&2 && return 1
  local val="$3"
  [[ -z "$val" ]] && echo "Missing param: value" >&2 && return 1
  local path
  path=$(_kvstore_path "$ns")
  touch "$path"
  _kvstore_lock_then "${path}.lock" _kvstore_nonatomic_set "$path" "$key" "$val"
  return $?
}

kvstore_mv () {
  local force=''
  local more_opts=1
  local original
  local option
  local new

  while ((more_opts)) && [[ "$1" =~ ^- ]]
  do
    ## Strip all leading dashes here so that -foo and --foo can both
    ## be processed as 'foo'.
    original="$1"
    option="$1"
    new=''
    while [ ! "$new" = "$option" ] && [ ! "$option" = '--' ]
    do
      new=$option
      option=${option##-}
    done

    case $option in
      f ) force='-f'; shift;;
      -- ) more_opts=0; shift;;
      * )
        echo "$original is an invalid option. See kvstore --help"; exit 1;;
    esac
  done

  local ns="$1"
  [[ -z "$ns" ]] && echo "Missing param: namespace" >&2  && return 1
  local key_from="$2"
  [[ -z "$key_from" ]] && echo "Missing param: key_from" >&2  && return 1
  local key_to="$3"
  [[ -z "$key_to" ]] && echo "Missing param: key_to" >&2 && return 1

  local val
  val=$(kvstore_get "$ns" "$key_from")
  if ! kvstore_get "$ns" "$key_from" >/dev/null; then
    return 2
  fi
  if kvstore_get "$ns" "$key_to" &>/dev/null; then
    if ((!force)); then
      echo "Error: destination key already exists: $key_to" >&2
      return 3
    fi
  else
    ## If the key isn't there, unset force if it was set, so we can skip the
    ## removal from the target in the _mv below.
    force=''
  fi
  local path
  path=$(_kvstore_path "$ns")
  _kvstore_lock_then "${path}.lock" _kvstore_nonatomic_mv $force "$path" "$key_from" "$key_to" "$val"
}


kvstore_rm () {
  local ns="$1"
  [[ -z "$ns" ]] && echo "Missing param: namespace" >&2  && return 1
  local key="$2"
  [[ -z "$key" ]] && echo "Missing param: key to remove" >&2  && return 1
  if ! kvstore_get "$ns" "$key" >/dev/null; then
    return 2
  fi
  local path
  path=$(_kvstore_path "$ns")
  _kvstore_lock_then "${path}.lock" _kvstore_nonatomic_rm "$path" "$key"
}

kvstore_shellinit() {
  local ns="$1"
  declare -i local cpos=1
  declare -i local npos=2
  local cmd="${ns:-kvs}"
  echo "_${ns}_kvstore_complete () {
  declare -i local pos=\$COMP_CWORD
  local cw=\${COMP_WORDS[\$pos]}
  local ns=\"$ns\"
  if [[ -z \"\$ns\" ]] && (( pos > $npos )); then
    ns=\${COMP_WORDS[$npos]}
  fi
  #echo \"ns=\$ns,pos=\$pos,comp=\${COMP_WORDS[@]}\"
  if (( pos == $cpos )); then
    COMPREPLY=( \$( compgen -W \"load ls list lsinfo keys vals get set rm mv shellinit drop dump\" -- \$cw) )
  else
    local OLDIFS=\$IFS
    IFS=\$'\\n'
    COMPREPLY=( \$( compgen -W \"\$(kvstore ls \$ns)\" -- \$cw) )
    IFS=\$OLDIFS
  fi
}
export -f _${ns}_kvstore_complete
$cmd () {
  local ns=\"$ns\"
  if [[ -z \"\$ns\" ]]; then
    kvstore \"\$@\"
    return \$?
  else
    local cmd=\"\$1\"
    shift
    kvstore \"\$cmd\" \"\$ns\" \"\$@\"
    return \$?
  fi
}
complete -F _${ns}_kvstore_complete $cmd"
  if [[ -z "$ns" ]]; then
    echo "complete -F __kvstore_complete kvstore"
  fi
}

kvstore_drop () {
  local ns="$1"
  [[ -z "$ns" ]] && echo "Missing param: namespace" >&2 && return 1
  path=$(_kvstore_path "$ns")
  command rm ${path} ## 'command' avoids any aliases or shell functions defined
                     ## by the user.
  local status=$?
  if((status==0))
  then
    \rm -rf "${path}.lock"
  fi
  return $status
}

kvstore_dump () {
  local verbose=0
  local raw=0
  local more_opts=1
  local original
  local option
  local new

  while ((more_opts)) && [[ "$1" =~ ^- ]]
  do
    ## Strip all leading dashes here so that -foo and --foo can both
    ## be processed as 'foo'.
    original="$1"
    option="$1"
    new=''
    while [ ! "$new" = "$option" ] && [ ! "$option" = '--' ]
    do
      new=$option
      option=${option##-}
    done

    case $option in
      v ) verbose=1; shift;;
      r ) raw=1; shift;;
      -- ) more_opts=0; shift;;
      * )
        echo "$original is an invalid option. See kvstore --help"; exit 1;;
    esac
  done

  local ns="$1"
  [[ -z "$ns" ]] && echo "Missing param: namespace" >&2 && return 1
  ((verbose)) && echo "$(basename $ns):"
  path=$(_kvstore_path "$ns")
  ((raw)) && cat ${path} || \
  cat ${path} | sed -e 's/^/"/' -e's/\t/"=>"/' -e 's/$/"/'
  return $?
}

kvstore () {
  local cmd="$1"
  if [[ -z "$cmd" ]]; then
    echo "Error: Command not specified" >&2
    echo "kvstore -h to see usage" >&2
    return 1
  fi
  shift

  case "$cmd" in
    -h|--help)
      kvstore_usage
      return 0
      ;;
    -v|--version)
      echo 3.0.2
      ## Make sure to keep in sync with the version in the usage statement above.
      return 0
      ;;
    load)
      if [[ "$(basename -- $0)" =~ kvstore ]]
      then
        echo "Warning: it looks like you are just running"
        echo "         the $0 script and not sourcing it"
        echo "         into the environment. The correct"
        echo "         usage for the load command is"
        echo
        echo "         . $0 load"
        echo
        return 1
      else
        return 0             ## Do nothing if sourcing into environment.
      fi
      ;;
    ls | list)
      kvstore_ls "$@"        ## namespace
      return $?
      ;;
    lsinfo)
      kvstore_lsinfo "$@"    ## namespace
      return $?
      ;;
    keys)
      kvstore_keys "$@"      ## namespace
      return $?
      ;;
    vals)
      kvstore_vals "$@"      ## namespace
      return $?
      ;;
    get)
      kvstore_get "$@"       ## namespace key
      return $?
      ;;
    set)
      kvstore_set "$@"       ## namespace key value
      return $?
      ;;
    rm)
      kvstore_rm "$@"        ## namespace key
      return $?
      ;;
    mv)
      kvstore_mv "$@"        ## [-f] namespace from_key to_key
      return $?
      ;;
    shellinit)
      kvstore_shellinit "$@" ## namespace
      return 0
      ;;
    drop)
      kvstore_drop "$@"      ## namespace
      return $?
      ;;
    dump)
      kvstore_dump "$@"      ## [-v] [-r] namespace
      return $?
      ;;
    *)
      echo "Error: Unrecognized command: $cmd" >&2
      echo "kvstore -h to see usage" >&2
      return 1
      ;;
  esac
}
kvstore "$@"
[[ "$1" != 'load' ]] && exit $?