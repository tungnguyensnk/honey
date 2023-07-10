for i in $(seq 1 100); do
  sshpass -p "$SSH_PASSWORD" ssh -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa -o KexAlgorithms=+diffie-hellman-group1-sha1 -o StrictHostKeychecking=no -D 40000 -Ng4vv "$SSH_USER"@"$SSH_HOST" 2>&1 \
  | while read -r line; do
    if [[ "${line}" == *"forwarding listening"* ]]; then
      echo "SSH Tunnel is running"
      i=1
    fi
  done
done