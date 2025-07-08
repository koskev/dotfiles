[[ -e ${ZDOTDIR:-~}/.antidote ]] ||
  git clone https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote

# Source antidote.
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# Initialize antidote's dynamic mode, which changes `antidote bundle`
# from static mode.
source <(antidote init)
# Deferred loading
antidote bundle romkatv/zsh-defer
# Load the oh-my-zsh's library.
antidote bundle ohmyzsh/ohmyzsh path:lib
antidote bundle ohmyzsh/ohmyzsh path:plugins/git
antidote bundle ohmyzsh/ohmyzsh path:plugins/svn


antidote bundle qwelyt/endless-dog

antidote bundle superbrothers/zsh-kubectl-prompt

zsh-defer antidote bundle zsh-users/zsh-autosuggestions
zsh-defer antidote bundle junegunn/fzf path:shell
zsh-defer antidote bundle zsh-users/zsh-completions

# Syntax highlighting bundle. Should be the last plugin
zsh-defer antidote bundle zsh-users/zsh-syntax-highlighting
