# 0xchat-cli Examples & AI Agent Guide

This document provides practical, copy-pasteable examples for all implemented commands in `0xchat-cli`.

🤖 **Note for AI Agents**:
- Always append `--json` and `--quiet` when executing commands programmatically to ensure clean, parsable output without terminal color codes or banners.
- Use configuration files (`--config-identities`, `--config-relays`, `--config-private-groups`) to avoid repeatedly passing sensitive `--nsec` keys, relay URLs, and group member lists in your arguments.
- Use `--text -` to pipe dynamically generated content directly into `send` commands via standard input (stdin).
- `--nsec` now accepts aliases defined in `identities.sh`, allowing easy multi-user switching.
- Leverage the native `--exec` flag on `listen` commands for robust, non-blocking event handling instead of manual bash polling loops.

## 1. Timestamp Utilities
Convert between Unix timestamps and human-readable/relative dates.

```bash
# Convert a Unix timestamp to local human-readable time
$ 0xchat-cli timestamp 1779887279
# Output: 2026-05-27 18:07:59 CEST (Unix: 1779887279)

# Convert a human-readable date to a Unix timestamp
$ 0xchat-cli timestamp "2026-05-27 18:03:17"
# Output: 1779886997 (2026-05-27 18:03:17 CEST)

# Use relative time (requires GNU date)
$ 0xchat-cli timestamp "1 hour ago"
$ 0xchat-cli timestamp "yesterday"
$ 0xchat-cli timestamp "last Friday"
```

## 2. Key Management
Generate, convert, and derive Nostr cryptographic keys.

```bash
# Generate a brand new Nostr keypair
$ 0xchat-cli key generate

# Generate a keypair and output as JSON (Best for AI agents)
$ 0xchat-cli key generate --json

# Derive the public key (npub) from an alias defined in identities.sh
$ 0xchat-cli key derive-npub --nsec alice

# Convert an nsec to its raw 64-character private hex format
$ 0xchat-cli key convert-nsec-to-hex --nsec nsec1...

# Convert a raw public hex string into an npub
$ 0xchat-cli key convert-hex-to-npub --hex e1baa05b51c54d60d4d609f95dfa12d693f142477d2563b0b44e6d51ad358386
```

## 3. Profile Management
Read and write Nostr Kind 0 profile metadata.

```bash
# Update your profile metadata
$ 0xchat-cli profile set \
    --name "0xchat-Bot" \
    --about "An automated AI assistant running on 0xchat-cli" \
    --picture "https://example.com/avatar.png" \
    --nip05 "bot@example.com" \
    --relay wss://relay.damus.io \
    --relay wss://nos.lol

# Fetch your own profile using an alias defined in contacts.sh
$ 0xchat-cli profile get --npub me --relay wss://relay.damus.io

# Fetch profiles for all contacts listed in your contacts.sh config
$ 0xchat-cli profile get --relay wss://relay.damus.io

# Fetch a specific user's profile by NIP-05 identifier
$ 0xchat-cli profile get --npub fiatjaf@fiatjaf.com --relay wss://relay.damus.io
```

## 4. Direct Messages (Contact)
Send and receive NIP-17 encrypted direct messages.

```bash
# Send a simple text DM to a contact alias
$ 0xchat-cli contact send --npub alice --text "Hello Alice!" --relay wss://relay.damus.io

# Send a DM to multiple recipients at once
$ 0xchat-cli contact send --npub alice --npub bob --text "Meeting in 5 minutes." --relay wss://relay.damus.io

# Pipe dynamic content (e.g., system alerts) into a DM using stdin
$ echo "WARNING: Server CPU is at 99%" | 0xchat-cli contact send --npub admin --text - --relay wss://relay.damus.io

# Fetch all recent DMs sent to you
$ 0xchat-cli contact get --relay wss://relay.damus.io

# Fetch DMs from a specific sender from the last hour
$ 0xchat-cli contact get --npub alice --since "1 hour ago" --relay wss://relay.damus.io
```

## 5. Private Groups (NIP-17)
Send and receive encrypted group messages.

**Scenario A: Using `private-groups.sh` Config (Recommended)**
When the config file is present, `--group-name` selects the group, and `--npub` is forbidden. Members are defined as a pipe-separated string.

```bash
# Send a message to the "family" group defined in private-groups.sh
$ 0xchat-cli private-group send \
    --group-name "My family" \
    --text "Dinner at 7 PM tonight?" \
    --relay wss://relay.damus.io

# Fetch messages from the "dev-team" group from yesterday
$ 0xchat-cli private-group get \
    --group-name "Our work group" \
    --since "yesterday" \
    --relay wss://relay.damus.io
```

**Scenario B: Ad-Hoc CLI Groups (No Config File)**
When no config file exists, you must provide the subject name and all members via CLI.

```bash
# Send a message to an ad-hoc group
$ 0xchat-cli private-group send \
    --group-name "weekend-trip" \
    --npub mom --npub dad --npub sister \
    --text "Dinner at 7 PM tonight?" \
    --relay wss://relay.damus.io

# Fetch messages from an ad-hoc group
$ 0xchat-cli private-group get \
    --group-name "weekend-trip" \
    --npub mom --npub dad --npub sister \
    --since "yesterday" \
    --relay wss://relay.damus.io
```

