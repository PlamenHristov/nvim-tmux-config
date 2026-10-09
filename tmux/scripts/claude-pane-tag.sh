#!/usr/bin/env bash
# Claude Code SessionStart hook: tag the tmux pane with the Claude session id
# so tmux-resurrect can resume the same conversation after a restore.
[ -n "$TMUX_PANE" ] || exit 0
id=$(jq -r '.session_id // empty' 2>/dev/null)
[ -n "$id" ] && tmux set -p -t "$TMUX_PANE" @claude_session_id "$id" 2>/dev/null
exit 0
