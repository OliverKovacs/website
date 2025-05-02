---
title: Oliver Kovacs
layout: home
---

## About

I'm a computer science student at ETH Zürich, software engineer, and hacker.
Also known as dnydxn.
You can find my 
<a href="/assets/pdf/Oliver_Kovacs-CV-public-en.pdf" target="_blank">CV here</a>.

<!--
## Languages
<ul>
{% for element in site.data.languages %}
    <li>{% include ui-icon-obj.html prefix="./assets/img/languages/" element=element %}</li>
{% endfor %}
</ul>

## Technologies
<ul id="technology-list" class="row-list">
{% for element in site.data.technologies %}
    <li>{% include ui-icon-obj.html prefix="./assets/img/technologies/" element=element %}</li>
{% endfor %}
</ul>
-->

## Blog
<ul>
{% for post in site.posts %}
    {% if post.categories contains "blog" %}
        <li>{% include ui-card.html prefix="" src=post.icon href=post.url title=post.title text=post.text %}</li>
    {% endif %}
{% endfor %}
</ul>

## Writeups
<ul>
{% for post in site.posts %}
    {% if post.categories contains "writeup" %}
        <li>{% include ui-card.html prefix="" src=post.icon href=post.url title=post.title text=post.text %}</li>
    {% endif %}
{% endfor %}
</ul>

## Projects
<ul>
{% for element in site.data.projects %}
    <li>{% include ui-card-obj.html prefix="./assets/img/" element=element %}</li>
{% endfor %}
</ul>

## Publications
<ul>
{% for post in site.posts %}
    {% if post.categories contains "publication" %}
        <li>{% include ui-card.html prefix="" src=post.icon href=post.url title=post.title text=post.text %}</li>
    {% endif %}
{% endfor %}
</ul>

## <a href="./demos">Demos</a>
<!--## Demos
<ul class="row-list">
{% for element in site.data.demos %}
    <li>{% include ui-card-obj.html prefix="./assets/img/" element=element %}</li>
{% endfor %}
</ul>-->

## <a href="./photos">Photos</a>

## <a href="./music">Music</a>
