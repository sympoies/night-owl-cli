# 🌙 Night Owl theme for tmux
#
# This file only styles colours and the status line — your prefix key,
# terminal type, and other behaviour stay yours. Source it from your own
# ~/.tmux.conf:
#
#   source-file ~/.config/tmux/night-owl.tmux
#
# Night Owl uses 24-bit hex colours. For exact rendering, enable truecolor,
# e.g. in your ~/.tmux.conf:
#
#   set -as terminal-features ",*:RGB"

##### Pane Borders #####
set-option -g pane-border-style fg=#1d3b53
set-option -g pane-active-border-style fg=#82aaff

##### Status Bar #####
set-option -g status on
set-option -g status-interval 2
set-option -g status-justify centre
set-option -g status-style bg=#0c2340,fg=#d6deeb

##### Status Left #####
set-option -g status-left-length 40
set-option -g status-left "#[bg=#2d5a91,fg=#ffcb6b,bold] 🌓 #S #[bg=#0c2340,fg=#d6deeb,nobold]"

##### Status Right #####
set-option -g status-right-length 120
set-option -g status-right \
  "#[fg=#0c2340,bg=#7fdbca,bold]#[fg=#0c2340,bg=#7fdbca] %Y-%m-%d \
#[fg=#0c2340,bg=#ecc48d,bold]#[fg=#0c2340,bg=#ecc48d] %H:%M:%S \
#[fg=#0c2340,bg=#c792ea,bold]#[fg=#0c2340,bg=#c792ea] #H \
#[fg=#c792ea,bg=#0c2340,nobold]"

##### Window Tabs #####
setw -g window-status-style bg=#0c2340,fg=#637777
setw -g window-status-format " #I:#W "
setw -g window-status-current-style bg=#2d5a91,fg=#addb67,bold
setw -g window-status-current-format " #[bg=#2d5a91,fg=#addb67]⮕ #I:#W #[default]"

##### Message Pane #####
set-option -g message-style bg=#0c2340,fg=#ffffff
