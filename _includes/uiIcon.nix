{ ... }: param:
if param.href != "" then
    ''<a href="${ param.href }" class="ui-icon"><img src="${ param.src }">${ param.text }</a>''
else
    ''<div class="ui-icon"><img src="${ param.src }">${ param.text }</div>''
