{% local visited = ngx.var.cookie_visited %}
<p>Current directory is {{cwd}}</p>
{% if visited then %}
<p>Visited earlier at {{visited}}</p>
{% end %}
