---
title: About
layout: other
---

<br>


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

