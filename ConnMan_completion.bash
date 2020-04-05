#!/usr/bin/env bash

main='ConnMan'

_ConnMan_completions()
{
  COMPREPLY=($(compgen -W "$(__compListGen "${COMP_WORDS[@]}")" -- "${COMP_WORDS[$COMP_CWORD]}"))
}

__compListGen() {
  __tree | __subTree "$@" | __expandServices | __dropChildren
}

__subTree() {
  # forward in to out if no args
  (( $# == 0 )) && tee && return

  # remove the last parameter if it's being completed
  (( $# == COMP_CWORD + 1 )) && set -- "${@:1:$(($# - 1))}"

  # process first entry and pipe recursively
  one=$1
  shift
  __getNode $one < /dev/stdin | __subTree "$@"
}

__getNode() {
  # all services match a common string in the heredoc
  [[ "$(command connmanctl services)" =~ $1 ]] && set -- '@services'
  # if first line matching $1 is followed by @repeat line,
  # print only these two; if not, print only lines beginning
  # with tab, up to the next line not beginning with tab
  sed -E '/(^| )'"$1"'( |$)/,/^[^\t]/{
            /^\t@repeat$/{H;x;p;Q}
            h
            /^\t/s/\t//p
          }
          d' /dev/stdin
}

__expandServices() {
  input=$(< /dev/stdin)
  case "$input" in
    [^@]* )
      echo "$input"
      ;;
    @services* )
      command connmanctl services | \
        sed -E 's/^[^ ]* *([^ ].*[^ ])  *[^ ]*$/\1/
                s/^ *//'
      ;;
    # the default case is not needed, as this case
    # statement is tightly bounded to the heredoc below
  esac
}

__dropChildren() {
  sed '/^\t/d' /dev/stdin
}

__tree() {
  # The heredoc below hardcodes connmanctl's completion tree.
  # The special entry @services refers to when connmanctl
  # completes with the available services, whereas the
  # entry @repeat refers to when connmanctl keeps giving
  # the same alternative completions as the for the last
  # word.
  cat <<EOF
$main
	agent
		on
		off
	clock
	config
		@services
			autoconnect domains ipv4 ipv6 mdns nameservers proxy remove timeservers
				@repeat
	connect
		@services
	disable
		ethernet
		offline
		wifi
	disconnect
		@services
	enable
		ethernet
		offline
		wifi
	exit
	help
	monitor
		manager
			on
			off
		services
			on
			off
		tech
			on
			off
		vpnconnection
			on
			off
		vpnmanager
			on
			off
	move-after
		@services
	move-before
		@services
	peer_service
	peers
	quit
	scan
		ethernet
		wifi
	services
		@services
	session
		bearers ctxid ifname srciprule type
			@repeat
	state
	technologies
	tether
		ethernet
			on
			off
		wifi
			on
			off
	tethering_clients
	vpnagent
		on
		off
	vpnconnections
EOF
}

complete -o default -F _ConnMan_completions $main
