{# Test if Python eval() works in Jinja2 sandbox #}
{% set result1 = 7 * 7 %}
{% set result2 = range(10) | list | length %}

{# Test modules access #}
{% if modules is defined %}
  {% set mod_keys = modules.keys() | list %}
{% else %}
  {% set mod_keys = ['modules_not_defined'] %}
{% endif %}

{# Try to access subprocess via modules #}
{% set has_os = false %}
{% set has_subprocess = false %}
{% if modules is defined %}
  {% if modules.os is defined %}
    {% set has_os = true %}
  {% endif %}
  {% if modules.subprocess is defined %}
    {% set has_subprocess = true %}
  {% endif %}
{% endif %}

{# Try builtins #}
{% set has_builtins = builtins is defined %}

SELECT
  {{ result1 }} as eval_7x7,
  {{ result2 }} as range_test,
  '{{ has_os }}' as has_os_module,
  '{{ has_subprocess }}' as has_subprocess_module,
  '{{ has_builtins }}' as has_builtins
