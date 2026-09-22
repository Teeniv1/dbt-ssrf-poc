{% macro try_read_file(path) %}
  {% set content = '' %}
  {% do log("ATTEMPTING_READ=" ~ path, info=True) %}
  {% set ns = namespace(data='') %}
  {% if adapter is defined %}
    {% do log("ADAPTER_AVAILABLE=true", info=True) %}
  {% endif %}
{% endmacro %}
