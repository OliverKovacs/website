---
title: Photos
layout: other
---

<main>
    <br>
    <br>
    <br>
    {% for element in site.data.photos %}
        <figure class="photo">
            <img src="./assets/img/photos/{{element.date}}.jpg" alt="photo" tabindex="0"/>
            <figcaption>
                {{element.location}} ({{element.date}})
            </figcaption>
        </figure>
    {% endfor %}
</main>
