function _pepper_fish_theme_resolve_environment --argument-names key default_value
    set --local prefix 'pepper_fish_theme_'

    set --local r_key "$prefix$key"'_r'

    set --local override_key "$prefix$key"'_override'
    set --local user_key "$prefix$key"

    if set --query $override_key
        set --global $r_key $$override_key
    else if set --query $user_key
        set --global $r_key $$user_key
    else
        set --global $r_key $default_value
    end
end


function pepper_fish_theme_print_login --argument-names color show_emblem show_text emblem
    # Components

    ## Emblem

    if not test "$show_emblem" = false
        set --function _emblem_component "$emblem"
    end


    ## Text

    if not test "$show_text" = false
        set --function _text_component (set_color --bold --italics)(printf '%s@%s' (whoami) (prompt_hostname))
    end


    # Rendering

    printf '%s' (set_color normal; set_color "$color")(string join -- ' ' $_emblem_component $_text_component)
end


function pepper_fish_theme_print_cwd --argument-names color show_emblem show_text emblem
    # Components

    ## Emblem

    if not test "$show_emblem" = false
        set --function _emblem_component "$emblem"
    end


    ## Text

    if not test "$show_text" = false
        if test "$PWD" = '/'
            set --function _text_component (set_color --italics brred)'/'
        else if test "$PWD" = "$HOME"
            set --function _text_component (set_color --italics)'~'
        else
            set --function _text_component (set_color --italics)(printf '%s' (path basename $PWD))
        end
    end

    # Rendering

    printf '%s' (set_color normal; set_color "$color")(string join -- ' ' $_emblem_component $_text_component)
end


function pepper_fish_theme_print_git \
    --argument-names \
        color_clean \
        color_dirty \
        branch_show_emblem \
        branch_show_text \
        branch_emblem \
        detached_show_emblem \
        detached_show_text \
        detached_emblem
    if test "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = true
        # Components

        if set --local __branch_name (git symbolic-ref --quiet --short HEAD)
            ## Branch

            set --function __separator ' '

            ### Emblem

            if not test "$branch_show_emblem" = false
                set --function _emblem_component "$branch_emblem"
            end


            ### Text

            if not test "$branch_show_text" = false
                set --function _text_component "$__branch_name"
            end
        else
            ## Detached

            set --function __separator ''

            ### Emblem

            if not test "$detached_show_emblem" = false
                set --function _emblem_component "$detached_emblem"
            end


            ### Text

            set --local __commit_name (git rev-parse --short HEAD)

            if not test "$detached_show_text" = false
                set --function _text_component "$__commit_name"
            end
        end

        # Rendering

        if test -z (git status --porcelain --ignore-submodules | string collect --allow-empty)
            set --function _color "$color_clean"
        else
            set --function _color "$color_dirty"
        end

        printf '%s' (set_color normal; set_color "$_color")(string join -- "$__separator" $_emblem_component $_text_component)
    end
end


function pepper_fish_theme_print_sigil
    # Components

    if set --query fish_private_mode
        set --function _sigil_component (printf '\u25cb') # U+25CB (white circle)
    else
        set --function _sigil_component (printf '\u2219') # U+2219 (bullet operator)
    end


    # Rendering

    printf '%s' (set_color normal)"$_sigil_component"
end


function fish_prompt
    _pepper_fish_theme_resolve_environment login_color normal
    _pepper_fish_theme_resolve_environment login_show_emblem
    _pepper_fish_theme_resolve_environment login_show_text
    _pepper_fish_theme_resolve_environment login_emblem (printf '\u25a0') # U+25A0 (black square)

    _pepper_fish_theme_resolve_environment cwd_color normal
    _pepper_fish_theme_resolve_environment cwd_show_emblem
    _pepper_fish_theme_resolve_environment cwd_show_text
    _pepper_fish_theme_resolve_environment cwd_emblem (printf '\u2192') # U+2192 (rightwards arrow)

    _pepper_fish_theme_resolve_environment git_color_clean brblack
    _pepper_fish_theme_resolve_environment git_color_dirty bryellow
    _pepper_fish_theme_resolve_environment git_branch_show_emblem
    _pepper_fish_theme_resolve_environment git_branch_show_text
    _pepper_fish_theme_resolve_environment git_branch_emblem '*'
    _pepper_fish_theme_resolve_environment git_detached_show_emblem
    _pepper_fish_theme_resolve_environment git_detached_show_text
    _pepper_fish_theme_resolve_environment git_detached_emblem '@'

    # Components

    set --local _login_component \
        (pepper_fish_theme_print_login \
            "$pepper_fish_theme_login_color_r" \
            "$pepper_fish_theme_login_show_emblem_r" \
            "$pepper_fish_theme_login_show_text_r" \
            "$pepper_fish_theme_login_emblem_r"
        )

    set --local _cwd_component \
        (pepper_fish_theme_print_cwd \
            "$pepper_fish_theme_cwd_color_r" \
            "$pepper_fish_theme_cwd_show_emblem_r" \
            "$pepper_fish_theme_cwd_show_text_r" \
            "$pepper_fish_theme_cwd_emblem_r"
        )

    set --local _git_component \
        (pepper_fish_theme_print_git \
            "$pepper_fish_theme_git_color_clean_r" \
            "$pepper_fish_theme_git_color_dirty_r" \
            "$pepper_fish_theme_git_branch_show_emblem_r" \
            "$pepper_fish_theme_git_branch_show_text_r" \
            "$pepper_fish_theme_git_branch_emblem_r" \
            "$pepper_fish_theme_git_detached_show_emblem_r" \
            "$pepper_fish_theme_git_detached_show_text_r" \
            "$pepper_fish_theme_git_detached_emblem_r"
        )

    set --local _sigil_component (pepper_fish_theme_print_sigil)


    # Rendering

    set --local _prompt (string join -- '  ' $_login_component (string join -- ' ' $_cwd_component $_git_component) $_sigil_component)

    printf '\n%s ' $_prompt
end
