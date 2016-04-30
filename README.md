vim-hacks
=========

Plugin for vim's hackers, which allow to hijack autoload functions in
third-party plugins.

### Live example at vim-go

vim-go is the plugin for integration vim and golang utilities which provides
lintering, building and testing golang source code, when user runs `GoLint`
vim-go will open quickfix or location list with errors. But quickfix and
location list are very unsuitable for users which wanna be more effective,
so there are various plugins that wraps quickfix and provides usable and
effective interface, like as **CtrlP**.

**CtrlP** provides the command **CtrlPQuickfix** which we wanna open instead of
plain quickfix window.

Let's hack vim-go without patching vim-go's source code.

After a little bit research in vim-go source code we are conclude that quckfix
window opens by vim `go#list#Window` function, and jump to first item does by
`go#list#JumpToFirst` function.

Okay, we wanna redeclare this functions, but... if we try to declare function
like as following:

```viml
func! go#list#Window()
    ...
endfunc!
```

we get vim error **E746** which tell us about naming autoload functions in vim

`:help E746`

```help
The file name and the name used before the # in the function must match
exactly, and the defined function must have the name exactly as it will be
called.

It is possible to use subdirectories.  Every # in the function name works like
a path separator.  Thus when calling a function: >

	:call foo#bar#func()

Vim will look for the file "autoload/foo/bar.vim" in 'runtimepath'.
```

**vim-hack** is summoned for solving this unsolvable situation.

Let's create shiny new `go#list#` stuff and place them into file `go/list.vim`
at **vim-hack** hacks directory (`~/.vim/hacks/`) with following content:

```viml
func! go#list#Window(...)
    CtrlPQuickfix
endfunc!

func! go#list#JumpToFirst(...)
    " stop it.
endfunc!
```

and install **vim-hack** plugin, I use **plug.vim**, so I've added following
lines to my .vimrc:

```viml
Plug 'kovetskiy/vim-hacks'
```

and restart vim.

Let's try to run `:GoLint .`, and... ta-da!

**vim-hack** will see for a `.vim` files in `~/.vim/hacks/` directory and will
find the file `go/list.vim` with our functions, afterwards will look for original
`go/list.vim` file in vim `runtimepath` variable which sets by your plugin
manager for loading plugin, source original file and source our file, and yep,
two functions with namespace `go#list#` will successfully spoofed.

Look ma no hands!
