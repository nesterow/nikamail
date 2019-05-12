> This is a github mirror, main project is hosted on [Bitbucket](https://bitbucket.org/nesterow/nikamail)

# NikaMail v1.0

**NikaMail** is a portable, extendable, zero-config email server.
It is designed to perform automation tasks, provide access to mailboxes
and serve as a mail transfer agent.
*NikaMail* is built on top of [Mireka](http://mireka.org) and [JRuby](https://jruby.org).


[Documentation](https://nika.run/docs/)

### What does ''portable'' mean?
'Portable' means that every part of application is included in one package.
Configure it once and run it everywhere.

*Need to move the server on another machine?* - Just copy it.
It works with Docker or without it.

*Raspbery PI?* - No problem.

### FEATURES


| Name | Features  |
|------|-----------|
| **Mail Exchange Server (MX)** | Receive emails. SMTP `on port 25`, STARTTLS |
| **Mail Transfer Agent (MTA)**  | Send emails. SMTP `on port 587`, STARTTLS, DKIM.  |
| **POP3 Server (POP3)** | Access emails. POP3 `on port 110`, STARTTLS. |
| **WebUI** | `port 10080 (https)` ,Configure server on fly using WebUI.|
| **Mailing Lists** | Create subscription lists and private groups. |
| **StartTLS Encryption** | TLS on standard ports. TLS is also supported by MTA for outgoing connections, GMail and other services tag it as 'secure' |
| **Email Automation** |  Process and handle received emails using Ruby. For example, you can handle reports automatically. |
| **DKIM signing** | Signing emails using a Private Key to prove that they are sent by your server|
| **JSON RPC** | Server can interact with your applications. |
| **Listings Rest API** | Add subscribers from your application. |
| **Java Extensions** | Write server extensions in Java |
| **JRuby** | Program and tweak server in Ruby |


### REQUIREMENTS
| Name | Descrition |
|-------|------------|
| JVM 7+ | Java Virtual Machine. OpenJDK or Oracle |
| A POSIX SYSTEM | Any Unix-like sytem should work. Linux, BSD*, MacOS, Android |
| 265 Mb RAM (*Minimal Requirement*)| It performs if the server is expected to process *`less than ~1500` emails in an hour*. |
| 512+ Mb RAM (*Recommended*)| It performs if the server is expected to process *`more than ~1500` emails in an hour*. |
| 30+ Mb of Disk Space | Don't forget you need to store emails somewhere |



### LICENSE
*NikaMail software is licensed under [Creative Commons Attribution-ShareAlike 4.0 International License.](https://creativecommons.org/licenses/by-sa/4.0/)*

*Materials shipped within NikaMail distribution, including graphic materials, texts,
third-party software and binary files are distributed under permissive opensource licenses [by their authors](https://nika.run/credits/).*
