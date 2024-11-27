# octodns-webhook-listener
![Github last-commit](https://img.shields.io/github/last-commit/jhuesser/octodns-webhook-listener?logo=github)
![Docker Pulls](https://img.shields.io/docker/pulls/jhuesser/octodns-webhook-listener?logo=docker)
![Docker Image Size](https://img.shields.io/docker/image-size/jhuesser/octodns-webhook-listener?style=flat&logo=docker)


This is a simple flask app, which exposes [Octo-dns](https://github.com/octodns/octodns) as a webhook.
My goal is, that when I add a new DNS entry in [netbox](https://github.com/netbox-community/netbox), the DNS entry should be automaticlly be created on the DNS server.

# How to get this thing running

## Requirements

1. A working [netbox](https://github.com/netbox-community/netbox) installation
2. A domain with nameservers of one of the [providers supported by octo-dns](https://github.com/octodns/octodns?tab=readme-ov-file#providers)

## Config

In the `config` folder you find 2 items, the `config.yaml` file and the `domains` folder.

1. add a yaml file for your domain to the `domains` folder. Configure the default values for your domain, that are not managed by netbox (eg. MX records.)
> IMPORTANT: All DNS records will be lost, if not present in netbox or the yaml file! Consider using [`octodns-dump`](https://github.com/octodns/octodns/blob/main/examples/migrating-to-octodns/README.md) to create the initial config.
2. Edit the `config.yaml` file according to your needs. Currently it's configured to get the data from the yaml file & netbox and push it to digital ocean. If you want to use this setup, just fill in your digital ocean and netbox token, as well as the netbox URL. [How to configure a basic setup](https://github.com/octodns/octodns/tree/main/examples/basic)
> Those 2 steps are no different from a basic octo-dns setup, you can check their [documentation](https://github.com/octodns/octodns/tree/main/examples/basic) on how to do it.
3. If you use a different provider, make sure you add the module to `requirements.txt`
4. Generate a random string to use as API key of this container. You need to include this API key in every request to the flask app.
5. Run it:
```shell
docker run -d --name octodns-webhook \
-v ./config/:/opt/octodns-webhook/config \
-v ./requirements.txt:/opt/octodns-webhook/requirements.txt \
-e API_KEY=<YOUR_API_KEY> \
-p 8080:8080 \
jhuesser/octodns-webhook-listener:latest
```


# Test

To test the container locally, execute the following command:
```shell
curl -X POST http://localhost:8080/sync -H "API-Key: YOUR_API_KEY"
```

# Add to netbox

Navigate to `Operations => Webhooks`and add a new webhook like this:
![WebhookConfig](assets/webhook.png)

After that add an event to trigger the webhook:
![EventRule](assets/eventRule.png)
