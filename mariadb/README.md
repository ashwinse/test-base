#    ![image](https://mariadb.org/wp-content/uploads/2015/05/MariaDB-seal-white.png) MariaDB 

MariaDB is published as free and open source software under the General Public License version for SaaS, cloud, and on-premises applications that require high availability, scalability, and performance. MariaDB intends to maintain high compatibility with MySQL, ensuring a “drop-in” replacement capability with library binary equivalency and exact matching with MySQL APIs and commands.

### Azure Market Place Offer

The MariaDB Enterprise Cluster + MariaDB MaxScale solution for Azure consists of a 3-node MariaDB Enterprise Cluster and dual MariaDB MaxScale nodes in a Highly Available (HA) configuration.

### Architecture Image

![image](https://raw.githubusercontent.com/sysgain/arm-components/mariadb/mariadb/architecture-image/Architecture%20image.png?token=AT3nZui9FxuBZM-W4rRFhz-N-7xYQlCWks5XxoZWwA%3D%3D)

### Description

All the VMs run on a OS image based on Open Logic CentOS 7.0. The following diagram illustrates the market place solution’s architecture on Azure.
- The new offering comprises a three-node MariaDB Enterprise Cluster using virtual machines of sizes D2/DS2 and up.
- Mariadb with Galera clustering technology is a multi-master cluster that achieves high availability and scalability through features such as synchronous replication, read and write to any cluster nodes and MaxScale which is a database gateway that insulates client applications from the    complexities of a database cluster.
- The MaxScale VMs of this architecture are two A series virtual machines with no data disks attached.  An Azure load balancer is placed in front of the MaxScale VMs to achieve high availability.  The VMs can be accessed through the load balancer’s public IP or DNS.
- The unique solution is pre-configured for deployment to the Azure platform, with a simple interface that enables customers to deploy a clustered configuration quickly and easily. The solution will enable Azure customers to:
          - Deploy a MariaDB cluster and MaxScale with minimal effort.
          - Benefit from the wide range of services provided by MaxScale for security, scaling and maintenance.

         
         
        