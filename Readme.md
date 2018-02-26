This is for testing and demonstration purposes only and is not supported by Nutanix
BP for use with Win12R2 Image and SQL2014 attached ISO. Tested in HPOC on PE 5.5.0.5 and PC 5.5.0.5. Includes joining the domain, enabling WSManCredSSP, Disk initialization and SQL Install. Also need a sysprep file. There is one in this repo.
windows BP's don't keep the sysprep information on import.
sysprep.xml
username: administrator
 password : nutanix/4u
Make sure to edit the DNS entry. This will be made a variable in the next update.
SQL ISO Tested
en_sql_server_2014_enterprise_edition_with_service_pack_2_x64_dvd_8962401
Windows Image built from ISO
en_windows_server_2012_r2_with_update_x64_dvd_6052708
