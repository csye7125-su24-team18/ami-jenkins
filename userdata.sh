# #!/bin/bash

# # Get the instance's private IP address
# PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

# # Update the Caddyfile
# sed -i "s/PRIVATE_IP_OF_JENKINS_INSTANCE/$PRIVATE_IP/g" /etc/caddy/Caddyfile

# # Restart Caddy
# systemctl restart caddy
