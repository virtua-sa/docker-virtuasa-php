ServerName "${APACHE_SERVER_NAME}"

User "${APACHE_RUN_USER}"
Group "${APACHE_RUN_GROUP}"

<IfVersion < 2.4>
    <Directory "${DOCKER_BASE_DIR}/">
        Allow from all
        AllowOverride All
        Options -Indexes
    </Directory>
    <Directory "${XHGUI_BASE_DIR}/">
        Allow from all
        AllowOverride All
        Options -Indexes
    </Directory>
</IfVersion>
<IfVersion >= 2.4>
    <Directory "${DOCKER_BASE_DIR}/">
        Require all granted
        AllowOverride All
        Options -Indexes
    </Directory>
    <Directory "${XHGUI_BASE_DIR}/">
        Require all granted
        AllowOverride All
        Options -Indexes
    </Directory>
</IfVersion>
