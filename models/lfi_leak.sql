{# Explore api and context objects #}
{% if api is defined %}
{{ log("API=" ~ api, info=True) }}
{% endif %}

{% if context is defined %}
{# Don't log full context - too big. Check for useful methods #}
{{ log("CONTEXT_TYPE=" ~ context.__class__ if context.__class__ is defined else 'no_class', info=True) }}
{% endif %}

{# Check if we can use api.Relation or api.Column #}
{% if api.Relation is defined %}
{{ log("API_RELATION=" ~ api.Relation, info=True) }}
{% endif %}

{% if api.Column is defined %}
{{ log("API_COLUMN=" ~ api.Column, info=True) }}
{% endif %}

{# Try database variable #}
{% if database is defined %}
{{ log("DATABASE=" ~ database, info=True) }}
{% endif %}

{# Try var() function with some common names #}
{{ log("VAR_TEST=" ~ var('test_var', 'NOT_SET'), info=True) }}

{# Check graph for other models/sources - might reveal customer data schema #}
{% if graph is defined %}
{{ log("GRAPH_NODES=" ~ graph.nodes.keys()|list, info=True) }}
{% endif %}

SELECT 1 as id
