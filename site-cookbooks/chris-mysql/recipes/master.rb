mysql_service 'master' do
  version '5.5'
  port '3307'
  data_dir '/data-master'
  allow_remote_root true
  remove_anonymous_users false
  remove_test_database false
  server_root_password 'decrypt_me_from_a_databag_maybe'
  server_repl_password 'sync_me_baby_one_more_time'
  action :create
end

template "/etc/mysql/master.conf.d/my.cnf" do
  source 'master-my.cnf.erb'
  notifies :restart, 'mysql_service[master]', :immediately
end

require "shellwords"

# 
replication_master_sql = '/etc/mysql/replication_master.sql'
template replication_master_sql do
  source "replication_master.sql.erb"
  variables({
    replication_username: 'repl',
    replication_password: 'sync_me_baby_one_more_time'
  })
  owner "root"
  group "root"
  mode "0600"
end

root_pass = 'decrypt_me_from_a_databag_maybe'
root_pass = Shellwords.escape(root_pass).prepend("-p") unless root_pass.empty?

execute "mysql-set-replication-master" do
  command "/usr/bin/mysql --defaults-file=/etc/mysql/my.master.cnf #{root_pass} < #{replication_master_sql}"
  action :nothing
  subscribes :run, resources("template[#{replication_master_sql}]"), :immediately
end
