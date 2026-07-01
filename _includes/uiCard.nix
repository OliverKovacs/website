{ ... }: param:
if param ? href then
    ''
    <a href="${ param.href }" class="ui-card">
        <img src="${ param.src }" alt="" loading="lazy" />
        <div class="container">
            <b><span id="title">${ param.title }</span></b><br>
            <span id="text">${ param.text }</span>
        </div>
    </a>
    ''
else
    ''
    <div class="ui-card">
        <img src="${ param.src }" alt="" loading="lazy" />
        <div class="container">
            <b><span id="title">${ param.title }</span></b><br>
            <span id="text">${ param.text }</span>
        </div>
    </div>
    ''
