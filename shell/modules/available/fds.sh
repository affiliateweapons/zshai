fds() {
  CLS="fds"
  $CLS::default() {
    $CLS::limit
  }

  $CLS::limit() {
    cat /proc/sys/fs/file-nr
  }

  $CLS::stats() {
    by_number_of_fds() {
      local process_dir=${1-$REPLY}
      local -a fds=( $process_dir/fd/*(N) )
      REPLY=$#fds
    }
    process_dirs_sorted_by_number_of_fds=(
      /proc/<->(O+by_number_of_fds)
    )
    pid_with_most_fds=$process_dirs_sorted_by_number_of_fds[1]:t
  }

  subcommands $CLS $@

}
