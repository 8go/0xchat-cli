# 0xchat-cli

A simple CLI tool for the Nostr chat app `0xchat`.

# Summery

`0xchat-cli` is a simple CLI tool for the Nostr chat app `0xchat`  
([www.0xchat.com](https://www.0xchat.com/) and [github.com/0xchat-app](https://github.com/0xchat-app)).
It is intended to be used as a companion CLI, an admin app, a bot tool, or an AI access point to the
`0xchat` app.
`0xchat-cli` does NOT replace the `0xchat` app on your phone. `0xchat-cli` is only a compagnion terminal app to
`0xchat`, created to give you access to a subset of `0xchat` functionality from your terminal.
You will want to use `0xchat` as your main human facing app.
`0xchat-cli` tries to consistently use the `0xchat` terminology and terms found in the app GUI.

`0xchat-cli` is a Bash-based command-line
interface for interacting with the Nostr network. It leverages the `nak` CLI tool
([github.com/fiatjaf/nak](https://github.com/fiatjaf/nak))
to handle cryptographic operations, event creation, and relay communication.

`0xchat-cli` supports NIP-17 (Encrypted Direct Messages / Private Groups), NIP-28 (Public Channels),
NIP-29 (Open and Closed Groups), and standard Nostr profiles and notes.

`0xchat-cli` is purposefully distributed as a single Bash v4+ script for simplicity of installation and portability.
The script itself does not connect to the internet; all network operations are delegated to `nak`
using user-provided relays. `0xchat-cli` itself does not collect or store any data other than what you
put into the `0xchat-cli` config files.

## Commands

`0xchat-cli` currently supports these commands:

```
0xchat-cli help
0xchat-cli version
0xchat-cli timestamp
0xchat-cli event
0xchat-cli self-test

0xchat-cli key generate
0xchat-cli key convert-nsec-to-hex
0xchat-cli key convert-npub-to-hex
0xchat-cli key convert-hex-to-nsec
0xchat-cli key convert-hex-to-npub
0xchat-cli key derive-npub
0xchat-cli key derive-public-hex

0xchat-cli profile get
0xchat-cli profile set

0xchat-cli contact send
0xchat-cli contact get
0xchat-cli contact listen

0xchat-cli private-group send
0xchat-cli private-group get
0xchat-cli private-group listen

0xchat-cli open-group send
0xchat-cli open-group get
0xchat-cli open-group listen

0xchat-cli closed-group send
0xchat-cli closed-group get
0xchat-cli closed-group listen

0xchat-cli public-channel send
0xchat-cli public-channel get
0xchat-cli public-channel listen

0xchat-cli post send
0xchat-cli post get
0xchat-cli post listen
```

## Installation

Copy the script `0xchat-cli` to your computer.
Most likely you want to copy the 6 config files
(channels.sh, contacts.sh, identities.sh, open-closed-groups.sh, private-groups.sh, relays.sh)
too if you want to play around seriously.
The config files add a lot of convenience.

## Learn More

Read the documentation. Read [0xchat-cli-specification.md](0xchat-cli-specification.md) and
[0xchat-cli-examples.md](0xchat-cli-examples.md).
Or have your AI read these two Markdown files for you so that it can write you some bots.

Enjoy!
