# define int i
for i in $(seq 1 100); do
sshpass -p "$SSH_PASSWORD" ssh -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa -o KexAlgorithms=+diffie-hellman-group1-sha1 -o StrictHostKeychecking=no -D 40000 -Ng "$SSH_USER"@"$SSH_HOST"
echo "SSH Tunnel $i is running"
done