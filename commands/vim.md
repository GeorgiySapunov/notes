|                     command                    |                                 explanation                                 |
|:----------------------------------------------:|:---------------------------------------------------------------------------:|
|                `:100` or `100G`                |                                go to 100 line                               |
|                  `H`, `M`, `L`                 |                     high middle and low cursor position                     |
|               `ctrl+b`, `ctrl+u`               |                                  scroll up                                  |
|               `ctrl+d`, `ctrl+f`               |                                 scroll down                                 |
|                    `ctrl+y`                    |                               scroll up slowly                              |
|                    `ctrl+e`                    |                              scroll down slowly                             |
|                `zt`, `zz`, `zb`                |            shift window to make cursor at top, middle and bottom            |
|                       `~`                      |                         switch case of the character                        |
|                       `%`                      |                                 next ( or )                                 |
|                    `{`, `}`                    |                         previous and next empty line                        |
|                    `f`, `F`                    |                    jump to syllable forward and backward                    |
|                    `t`, `T`                    |                  jump before syllable forward and backward                  |
|                    `;`, `,`                    |                     jump to the next and previous match                     |
|                       `$`                      |                              to end of the line                             |
|                       `0`                      |                         to the beginning of the line                        |
|                       `^`                      |             to the beginning of the first non-blank on the line             |
|                    `(`, `)`                    |                  to the beginning and end of the paragraph                  |
|                      `yy`                      |                                     yank                                    |
|                    `P`, `p`                    |                      paste before and after the cursor                      |
|                      `dd`                      |                                 delete line                                 |
|                    `D`, `d`                    |             delete to the end of the line and delete with motion            |
|                    `C`, `c_`                   |            correct to the end of the line and correct with motion           |
|                    `S`, `s`                    |    delete all line with correction and delete a syllable with correction    |
|                       `u`                      |                                     undo                                    |
|                    `V`, `v`                    |                    visual by lines and visual by syllable                   |
|                    `ctrl+v`                    |                            blockwise Visual mode                            |
|                    `ctrl+a`                    |             add [count] to the number or alphabetic character at            |
|               `{Visual}g ctrl+a`               |                   creating a [count] incrementing sequence                  |
|                  `{Visual} o`                  |   the cursor jumps from the beginning to the end of the highlighted block   |
|                    `O`, `o`                    |                          new line at top and bottom                         |
|                    `A`, `a`                    |              append at the end of the line and after the cursor             |
|                    `I`, `i`                    |              insert and the start of the line and at the cursor             |
|                    `/`, `?`                    |                          find forward and backward                          |
|                    `N`, `n `                   |                           previous and next found                           |
|                    `*`, `#`                    |             find the word under the cursor forward and backward             |
|                    `ctrl+6`                    |                       switch between last two buffers                       |
|               `ctrl+o`, `ctrl+i`               |                        jump to last and next position                       |
|                       `m`                      | bookmark local with lower case syllable and global with upper case syllable |
|                       `'`                      |                            go to bookmarked place                           |
|                       `q`                      |                                record a macro                               |
|                       `@`                      |                                 run a macro                                 |
|                   `ctrl+w v`                   |                                vertical split                               |
|                   `ctrl+w s`                   |                               horizontal split                              |
|                   `ctrl+w o`                   |                     close all windows except current one                    |
| `ctrl+w H`, `ctrl+w L`, `ctrl+w K`, `ctrl+w J` |         move the current window to left, right, top, bottom position        |
|                   `ctrl+w =`                   |                              make windows even                              |
|                   `ctrl+w r`                   |                                switch buffers                               |
|                   `ctrl+w \|`                  |                                maximize width                               |
|                   `ctrl+w _`                   |                               maximize height                               |
|                   `ctrl+w T`                   |                               split to new tab                              |
|                   `ctrl+w c`                   |                             close current window                            |
|                `Ctrl+x + Ctrl+f`               |                       autocomplete path in insert mode                      |
|               `Ctrl+n`, `Ctrl+p`               |              move up and down in the autocomplete dropdown menu             |
|                    `Ctrl+g`                    |                         prints the current file name                        |
|                      `gd`                      |                               go to definition                              |
|                      `gw`                      |                                 format line                                 |
|                      `gf`                      |                                  go to file                                 |
|                   `gt`, `gT`                   |                            next and previous tab                            |
|                   `zf`, `zd`                   |                           create and delete a fold                          |
|                `zc`, `zo`, `za`                |                    close, open, toggle one folding level                    |
|                `zC`, `zO`, `zA`                |                    close, open, toggle all folding levels                   |
