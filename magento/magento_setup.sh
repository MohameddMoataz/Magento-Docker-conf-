# Wait for MySQL to be ready
until mysql -h"${MAGENTO_DB_HOST}" -u"${MAGENTO_DB_USER}" -p"${MAGENTO_DB_PASSWORD}" -e "SHOW DATABASES"; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 3
done

echo "Connected to dp successffully"
# Install Magento if not already installed
if [ ! -f /var/www/html/app/etc/env.php ]; then
  cd /var/www/html
  composer install
  bin/magento setup:install \
      --db-host=${MAGENTO_DB_HOST} \
      --db-name=${MAGENTO_DB_NAME} \
      --db-user=${MAGENTO_DB_USER} \
      --db-password=${MAGENTO_DB_PASSWORD} \
      --backend-frontname=admin \
      --admin-firstname=Admin \
      --admin-lastname=User \
      --admin-email=admin@example.com \
      --admin-user=admin \
      --admin-password=Admin12345 \
      --use-secure=1 \
      --use-rewrites=1 \
      --base-url=https://example.com \
      --base-url-secure=https://example.com \
      --cache-backend=redis \
      --cache-backend-redis-server=redis \
      --cache-backend-redis-db=0 \
      --session-save=redis \
      --session-save-redis-host=redis \
      --session-save-redis-db=1 \
      --search-engine=opensearch \
      --opensearch-hosts=opensearch:9200
fi

# Start PHP-FPM to keep the container running
exec php-fpm

