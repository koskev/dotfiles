[[ -e ${ZDOTDIR:-~}/.antidote ]] ||
  git clone https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote

# Source antidote.
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# Initialize antidote's dynamic mode, which changes `antidote bundle`
# from static mode.
source <(antidote init)
# Load the oh-my-zsh's library.
antidote bundle ohmyzsh/ohmyzsh path:lib
antidote bundle ohmyzsh/ohmyzsh path:plugins/git
antidote bundle ohmyzsh/ohmyzsh path:plugins/svn

# Syntax highlighting bundle.
antidote bundle zsh-users/zsh-syntax-highlighting

antidote bundle zsh-users/zsh-autosuggestions

antidote bundle qwelyt/endless-dog
antidote bundle junegunn/fzf path:shell
