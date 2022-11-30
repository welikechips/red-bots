```server_name=$(echo $RANDOM | md5sum | cut -d " " -f1).red-bots.com```

```terraform apply -auto-approve -var server_name="$server_name"```