#!/bin/bash

## Создайте пользователя с поддержкой SSL, передайте ему права на сервер, а затем сбросьте привилегии
mysql -uroot -proot -e "SET SQL_LOG_BIN=0;"
mysql -uroot -proot -e "CREATE USER 'repl'@'%' IDENTIFIED BY 'u8NqEfKU3MZV' REQUIRE SSL;"
mysql -uroot -proot -e "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';"
mysql -uroot -proot -e "FLUSH PRIVILEGES;"
mysql -uroot -proot -e "SET SQL_LOG_BIN=1;"

# Затем настройте group_replication_recovery, чтобы использовать новую учётную запись.
# Это позволить всем серверам группы пройти аутентификацию.
mysql -uroot -proot -e "CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='u8NqEfKU3MZV' FOR CHANNEL 'group_replication_recovery';"
mysql -uroot -proot -e "INSTALL PLUGIN group_replication SONAME 'group_replication.so';"

#Запуск остальных нод
mysql -uroot -proot -e  "START GROUP_REPLICATION;"

#Запросите список членов группы репликации
mysql -uroot -proot -e  "SELECT * FROM performance_schema.replication_group_members;"

mysql -uroot -proot -e "SELECT * FROM playground.equipment;"