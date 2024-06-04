---
title: Oliver Kovacs
layout: home
---

## Languages
<ul class="vert-list">
    {% for element in site.data.languages %}
        {% include ui-icon-obj.html prefix="./assets/img/languages/" element=element %}
    {% endfor %}
</ul>

## Technologies
<ul id="technology-list">
    {% for element in site.data.technologies %}
        {% include ui-icon-obj.html prefix="./assets/img/technologies/" element=element %}
    {% endfor %}
</ul>

## Blog
<ul class="vert-list">
    {% for post in site.posts %}
        {% if post.categories contains "blog" %}
            {% include ui-card.html prefix="" src=post.icon href=post.url title=post.title text=post.text %}
        {% endif %}
    {% endfor %}
</ul>

## Writeups
<ul class="vert-list">
    {% for post in site.posts %}
        {% if post.categories contains "writeup" %}
            {% include ui-card.html prefix="" src=post.icon href=post.url title=post.title text=post.text %}
        {% endif %}
    {% endfor %}
</ul>

## Projects
<ul class="vert-list">
    {% for element in site.data.projects %}
        {% include ui-card-obj.html prefix="./assets/img/" element=element %}
    {% endfor %}
</ul>

## Demos
<ul>
    {% for element in site.data.demos %}
        {% include ui-card-obj.html prefix="./assets/img/" element=element %}
    {% endfor %}
</ul>

## Music
<ul class="vert-list">
    {% for element in site.data.music %}
        {% include ui-card-obj.html prefix="./assets/img/music/" element=element %}
    {% endfor %}
</ul>

## About
<ul>
    Made with 
    {% include ui-icon.html href="https://www.typescriptlang.org/" src="./assets/img/languages/ts.svg" text="TypeScript" %}
    {% include ui-icon.html href="https://jekyllrb.com/" src="./assets/img/technologies/jekyll.svg" text="Jekyll" %}
    {% include ui-icon.html href="https://www.khronos.org/webgl/" src="./assets/img/technologies/webgl.svg" text="WebGL" %}
</ul>
<ul>
    Made by 
    {% include ui-icon.html href="https://github.com/OliverKovacs" src="./assets/img/projects/pfp.png" text="me" %}
</ul>
<ul>
    Hosted on 
    {% include ui-icon.html href="https://pages.github.com/" src="./assets/img/contact/github.svg" text="GitHub" %}
</ul>
<br>
Press <span class="key"> 0 </span>
<br>
<br>
<br>
