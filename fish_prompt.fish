function fish_prompt

    printf '\n'

    set_color $fish_color_cwd_root
    printf '  '

    # print base dir

    if test $PWD = "/" >/dev/null 2>/dev/null
        set_color --bold $fish_color_cwd_root
        printf \/
    else if test $PWD = $HOME >/dev/null 2>/dev/null
        set_color --bold blue
        printf \~
    else
        set_color --bold blue
        printf (basename $PWD)
    end
    printf ' '


    # print git status

    if git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null

        if test -z (git status --porcelain) >/dev/null 2>/dev/null

            # print clean status

            set_color normal
            printf ' '
            printf (git symbolic-ref --short HEAD; or false); printf ' '

        else

            # print dirty status

            set_color normal
            set_color yellow
            printf ' '
            printf (git symbolic-ref --short HEAD; or false); printf ' '

        end
    end
    printf ' '

    # print indicator

    set_color normal
    printf '⋅ '

end
