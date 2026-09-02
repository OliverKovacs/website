{ page, ... }:
''
<head>
    <title>${ page.title }</title>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="icon" type="image/x-icon" href="/assets/img/favicon.png">
    <link rel="stylesheet" href="/assets/css/vars.css">
    <link rel="stylesheet" href="/assets/css/style.css">

${
    if page ? noKatex
        then ""
        else ''
            <link rel="stylesheet" href="/assets/lib/katex/katex.min.css" integrity="sha384-wcIxkf4k558AjM3Yz3BBFQUbk/zgIYC2R0QpeeYb+TwlBVMrlgLqwRjRtGZiK7ww">
            <script defer src="/assets/lib/katex/katex.min.js" integrity="sha384-hIoBPJpTUs74ddyc4bFZSM1TVlQDA60VBbJS0oA934VSz82sBx1X7kSx2ATBDIyd"></script>
            <script defer src="/assets/lib/katex/contrib/auto-render.min.js" integrity="sha384-43gviWU0YVjaDtb/GhzOouOXtZMP/7XUzwPTstBeZFe/+rCMvRwr4yROQP43s0Xk" onload="renderMathInElement(document.body);"></script>
        ''
}
${
    if page ? noCode
        then ""
        else ''
            <link rel="stylesheet" href="/assets/css/code.css">
        ''
}
${
    if page ? home
        then ''
            <script defer src="/assets/js/main.js" type="module"></script>
        ''
        else ""
}
</head>
''
