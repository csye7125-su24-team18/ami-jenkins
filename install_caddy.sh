sudo apt-get update
sudo apt-get install caddy -y
sudo systemctl enable caddy
sudo systemctl status caddy
sudo mkdir -p /etc/caddy
sudo mv /tmp/Caddyfile /etc/caddy/Caddyfile
# sudo bash -c 'cat > /etc/caddy/Caddyfile <<EOF\njenkins.poojacloud24.pw {\n    reverse_proxy 127.0.0.1:8080\n}\nEOF'sudo systemctl restart caddy
