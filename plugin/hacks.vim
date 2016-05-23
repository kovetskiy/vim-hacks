let g:hacks_directories = get(g:, "hacks_directories", glob("~/.vim/hacks"))
let g:hacks_on = get(g:, "hacks_on", ["VimEnter *"])

func! s:load_hack(hack_directory, full_path)
    let l:path = strpart(a:full_path, strlen(a:hack_directory))
    while l:path[0] == "/"
        let l:path = strpart(l:path, 1)
    endwhile

    let l:origin = "autoload/" . l:path

    execute "runtime" l:origin
    execute "source" a:full_path
endfunc!

func! s:load_hacks()
    if type(g:hacks_directories) == type([])
        for path in g:hacks_directories
            call s:load_hacks_directory(path)
        endfor
    else
        call s:load_hacks_directory(g:hacks_directories)
    endif
endfunc!


func! s:load_hacks_directory(path)
    let l:files = split(globpath(a:path, "**/*.vim"), "[\r\n]")
    for l:file in l:files
        call s:load_hack(a:path, l:file)
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
