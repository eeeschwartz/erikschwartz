---
published: true
layout: post
category: blog
current-tab: blog
author: Erik Schwartz
date: '2016-06-22'
permalink: 2016-06-23-letsencrypt-san-certificate-pantheon
---

I needed to experiment with 301 redirect behavior for a site under SSL.

### The constraints

- make sure redirects from https://mydomain.com aren't spoiled by certificate errors because the certificate covers `www.mydomain.com` but not `mydomain.com`
- Here’s [the post](http://www.jasonsamuel.com/2011/03/07/how-to-properly-use-ssl-redirects-without-getting-certificate-error-messages/) that describes this problem and how to avoid it. But it’s 5 years old so I wanted to test it all out.
- Use the Pantheon PaaS for Drupal hosting
- Use letsencrypt to generate throw-away certificates for free

### Generate a certificate

Given that I’m using a PaaS, I can’t install the lets encrypt [certbot](https://certbot.eff.org/) to automatically manage certificates the way others would. For my use case I just want to generate temporary certificates to test out the 301 behavior (in the long-term I’ll get a certificate from a provider with longer validity). So for now I’m ok [using lets encrypt to create the cert manually](https://tty1.net/blog/2015/using-letsencrypt-in-manual-mode_en.html).

To manually generate certificates with lets encrypt, I need a public web server that my domain resolves to so I point a throwaway domain "notabigdeal.club" at a DigitalOcean droplet ($.88 on namecheap for the domain!).

The DNS is set up like so on Namecheap:

||||
| --- | --- | --- | ---- |
|URL redirect record| @ | http://www.notabigdeal.club | Unmasked |

ssh to the droplet and then:

```
openssl req -new -newkey rsa:2048 -nodes -out notabigdeal_club.csr -keyout notabigdeal_club.key -subj '/C=US/ST=Kentucky/L=Lexington/O=test/CN=notabigdeal.club'

certbot-auto certonly --authenticator manual --server https://acme-v01.api.letsencrypt.org/directory --text --email erik@erikschwartz.net --csr www_notabigdeal_club.csr

# Things that pantheon wants:

# The cert
cat 0000_cert.pem

# Intermediate cert
cat 0000_chain.pem

# The private key
cat www_notabigdeal_club.key
```

### The 301 behavior

As expected, visiting 'https://notabigdeal.club' throws an error since the certificate is only for 'www'

### Lets try again with a Sans certificate that covers both domains


Namecheap DNS settings

| record type  |     |                          |       |
| ------------ | --- | ------------------------ | ----- |
| CNAME Record | www | my-site.pantheonsite.io. | 30 min |
| A Record     | @   |            104.130.89.68 | 30 min |


### Is generating a SAN CSR a pain?

According to the [openssl CSR tool](https://www.digicert.com/easy-csr/openssl.htm)
"Adding Subject Alternative Names to a CSR using OpenSSL is a complicated task. Our advice is to skip the hassle, use your most important server name as the Common Name, and specify the other names during the order process. Our Multi-Domain (SAN) Certificate ordering process will let you specify all the names you need without making you include them in the CSR."

It's not so bad to generate a SAN CSR with a [good example](https://www.icts.uiowa.edu/confluence/display/ICTSit/CSR+Generation+for+SAN+%28aka+UCC+or+Multiple+Domain%29+Certificates+within+Apache) in hand.


On the digital ocean droplet that hosts notabigdeal.club, create openssl.conf

```
[ req ]
default_bits        = 2048
default_keyfile     = privkey.pem
distinguished_name  = req_distinguished_name
req_extensions     = req_ext # The extentions to add to the self signed cert

[ req_distinguished_name ]
countryName           = Country Name (2 letter code)
countryName_default   = US
stateOrProvinceName   = State or Province Name (full name)
stateOrProvinceName_default = Iowa
localityName          = Locality Name (eg, city)
localityName_default  = Iowa City
organizationName          = Organization Name (eg, company)
organizationName_default  = The University of Iowa
commonName            = Common Name (eg, YOUR name)
commonName_max        = 64

[ req_ext ]
subjectAltName          = @alt_names

[alt_names]
DNS.1 = notabigdeal.club
DNS.2 = www.notabigdeal.club
```

Generate the CSR and the certificate:

```
# make sure to answer "Common Name (eg, YOUR name) []:" as notabigdeal.club
openssl req -new -newkey rsa:2048 -nodes -out notabigdeal_club.csr -keyout notabigdeal_club.key -config openssl.conf
```

Follow the instructions to add the files to .well-known/acme-challenge for each domain.

If it works, certbot will congratulate you and you can copy over the cert details to pantheon:

```
# The cert
cat 0000_cert.pem

# Intermediate cert
cat 0000_chain.pem

# The private key
cat notabigdeal_club.key
```

### Pantheon-specific note

I had to enable both domains in Pantheon: www.notabigdeal.club and notabigdeal.club. Otherwise it gave a Pantheon boilerplate "Site not found" page.

The confusing part is that each domain you add on the Pantheon dashboard suggests that your DNS settings should be an "A" record pointing to the Pantheon IP. This conflicts with the Pantheon documentation where it says the root domain gets the "A" record, and the "www" subdomain gets a CNAME to "my-site.pantheonsite.io". As mentioned above, I chose the latter and it worked for me.
