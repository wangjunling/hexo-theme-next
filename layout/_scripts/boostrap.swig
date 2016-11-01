{%
  set boot_scripts = [
    'src/bootstrap.js'
  ]
%}

{% for bs in boot_scripts %}
  <script type="text/javascript" src="{{ url_for(theme.js) }}/{{ bs }}?v={{ theme.version }}"></script>
{% endfor %}
<script type="text/javascript" src="https://cdn.jsdelivr.net/particles.js/2.0.0/particles.min.js"></script>
