[client]
socket = %SOCKET% 

[server]
skip-networking
datadir = %DATADIR%
user    = %USER%

character-set-server = utf8
collation-server = utf8_general_ci

max_connections = 1024 
skip-external-locking
key_buffer = 8M
max_allowed_packet = 1M
table_cache = 1024
sort_buffer_size = 8M
read_buffer_size = 8M
read_rnd_buffer_size = 8M
myisam_sort_buffer_size = 8M
thread_cache = 4
query_cache_size = 4M 
thread_concurrency = 4
thread_cache = 16

# a large inno-setup, as zaypay uses it exclusively
innodb_data_home_dir = %DATADIR%
innodb_data_file_path = ibdata1:64M;ibdata2:10M:autoextend
innodb_log_group_home_dir = %DATADIR% 
innodb_buffer_pool_size = 64M
innodb_additional_mem_pool_size = 16M
innodb_flush_method = O_DIRECT
innodb_log_buffer_size = 8M
innodb_flush_log_at_trx_commit = 2
innodb_lock_wait_timeout = 50

[mysqld_safe]
socket = %SOCKET% 

