---
layout: post
title:  "Stealing Seeds"
date:   2024-04-06 00:00:00 +0200
categories: writeup
icon:   "./assets/img/languages/python.svg"
text:   "openECSC 2024<br>crypto"
---

**openECSC 2024 - Round 1**

by [Oliver Kovacs](https://oliverkovacs.dev)

Category: `crypto`

### Description
```
I found an interesting way to generate numbers with someone. Wanna try?
```
Attachments: `stealing-seeds.py` (see [Appendix](#appendix))

### Probem

Let $$s \in \mathbb{P}$$ and $$k \in \mathbb{Z}$$ with $$0 \le s, k \lt 2^{256}$$ be two secret numbers chosen at random.

Let $$f_1, f_2 \colon \{0, 1\}^{256} \to \{0, 1\}^{256}$$ be

$$
f_1(u) = \text{sha256}(((s \oplus u) + s) \oplus k) \\
f_2(u) = \text{sha256}(((s + u) \oplus s) \oplus k)
$$

where $$\oplus$$ denotes bit-wise XOR.

Given that you can compute $$f_1(u)$$ and $$f_2(u)$$ for any $$u \in \{0, 1\}^{256}$$, find $$s$$.

### Solution

This may not be the most elegant solution, however I will explain how to systematically find it without any advanced knowledge of cryptography and semi-formally argue why it is correct.

We first observe that $$\text{sha256} \colon \{0, 1\}^n \to \{0, 1\}^{256}$$ is a _hash function_. It maps every sequence of bits to a sequence of 256 bits. Its outputs are distributed uniformly random, but the same input will always yield the same output. Furthermore we cannot find the pre-image of an output. That is, given  $$\text{sha256}(x)$$ there is no way of finding $$x$$ other than trying every possible value. This is obviously only feasible if the search space is severly limited.

Let us define $$g_1, g_2$$ as

$$
\begin{align*}
&g_1(u) = (s \oplus u) + s \\
&g_2(u) = (s + u) \oplus s \ .
\end{align*}
$$

Now we observe that the $$f_i$$ has the following structure:

$$
f_i(u) = \text{sha256}(g_i(u) \oplus k) \  .
$$

XOR can be interpreted as conditionally flipping a bit. More precisely, given two bits $$b, k \in \{0, 1\}$$

$$
b \oplus k = \begin{cases}
   b &\text{if } k = 0 \\
   \neg\ b &\text{if } k = 1
\end{cases}.
$$

This is problematic because it means that even knowing $$g_i(u)$$ the term $$g_i(u) \oplus k$$ could still be _any_ number.
This implies that doing a brute-force search to find pre-images of $$\text{sha256}$$ would require checking $$2^{256}$$ (the amount of possible values of $$k$$) elements which is practically impossible.

To closer illustrate this consider that

$$
f_2(0) = \text{sha256}(((s + 0) \oplus s) \oplus k) = \text{sha256}((s \oplus s) \oplus k) = \text{sha256}(0 \oplus k) = \text{sha256}(k)
$$

could have any possible value depending on $$k$$. This rules out a pre-image attack and thus extracting information from a single image is impossible.

But we observe that $$\text{sha256}$$ behaves _as if_ it were injective. A function $$f$$ with the domain $$X$$ is called injective if

$$
\forall a, b \in X \colon f(a) = f(b) \implies a = b \ .
$$

Technically this is not true for $$\text{sha256}$$ as there are infinitely many hash collisions (this is evident by the fact that the output is limited to a finite number of bits) but in practice it is extremely unlikely to observe a hash collision.

If we now define the function

$$
x_k(u) = u \oplus k
$$

for some constant $$k$$ we can see that 

$$
x_k(x_k(u)) = (u \oplus k) \oplus k = u \oplus (k \oplus k) = u \oplus 0 = u
$$

therefore $$x_k = x_k^{-1}$$ which implies that $$x_k$$ is injective aswell.

It is easy to show that if two function $$f \colon B \to C, g \colon A \to B$$ are injective then $$f \circ g \colon A \to C$$ must also be injective.

We can now write

$$
f_i(u) = \text{sha256}(x_k(g_i(u)) \\
$$

and use the definition of injectivity to show that

$$
\begin{align*}
\forall u, v \colon &f_1(u) = f_2(v) \\
\iff &\text{sha256}(x_k(g_1(u))) = \text{sha256}(x_k(g_2(v))) \\
\implies &g_1(u) = g_2(v) \ .
\end{align*}
$$

It is also worth to note that we can use the same arguments to show that

$$
\forall u, v \colon f_i(u) = f_i(v) \implies u = v \ .\\
$$

This gives us the crucial hint that we have to create an exploit by comparing the values of two different functions while trying out specific inputs.
To craft this exploit we fix $$s$$ to some number and consider $$g_i(0), g_i(1), \ldots$$

```
s = 1
u       0   1   2   3   4   5   6   7

g1      2   1   4   3   6   5   8   7
g2      0   3   2   5   4   7   6   9
```

Let $$p_s(u)$$ be the number such that $$g_2(u) = g_1(p_s(u))$$ or $$-1$$ if no such number exists with $$s$$ fixed to some value.
This is well defined as from the above result it follows that $$\forall u, v \colon u \neq v \implies g_i(u) \neq g_i(v)$$.

We now look at a table of $$p_s(u)$$ with the axes $$u$$ and odd $$s$$. A `.` denotes $$-1$$.

> Only odd $$s$$ are considered as $$s$$ is prime and very unlikely to be $$2$$.

```
u     0   1   2   3   4   5   6   7

p1    .   3   0   5   2   7   4   .
p3    .   7   0   1   2   .   4   5
p5    .   .   .   .   2   .   .   1
p7    .   .   0   1   2   3   4   5
```

We notice that

$$
\begin{align*}
&p_3(7) = p_7(7) = 5 \neq p_{1,5}(7) \\
\implies &g_2(7) = g_1(5) \iff f_2(7) = f_1(5) \iff s \in \{3, 7\} \iff s \equiv 3 \quad (\text{mod } 4) \ .
\end{align*}
$$

This means that by a single comparison we can halve the search space! A quick look at a larger table suggests that the method can be generalised.

```
u     0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15

p1    .   3   0   5   2   7   4   9   6  11   8  13  10  15  12   .
p3    .   7   0   1   2  11   4   5   6  15   8   9  10   .  12  13
p5    .   .   .  13   2  15  12   1   6   3   0   .  10   .   .   9
p7    .  15   0   1   2   3   4   5   6   .   8   9  10  11  12  13
p9    .   .   .   .   .   .   .   .   6   .   .   .   .   .   .   1
p11   .   .   .   .   .   .   4   5   6   .   .   .   .   3  12  13
p13   .   .   .   .   2   .   .   1   6   3   0   5  10   7   4   9
p15   .   .   0   1   2   3   4   5   6   7   8   9  10  11  12  13
```

$$
s \equiv \begin{cases}
    3 \equiv \begin{cases}
        7 &\text{if } f_2(13) = f_1(11) \\
        3 &\text{if } f_2(13) \neq f_1(11)
    \end{cases} (\text{mod } 8) &\text{if } f_2(15) = f_1(13) \\
    1 \equiv \begin{cases}
        5 &\text{if } f_2(15) = f_1(9) \\
        1 &\text{if } f_2(15) \neq f_1(9)
    \end{cases} (\text{mod } 8) &\text{if } f_2(15) \neq f_1(13)
\end{cases} (\text{mod } 4)
$$

To put this more concretely let us look at a slice of the above table:

```
u     ...   12  13        14  15
                         
p1    ...   10  15        12   .
p3    ...   10   .        12  13 (1)
p5    ...   10   .         .   9 (3)
p7    ...   10  11 (2)    12  13 (1)
p9    ...    .   .         .   1
p11   ...    .   3        12  13 (1)
p13   ...   10   7         4   9 (3)
p15   ...   10  11 (2)    12  13 (1)
```

The first comparison concerns the entries marked with `(1)`.

1) If it returns true we get this subtable of possible values and use the comparison marked with `(2)`:

```
u     ...   12  13        14  15
                          
p3    ...   10   .        12  13 (1)
p7    ...   10  11 (2)    12  13 (1)
p11   ...    .   3        12  13 (1)
p15   ...   10  11 (2)    12  13 (1)
```

2) If it returns false we get the opposite subtable and use the comparison marked with `(3)`:

```
u     ...   12  13        14  15
                          
p1    ...   10  15        12   .
p5    ...   10   .         .   9 (3)
p9    ...    .   .         .   1
p13   ...   10   7         4   9 (3)
```

Thus with every comparison one bit is recovered, meaning that $$s$$ can be computed with 255 comparisons.
What remains is to reverse engineer the equation for the indices to compare at each step.
One possible solution can be found in the [Appendix](#appendix).
Then some automated way of submitting requests needs to be created to obtain the seed from the remote server.

### Appendix

Visualisation of the $$p_s(u)$$ table obtained by coloring $$-1$$ white.
![test](/assets/img/posts/vis.png)

`solve.py`

```python
def solve(k):
    last = 2**k - 1
    out = 1
    index = 1
    delta_x = 0
    delta_y = 0

    while (index < k):
        mask = 2 ** index
        delta_y |= mask
        
        # x y
        print(last - delta_y, last - delta_x)
    
        # compute f1(x) == f2(y)
        # write result to stdin
        equal = bool(int(input()))
        if (equal):
            out |= mask
            delta_x |= mask
            delta_y ^= mask

        index += 1

    print(f"{out = }")

solve(256)
```

`stealing-seeds.py`

```python
#!/usr/bin/env python3

import os
import signal
import random
from Crypto.Util.number import getPrime, long_to_bytes, bytes_to_long
from hashlib import sha256

assert("FLAG" in os.environ)
FLAG = os.environ["FLAG"]
assert(FLAG.startswith("openECSC{"))
assert(FLAG.endswith("}"))

def main():

    seed_size = 256
    seed = getPrime(seed_size)
    seed = 11

    # Just to protect my seed
    k = random.randint(1, 2**seed_size - 1)

    print(f'{seed_size = }')
    print(f'{seed = }')
    print(f'{k = }')

    print("""I have my seed, if you give me yours we can generate some random numbers together!
Just don't try to steal mine...
""")

    while True:
        choice = int(input("""Which random do you want to use?
1) Secure
2) Even more secure
3) That's enough
> """))
        if choice not in [1, 2, 3]:
            print("We don't have that :(")
            continue
        if choice == 3:
            break
        user_seed = int(
            input("Give me your seed: "))
        if user_seed.bit_length() > seed_size:
            print(
                f"Your seed can be at most {seed_size} bits!")
            continue
        if choice == 1:
            final_seed = ((seed ^ user_seed) +
                           seed) ^ k
        else:
            final_seed = ((seed + user_seed) ^
                           seed) ^ k

        random_number = bytes_to_long(sha256(long_to_bytes(final_seed)).digest())

        print(f"Random number:", random_number)
    
    guess = int(input("Hey, did you steal my seed? "))

    if guess == seed:
        print(FLAG)
    else:
        print("Ok, I trust you")
    return


def handler(signum, frame):
    print("Time over!")
    exit()


if __name__ == "__main__":
    signal.signal(signal.SIGALRM, handler)
    signal.alarm(30000)
    main()
```
