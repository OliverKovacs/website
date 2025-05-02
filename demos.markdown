---
title: Demos
layout: other
---

<br>

<ul class="row-list">
{% for element in site.data.demos %}
    <li>{% include ui-card-obj.html prefix="/assets/img/" element=element %}</li>
{% endfor %}
</ul>
