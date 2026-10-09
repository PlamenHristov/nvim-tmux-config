#!/usr/bin/env bash
# Run by tmux-resurrect in a restored pane: resume the Claude session that pane held.
map="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect/claude-panes.tsv"
args=()
while [ $# -gt 0 ]; do
	case "$1" in
		-c|--continue) ;;
		-r|--resume) case "$2" in ""|-*) ;; *) shift ;; esac ;;
		--resume=*) ;;
		*) args+=("$1") ;;
	esac
	shift
done
id=""
if [ -n "$TMUX_PANE" ] && [ -f "$map" ]; then
	key=$(tmux display -p -t "$TMUX_PANE" '#{session_name}:#{window_index}.#{pane_index}')
	id=$(awk -F'\t' -v k="$key" '$1 == k { print $2 }' "$map")
fi
if [ -n "$id" ] && ls "$HOME"/.claude/projects/*/"$id".jsonl >/dev/null 2>&1; then
	# tag now so a save before Claude's own hook fires keeps the mapping
	tmux set -p -t "$TMUX_PANE" @claude_session_id "$id" 2>/dev/null
	exec claude --resume "$id" "${args[@]}"
fi
exec claude "${args[@]}"
