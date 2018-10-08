/\\begin{\(equation\|align\|multline\)}/{
    :start
    s/\\end{\(equation\|align\|multline\)}/&/
    t endeq
    N
    b start
    :endeq
    s/\\label{eq:/&/
    t done
    s/{\(equation\|align\|multline\)}/{\1\*}/g
    :done
}
