function fish_prompt

    printf '\n'

    set_color $fish_color_cwd_root
    printf '  '

    # print base dir

    if test $PWD = / >/dev/null 2>/dev/null
        # print root directory

        set_color --bold --italics $fish_color_cwd_root
        printf \/
    else if test $PWD = $HOME >/dev/null 2>/dev/null
        # print home directory

        set_color --bold --italics blue
        printf \~
    else
        # print current directory

        set_color --bold --italics blue
        printf (basename $PWD)
    end

    printf ' '

    # print git status

    if git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null
        if test -z (git status --porcelain) >/dev/null 2>/dev/null
            # clean colors

            set_color normal
            set_color --italics grey
        else
            # dirty colors

            set_color normal
            set_color --italics yellow
        end

        if test -z (git symbolic-ref -q --short HEAD) >/dev/null 2>/dev/null
            # print detached

            printf 'ⅹ @'
            printf (git rev-parse --short HEAD)
            printf ' '
        else
            # print branch

            printf ' '
            printf (git symbolic-ref --short HEAD; or false)
            printf ' '
        end
    end

    printf ' '

    # print indicator

    if test -n "$fish_private_mode"
        # print private status

        set_color magenta
        printf '⋅ '
    else
        # print standard status

        set_color normal
        printf '⋅ '
    end
end
