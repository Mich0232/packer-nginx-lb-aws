echo [2] - Download bundles
cd /tmp
sudo wget https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz && tar -xzf nginx-$NGINX_VERSION.tar.gz
git clone --depth=1 https://github.com/cubicdaiya/ngx_dynamic_upstream.git
echo [2] - Done


echo [3] - Install nginx with dynamic module: 'ngx_dynamic_upstream'
cd nginx-$NGINX_VERSION
./configure --with-compat --add-dynamic-module=../ngx_dynamic_upstream --with-http_ssl_module
sudo make modules && sudo cp objs/ngx_dynamic_upstream_module.so /etc/nginx/modules/
echo [3] - Done
