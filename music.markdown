---
title: Music
layout: other
---

<br>

List of some music I like.

<br>

<ul id="music">
{% for element in site.data.music %}
    <li>{% include ui-card-obj.html prefix="./assets/img/music/" element=element %}</li>
{% endfor %}
</ul>
