#!/usr/bin/env bash
# tmux-resurrect post-save-all hook: record which Claude session each pane holds.
out="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect/claude-panes.tsv"
tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}	#{@claude_session_id}' |
	awk -F'\t' '$2 != ""' > "$out.tmp" && mv "$out.tmp" "$out"
