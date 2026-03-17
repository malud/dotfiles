#!/usr/bin/env bash
# Claude Code status line — Catppuccin Mocha themed

input=$(cat)

# ---------------------------------------------------------------------------
# Catppuccin Mocha palette (24-bit ANSI)
# ---------------------------------------------------------------------------
reset='\033[0m'
bold='\033[1m'

# Foreground helpers: \033[38;2;R;G;Bm
fg() { printf '\033[38;2;%s;%s;%sm' "$1" "$2" "$3"; }
bg() { printf '\033[48;2;%s;%s;%sm' "$1" "$2" "$3"; }

# Named colors
c_mauve=$(fg 203 166 247)       # #cba6f7
c_blue=$(fg 137 180 250)        # #89b4fa
c_green=$(fg 166 227 161)       # #a6e3a1
c_yellow=$(fg 249 226 175)      # #f9e2af
c_peach=$(fg 250 179 135)       # #fab387
c_red=$(fg 243 139 168)         # #f38ba8
c_teal=$(fg 148 226 213)        # #94e2d5
c_lavender=$(fg 180 190 254)    # #b4befe
c_text=$(fg 205 214 244)        # #cdd6f4
c_subtext=$(fg 166 173 200)     # #a6adc8
c_overlay=$(fg 127 132 156)     # #7f849c
c_surface2=$(fg 88 91 112)      # #585b70

sep="${c_surface2}|${reset}"

# ---------------------------------------------------------------------------
# Parse JSON fields
# ---------------------------------------------------------------------------
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')
model=$(echo "$input" | jq -r '.model.display_name // .model.id // "unknown"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# ---------------------------------------------------------------------------
# Segment: Vim mode
# ---------------------------------------------------------------------------
if [ -n "$vim_mode" ]; then
  case "$vim_mode" in
    INSERT) mode_color="$c_green";  mode_icon=" I" ;;
    NORMAL) mode_color="$c_mauve";  mode_icon="󰮐 N" ;;
    *)      mode_color="$c_yellow"; mode_icon=" $vim_mode" ;;
  esac
  mode_seg="${bold}${mode_color}${mode_icon}${reset}"
else
  mode_seg=""
fi

# ---------------------------------------------------------------------------
# Segment: Model (short symbols)
# ---------------------------------------------------------------------------
case "$model" in
  *[Oo]pus*)   model_short="󰏖 Opus" ;  model_color="$c_mauve"    ;;
  *[Ss]onnet*) model_short="󰸥 Sonnet" ; model_color="$c_blue"     ;;
  *[Hh]aiku*)  model_short="󱂈 Haiku" ;  model_color="$c_teal"     ;;
  *)           model_short=" $model" ; model_color="$c_blue"     ;;
esac
model_seg="${model_color}${model_short}${reset}"

# ---------------------------------------------------------------------------
# Segment: Working directory (basename only, keep it short)
# ---------------------------------------------------------------------------
if [ -n "$cwd" ]; then
  dir_name=$(basename "$cwd")
  dir_seg="${c_teal} ${dir_name}${reset}"
fi

# ---------------------------------------------------------------------------
# Segment: Context window — cat animation progress bar
# ---------------------------------------------------------------------------
bar_seg=""
if [ -n "$used_pct" ]; then
  used_int=$(printf '%.0f' "$used_pct")
  remaining_int=$((100 - used_int))

  # Bar dimensions
  bar_width=20
  filled=$(( used_int * bar_width / 100 ))
  [ "$filled" -gt "$bar_width" ] && filled=$bar_width
  empty=$(( bar_width - filled ))

  # Color the bar based on usage
  if [ "$used_int" -lt 50 ]; then
    bar_color="$c_green"
  elif [ "$used_int" -lt 75 ]; then
    bar_color="$c_yellow"
  elif [ "$used_int" -lt 90 ]; then
    bar_color="$c_peach"
  else
    bar_color="$c_red"
  fi

  # Icons
  line_char=$'\U000F048B'                    # nf-md-minus (U+F048B)
  cat_char=$'\U000F011B'                     # nf-md-cat (U+F011B)
  fish_char=$'\U000F023A'                    # nf-md-fish (U+F023A)

  # Build bar with line chars
  bar_filled=""
  for (( i=0; i<filled; i++ )); do bar_filled+="${line_char}"; done
  bar_empty=""
  for (( i=0; i<empty; i++ )); do bar_empty+="${line_char}"; done

  # Cat color shifts with usage
  if [ "$used_int" -lt 50 ]; then
    cat_icon="${c_green}${cat_char}${reset}"
  elif [ "$used_int" -lt 70 ]; then
    cat_icon="${c_yellow}${cat_char}${reset}"
  elif [ "$used_int" -lt 90 ]; then
    cat_icon="${c_peach}${cat_char}${reset}"
  else
    cat_icon="${c_red}${cat_char}${reset}"
  fi

  # Fish disappears at 90%+
  if [ "$used_int" -lt 90 ]; then
    fish_icon="${c_blue}${fish_char}${reset}"
  else
    fish_icon=""
  fi

  bar_seg="${c_overlay}[${bar_color}${bar_filled}${cat_icon}${c_surface2}${bar_empty}${fish_icon}${c_overlay}]${reset} ${bar_color}${used_int}%${reset}${c_subtext} ctx${reset}"
fi

# ---------------------------------------------------------------------------
# Segment: gitui hint (only when inside a git repo)
# ---------------------------------------------------------------------------
git_seg=""
gh_seg=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    git_seg="${c_lavender} ${branch}${reset} ${c_overlay}gitui${reset}"
  fi

  # GitHub PRs scoped to this repo
  remote_url=$(git -C "$cwd" remote get-url origin 2>/dev/null)
  if [ -n "$remote_url" ]; then
    # Extract owner/repo from SSH or HTTPS URL
    repo_nwo=$(echo "$remote_url" | sed -E 's#^(https?://github\.com/|git@github\.com:)##; s/\.git$//')
    if [ -n "$repo_nwo" ]; then
      gh_user=$(gh api user --jq '.login' 2>/dev/null)
      if [ -n "$gh_user" ]; then
        review_count=$(gh pr list -R "$repo_nwo" --search "review-requested:${gh_user}" --state open --json number --jq 'length' 2>/dev/null || echo 0)
        authored_count=$(gh pr list -R "$repo_nwo" --author "$gh_user" --state open --json number --jq 'length' 2>/dev/null || echo 0)
        review_count=${review_count:-0}
        authored_count=${authored_count:-0}
        if [ "$review_count" -gt 0 ] || [ "$authored_count" -gt 0 ]; then
          gh_seg="${c_text} ${reset} ${c_peach}${review_count}${reset}${c_overlay}/${reset}${c_blue}${authored_count}${reset}"
        fi
      fi
    fi
  fi
fi

# ---------------------------------------------------------------------------
# Assemble the line
# ---------------------------------------------------------------------------
parts=()

[ -n "$mode_seg" ]    && parts+=("$mode_seg")
[ -n "$model_seg" ]   && parts+=("$model_seg")
[ -n "$dir_seg" ]     && parts+=("$dir_seg")
[ -n "$bar_seg" ]     && parts+=("$bar_seg")
[ -n "$git_seg" ]     && parts+=("$git_seg")
[ -n "$gh_seg" ]      && parts+=("$gh_seg")

line=""
for i in "${!parts[@]}"; do
  if [ "$i" -eq 0 ]; then
    line="${parts[$i]}"
  else
    line="${line} ${sep} ${parts[$i]}"
  fi
done

printf "%b\n" "$line"
