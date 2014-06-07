mysql_service 'slave' do
  version '5.5'
  port '3308'
  data_dir '/data-slave'
  allow_remote_root true
  remove_anonymous_users false
  remove_test_database false
  server_root_password 'decrypt_me_from_a_databag_maybe'
  server_repl_password 'sync_me_baby_one_more_time'
  action :create
end

template '/etc/mysql/slave.conf.d/my.cnf' do
  source 'slave-my.cnf.erb'
  notifies :restart, 'mysql_service[slave]', :immediately
end

require 'shellwords'

#
replication_slave_sql = '/etc/mysql/replication_slave.sql'
template replication_slave_sql do
  source 'replication_slave.sql.erb'
  variables(
              master_host:          '127.0.0.1',
              master_port:          3307,
              replication_username: 'repl',
              replication_password: 'sync_me_baby_one_more_time'
            )
  owner 'root'
  group 'root'
  mode '0600'
end

root_pass = 'decrypt_me_from_a_databag_maybe'
root_pass = Shellwords.escape(root_pass).prepend('-p') unless root_pass.empty?

execute 'mysql-set-replication-slave' do
  command "/usr/bin/mysql --defaults-file=/etc/mysql/my.slave.cnf #{root_pass} < #{replication_slave_sql}"
  action :nothing
  subscribes :run, resources("template[#{replication_slave_sql}]"), :immediately
end
