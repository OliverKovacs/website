# nix is cringe
{
    id = x: x;
    add = x: y: x + y;
    sub = x: y: x - y;
    mul = x: y: x * y;
    div = x: y: x / y;
    cat = x: y: x ++ y;
    not = x: !x;
    eq = x: y: x == y;
    neq = x: y: x != y;
    lt = x: y: x < y;
    le = x: y: x <= y;
    gt = x: y: x > y;
    ge = x: y: x >= y;
    and = x: y: x && y;
    or = x: y: x || y;
}
