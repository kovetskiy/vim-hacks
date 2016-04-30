let g:hacks_directory = get(g:, "hacks_directory", glob("~/.vim/hacks"))
let g:hacks_on = get(g:, "hacks_on", ["VimEnter *"])

func! s:load_hack(full_path)
    let l:path = strpart(a:full_path, strlen(g:hacks_directory))
    while l:path[0] == "/"
        let l:path = strpart(l:path, 1)
    endwhile

    let l:origin = "autoload/" . l:path

    execute "runtime" l:origin
    execute "source" a:full_path
endfunc!

func! s:load_hacks()
    let l:files = split(globpath(g:hacks_directory, "**/*.vim"), "[\r\n]")
    for l:file in l:files
        call s:load_hack(l:file)
    endfor
endfunc!

command! -bar
    \ Hack
    \ call s:load_hacks()

augroup _hacks
    au!
augroup end

for s:event in g:hacks_on
    execute "au " s:event "Hack"
endfor
