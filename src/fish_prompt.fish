function fish_prompt
    printf '\n'

    set_color --bold --italics red
    printf '%s@%s  ' (whoami) (prompt_hostname)

    # Current Directory

    if test "$PWD" = '/'
        # print root directory

        set_color --bold --italics brred
        printf '/  '
    else if test "$PWD" = "$HOME"
        # print home directory

        set_color --bold --italics blue
        printf '~  '
    else
        # print current directory

        set_color --bold --italics blue
        printf '%s  ' (path basename $PWD)
    end


    # Git Status

    if git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null
        if test -z (git status --porcelain --ignore-submodules | string collect --allow-empty)
            # colorize clean

            set_color normal
            set_color --italics brblack
        else
            # colorize dirty

            set_color normal
            set_color --italics bryellow
        end

        if set --local git_status_branch (git symbolic-ref --quiet --short HEAD)
            # print branch

            printf '%s  ' $git_status_branch
        else
            # print detached

            printf '@%s  ' (git rev-parse --short HEAD)
        end
    end


    # Prompt Indicator

    set_color normal

    if set --query fish_private_mode
        printf '\u25cb ' # U+25CB (white circle)
    else
        printf '\u2219 ' # U+2219 (bullet operator)
    end
end
