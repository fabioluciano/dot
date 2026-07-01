alias du="ncdu --color dark"
alias ls='eza --icons --git'
alias ll='eza -l --icons --git'
alias la='eza -la --icons --git'
alias lt='eza --tree --icons --git'
alias tree='eza --tree --icons --git'
alias l='ll'
alias cat='bat'
alias df='duf'
alias ps='procs'
command -v viddy &>/dev/null && alias watch='viddy'

wttr() { curl -s "wttr.in/${1:-}"; }

alias g='git'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'

alias k='kubectl'
alias kn='kubectl ns'
alias kx='kubectl ctx'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deployments'
alias kdp='kubectl describe pod'
alias kl='kubectl logs'
alias kaf='kubectl apply -f'
alias kdel='kubectl delete'

alias vim='nvim'
alias vi='nvim'
alias v='nvim'

if command -v xsel &>/dev/null; then
  alias pbcopy='xsel --clipboard --input'
  alias pbpaste='xsel --clipboard --output'
elif command -v xclip &>/dev/null; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

alias reload='exec zsh'
alias zshconfig='nvim ~/.zshrc'
alias cls='clear'
