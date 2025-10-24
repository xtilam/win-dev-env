def run-kill [cmd: string] {
  ^$cmd
  let pid = $last.pid

  try {
    wait $pid
  } catch {
    kill -9 $pid
  }
}
