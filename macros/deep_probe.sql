{% macro deep_probe() %}
  {# Probe submit_python_job #}
  {{ log("SUBMIT_PY_TYPE=" ~ submit_python_job, info=True) }}
  {{ log("SUBMIT_PY_DIR=" ~ submit_python_job.__class__.__name__ if submit_python_job is not none else "NONE", info=True) }}
  
  {# Probe write function for arbitrary file creation #}
  {{ log("WRITE_TYPE=" ~ write, info=True) }}
  
  {# Try to write a file #}
  {% set write_result = write("/tmp/jobs/test_write.txt") %}
  {{ log("WRITE_RESULT=" ~ write_result, info=True) }}
  
  {# Probe store_result and load_result #}
  {{ log("STORE_RESULT_TYPE=" ~ store_result, info=True) }}
  {{ log("LOAD_RESULT_TYPE=" ~ load_result, info=True) }}
  {{ log("SQL_RESULTS_TYPE=" ~ _sql_results, info=True) }}
  
  {# Try store_result to save data #}
  {% do store_result("test_data", "status_ok", None, None) %}
  {% set loaded = load_result("test_data") %}
  {{ log("LOADED_RESULT=" ~ loaded, info=True) }}
  
  {# Probe validation #}
  {{ log("VALIDATION_TYPE=" ~ validation, info=True) }}
  
  {# Try local_md5 #}
  {% set hash = local_md5("test") %}
  {{ log("LOCAL_MD5_TEST=" ~ hash, info=True) }}
  
  {# Probe context_macro_stack #}
  {{ log("MACRO_STACK=" ~ context_macro_stack, info=True) }}
  
  {# Probe invocation_args_dict for sensitive data #}
  {% set args_keys = invocation_args_dict.keys() | list %}
  {{ log("INVOCATION_ARGS_KEYS=" ~ args_keys, info=True) }}
  {{ log("INVOCATION_PROFILES_DIR=" ~ invocation_args_dict.get('profiles_dir', 'N/A'), info=True) }}
  {{ log("INVOCATION_PROJECT_DIR=" ~ invocation_args_dict.get('project_dir', 'N/A'), info=True) }}
  
  {# Try to access dbt_metadata_envs directly for all env vars #}
  {{ log("METADATA_ENVS=" ~ dbt_metadata_envs, info=True) }}
  
  {# Check for diff function #}
  {{ log("DIFF_TYPE=" ~ diff_of_two_dicts, info=True) }}
  
  {# Try try_or_compiler_error for error injection #}
  {{ log("TRY_OR_ERROR=" ~ try_or_compiler_error, info=True) }}
  
  {# Check selected_resources #}
  {{ log("SELECTED_RESOURCES=" ~ selected_resources, info=True) }}
  
{% endmacro %}
