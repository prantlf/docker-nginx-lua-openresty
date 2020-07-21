{% local visited = ngx.var.cookie_visited %}
<p>hello world! -- saying by lua</p>
{% if visited then %}
<p>Visited earlier at {{visited}}</p>
{% end %}
<p>Current directory is {{cwd}}</p>
