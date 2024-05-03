[[ ! -z ${DEBUG+x} ]] && echo "Setting bindings"

bindkey '^ ' autosuggest-accept # Accept suggestion on Ctrl + Space
# bindkey '^I' autosuggest-accept # Accept suggestion on Tab or Ctrl + i Not good, it breaks tab completion
bindkey "^[[H" beginning-of-line # Home
bindkey "^[[F" end-of-line # End
# bindkey "^[[1;5D" vi-backward-word # Ctrl + left
# bindkey "^[[1;5C" vi-forward-word # Ctrl + right
# bindkey "^[[3~" delete-char # Delete
bindkey "^H" backward-kill-word # Ctrl + Backspace # Delete word behind the cursor
bindkey "^[[3;5~" kill-word # Ctrl + Delete # Delete word in front of the cursor

r-delregion() {
  if ((REGION_ACTIVE)) then
     zle kill-region
  else 
    local widget_name=$1
    shift
    zle $widget_name -- $@
  fi
}

r-deselect() {
  ((REGION_ACTIVE = 0))
  local widget_name=$1
  shift
  zle $widget_name -- $@
}

r-select() {
  ((REGION_ACTIVE)) || zle set-mark-command
  local widget_name=$1
  shift
  zle $widget_name -- $@
}

for key     kcap   seq        mode   widget (

    sleft   kLFT   $'\e[1;2D' select   backward-char
    sright  kRIT   $'\e[1;2C' select   forward-char
    sup     kri    $'\e[1;2A' select   up-line-or-history
    sdown   kind   $'\e[1;2B' select   down-line-or-history

    send1   kEND   $'\e[1;2F' select   end-of-line
    send2   x      $'\e[4;2~' select   end-of-line
    
    shome1  kHOM   $'\e[1;2H' select   beginning-of-line
    shome2  x      $'\e[1;2~' select   beginning-of-line

    left    kcub1  $'\eOD'    deselect backward-char
    right   kcuf1  $'\eOC'    deselect forward-char
    
    end1    kend   $'\eOF'    deselect end-of-line
    end2    x      $'\e4~'    deselect end-of-line
    
    home1   khome  $'\eOH'    deselect beginning-of-line
    home2   x      $'\e1~'    deselect beginning-of-line
    
    csleft  x      $'\e[1;6D' select   backward-word
    csright x      $'\e[1;6C' select   forward-word
    csend   x      $'\e[1;6F' select   end-of-line
    cshome  x      $'\e[1;6H' select   beginning-of-line
    
    cleft   x      $'\e[1;5D' deselect backward-word
    cright  x      $'\e[1;5C' deselect forward-word

    del     kdch1   $'\e[3~'  delregion delete-char
    bs      x       $'^?'     delregion backward-delete-char

  ) {
  eval "key-$key() {
    r-$mode $widget \$@
  }"
  zle -N key-$key
  bindkey ${terminfo[$kcap]-$seq} key-$key
}

# restore backward-delete-char for Backspace in the incremental
# search keymap so it keeps working there:
bindkey -M isearch '^?' backward-delete-char