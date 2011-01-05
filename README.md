## Installation

>`gem install homesick
>homesick clone stuartj/dotfiles
>homesick symlink stuartj/dotfiles`

### Possible install snags

*No ruby support in installed Vim causes plugins (e.g. CommandT and Lusty Juggler) to complain.*

>Check:
>
>> `vim --version | grep '\+ruby'`
>
>If nothing (in Ubuntu), install package for vim with ruby support compiled in:
>
>> `sudo apt-get install vim-gtk`

