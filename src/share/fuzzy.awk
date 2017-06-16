BEGIN {
    FS = "/";
}

{
    # calculates the degree of similarity

    sim = similarity($NF, search_string)

    # search_stringが対象文字列より短ければ、同じ長さの部分文字列でスコアを計算し最大値をとる
    # (部分文字列が近いときにマッチさせたいため)
    for (i = 0; i + length(search_string) <= length($NF); i++) {
        target = substr($NF, i, length(search_string))
        s = similarity(target, search_string)
        if (s > sim) { sim = s }
    }

    if ( sim >= 70 ) {
        # When the degree of similarity of search_string is greater than or equal to 70%,
        # to display the candidate path
        print $0
    }
}

function similarity(target, search_string) {
    return (1 - leven_dist(target, search_string) / (length(target) + length(search_string))) * 100 
}

# leven_dist returns the Levenshtein distance two text string
function leven_dist(a, b) {
    lena = length(a);
    lenb = length(b);

    if (lena == 0) {
        return lenb;
    }
    if (lenb == 0) {
        return lena;
    }

    for (row = 1; row <= lena; row++) {
        m[row,0] = row
    }
    for (col = 1; col <= lenb; col++) {
        m[0,col] = col
    }

    for (row = 1; row <= lena; row++) {
        ai = substr(a, row, 1)
        for (col = 1; col <= lenb; col++) {
            bi = substr(b, col, 1)
            if (ai == bi) {
                cost = 0
            } else {
                cost = 1
            }
            m[row,col] = min(m[row-1,col]+1, m[row,col-1]+1, m[row-1,col-1]+cost)
        }
    }

    return m[lena,lenb]
}

# min returns the smaller of x, y or z
function min(a, b, c) {
    result = a

    if (b < result) {
        result = b
    }

    if (c < result) {
        result = c
    }

    return result
}
