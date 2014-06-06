# MySQL Replication Solo

This is a cookbook to setup master-slave replication in a single machine.

Dependencies:

* [chef](http://www.getchef.com/chef/)
* [test kitchen](https://github.com/test-kitchen/test-kitchen)
* [vagrant](https://www.vagrantup.com/downloads.html)
* [virtualbox](https://www.virtualbox.org/wiki/Downloads)

How to setup your VM:
```
kitchen list
kitchen setup default-ubuntu-1204
kitchen login default-ubuntu-1204
```

To verify if mysql master is running:
```
echo 'show master status;' | mysql -h 127.0.0.1 --port 3307 -pdecrypt_me_from_a_databag_maybe
```

To verify if mysql slave is running:
```
echo 'show slave status;' | mysql -h 127.0.0.1 --port 3308 -pdecrypt_me_from_a_databag_maybe
```