## 6. Open Groups (NIP-29 Groups)
Send and receive unencrypted open group messages.

**Scenario A: Using `open-closed-groups.sh` Config (Recommended)**
When the config files are present, `--group-name` selects the group.

```bash
# Send a message to the "Surf" group defined in open-closed-groups.sh
$ 0xchat-cli open-group send \
    --group-name "Surf" \
    --text "How are the waves today?"

# Fetch messages from the "Surf" group from yesterday
$ 0xchat-cli open-group get \
    --group-name "Surf" \
    --since "yesterday"

# Listen to the next 2 messages from the "Surf" group starting now
$ 0xchat-cli open-group listen \
    --group-name "Surf" \
    --limit 2
```


## 7. Closed Groups (NIP-29 Groups)
Send and receive unencrypted closed group messages.

**Scenario A: Using `open-closed-groups.sh` Config (Recommended)**
When the config files are present, `--group-name` selects the group.

```bash
# Send a message to the "BBQ Party" group defined in open-closed-groups.sh
$ 0xchat-cli closed-group send \
    --group-name "BBQ Party" \
    --text "Who is bringing the meat?"

# Fetch messages from the "BBQ Party" group for the last 2 weeks
$ 0xchat-cli closed-group get \
    --group-name "BBQ Party" \
    --since "last week"

# Listen to the next 2 messages from the "BBQ Party" group starting tomorrow
$ 0xchat-cli closed-group listen \
    --group-name "BBQ Party" \
    --limit 2
    --since "tomorrow"
```

## 8. Public Posts (Notes)
Publish and fetch Nostr Kind 1 public notes.

```bash
# Publish a short public note (using an identity alias)
$ 0xchat-cli post send --nsec work-bot --text "Just testing the new 0xchat-cli! 🚀" --relay wss://relay.damus.io

# Publish a long-form note from a markdown file
$ 0xchat-cli post send --text-file ./blog-post-draft.md --relay wss://relay.damus.io --relay wss://nos.lol

# Fetch your own recent posts
$ 0xchat-cli post get --npub me --relay wss://relay.damus.io

# Fetch posts from your entire contact list from the last 24 hours
$ 0xchat-cli post get --since "24 hours ago" --relay wss://relay.damus.io
```

## 9. Advanced / AI Agent Workflows

### A. Fully Automated AI Responder (Native `--exec`)
Instead of a manual polling loop, use the native `--exec` feature available on all `listen` commands. This streams events in real-time and executes your script in the background for each message, preventing blocking.

**1. Create a handler script (`bot.sh`):**
```bash
#!/bin/bash
# bot.sh
# The raw JSON event is piped to stdin.
# Metadata is also available via OXCHATCLI_* environment variables.

MSG=$(cat)
SENDER=$(echo "$MSG" | jq -r '.pubkey')
CONTENT=$(echo "$MSG" | jq -r '.content')

# Alternatively, use the provided environment variables:
# SENDER=$OXCHATCLI_PUBKEY
# CONTENT=$OXCHATCLI_CONTENT

# Generate reply (e.g., using an LLM API)
REPLY=$(generate_ai_reply "$CONTENT")

# Send reply back (using default identity from identities.sh)
echo "$REPLY" | 0xchat-cli contact send --npub "$SENDER" --text - --quiet --relay wss://relay.damus.io
```

**2. Run the listener:**
```bash
chmod +x bot.sh
0xchat-cli contact listen --exec "./bot.sh" --relay wss://relay.damus.io
```

### B. Using Config Files to Clean Up Commands
Instead of passing `--nsec`, `--relay`, and group members every time, create config files:

**`~/.config/0xchat-cli/identities.sh`**
```bash
DEFAULT_IDENTITY="alice"
CONFIG_IDENTITIES=(
    "alice|nsec1yhwks43ydabcabcabcabcabcabcabcbacbabcabcabcabcabcabcancancq3959"
    "work-bot|25dd6856246862b7d483b6de41cefb5ec039bce5a77f84138a6cacb54596363c"
)
```

**`~/.config/0xchat-cli/private-groups.sh`**
```bash
# Maps group name to a pipe-separated string of members (aliases or npubs)
declare -A CONFIG_PRIVATE_GROUPS=(
    ["My family"]="npub1mom...|npub1dad..."
    ["Our work group"]="Alice|Bob Smith"
)
```

**`~/.config/0xchat-cli/relays.sh`**
```bash
CONFIG_RELAYS=("wss://relay.damus.io" "wss://nos.lol" "wss://relay.primal.net")
```

**Resulting clean commands:**
```bash
# Sends as 'alice' to the 'My family' group automatically
$ 0xchat-cli private-group send --group-name "My family" --text "Hello family!"

# Switches identity to 'work-bot' on the fly
$ 0xchat-cli private-group send --nsec work-bot --group-name "Our work group" --text "Meeting in 5."
```
