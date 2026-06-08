# 0xchat-cli Specification

## 1. Overview
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

## 2. Core Requirements
- **Bash 4.0+**: Required for associative arrays and modern array manipulation.
- **nak**: The Nostr CLI toolkit (`https://github.com/fiatjaf/nak`).
- **jq**: For JSON parsing and formatting.
- **awk**: For text processing.
- **GNU date**: Required for parsing relative time strings (e.g., `"1 hour ago"`, `"yesterday"`).

## 3. Configuration Layers
The CLI operates on a multi-layer configuration system. CLI arguments always override configuration files.
- **Identities (`identities.sh`)**: Stores multiple user identities in `alias|nsec-or-hex` format, plus a `DEFAULT_IDENTITY`.
- **Contacts (`contacts.sh`)**: Stores an array of `CONFIG_CONTACTS` (supports aliases like `alias|npub1...`).
- **Relays (`relays.sh`)**: Stores an array of `CONFIG_RELAYS`.
- **Private Groups (`private-groups.sh`)**: Consolidated NIP-17 group configurations. Maps group names to a pipe-separated string of members via the `CONFIG_PRIVATE_GROUPS` associative array (e.g., `["My Group"]="npub1...|npub2..."`).
- **Channels (`channels.sh`)**: Stores an array of `CONFIG_CHANNELS` (supports aliases like `alias|channel_hex_or_nevent`) for NIP-28 public channels.
- **Open/Closed Groups (`open-closed-groups.sh`)**: Stores an array of `CONFIG_NIP29_GROUPS` for NIP-29 groups. Format: `alias|type|group-id|relay` or `type|group-id|relay`.

Config files are sourced from `$XDG_CONFIG_HOME/0xchat-cli/` (or `~/.config/0xchat-cli/`) by default, but can be overridden via `--config-*` global flags (e.g., `--config-identities`, `--config-private-groups`).

## 4. Argument Resolution & Validation

### 4.1 Relay Requirement
For all network-facing verbs (`send`, `get`, `listen`, `set`), at least one relay must be provided. This can be achieved by passing `--relay URL` one or more times via the CLI, or by pre-configuring relays in `relays.sh`. If no relays are found, the CLI will exit with a usage error.

### 4.2 Single-Use Arguments
To prevent ambiguity, the following arguments can be specified exactly once per CLI execution:
- `--nsec`, `--limit`, `--since`, `--until`, `--group-name` (for private-group), `--hex`, `--exec`.

### 4.3 Identity Resolution (`--nsec`)
Accepts:
- **Alias**: A short name mapped in `identities.sh`.
- **Standard**: `nsec1...` Bech32 strings.
- **Hex**: 64-character hexadecimal private keys (automatically encoded to `nsec` via `nak`).
*Precedence*: CLI `--nsec` > `DEFAULT_IDENTITY` in config > First identity in config.

### 4.4 Target Resolution (`--npub`)
Accepts:
- **Standard**: `npub1...` Bech32 strings.
- **Hex**: 64-character hexadecimal public keys (automatically encoded to `npub`).
- **NIP-05**: Identifiers (e.g., `user@domain.com`).
- **Alias**: Defined in `contacts.sh`.

### 4.5 Channel Resolution (`--channel-id`)
Accepts:
- **Hex**: 64-character hexadecimal event IDs.
- **NIP-19**: `nevent1...` strings (automatically decoded to extract the event ID).
- **Alias**: Defined in `channels.sh`.

### 4.6 NIP-29 Group Resolution (`--group-id`)
Accepts:
- **Hex**: 64-character hexadecimal Group IDs.
- **Alias**: Defined in `open-closed-groups.sh`.
- **NIP-19**: `naddr1...` strings (automatically decoded).
The CLI resolves the associated relay from the config file, or falls back to the `--relay` CLI argument.

### 4.7 Standard Input (`--text -`)
For all `send` verbs, passing `-` to the `--text` argument instructs the CLI to read the message body from standard input (stdin).

### 4.8 Private Group Rules (NIP-17)
A private group is strictly defined by its exact member list and the presence of a `subject` tag. The source of the member list depends on the presence of the `private-groups.sh` config file:
- **If `private-groups.sh` is present**:
  - `--group-name` is **REQUIRED** and selects the group from the `CONFIG_PRIVATE_GROUPS` map.
  - `--npub` is **FORBIDDEN** (hard usage error). Members are parsed directly from the config file's pipe-separated string.
- **If `private-groups.sh` is absent**:
  - `--group-name` is **REQUIRED** (used as the NIP-17 `subject` tag).
  - `--npub` is **ALLOWED/REQUIRED** to define the group members via CLI.
- **Sender Inclusion**: The sender's pubkey (derived from `--nsec`) is always added to the member list automatically. Duplicates are removed.
- **Fetching (`get` / `listen`)**: The CLI enforces that fetched events contain a `subject` tag matching `--group-name`. The event's `p` tags must exactly match the set of expected members. If an event's `subject` tag value does not match the provided `--group-name`, a warning is emitted, but the message is still processed.

### 4.9 Timestamp Resolution
The CLI features a smart `timestamp` utility and accepts flexible time formats for `--since` and `--until` arguments on all `get` and `listen` commands.
- **Auto-Detection**: Pure digits (10 or 13 chars) are treated as Unix timestamps (seconds or milliseconds). Anything else is treated as a human-readable string.
- **Supported Standards**: ISO 8601 (`2026-05-27T18:03:17Z`), Standard/SQL (`2026-05-27 18:03:17`), Relative Time (`"1 hour ago"`, `"yesterday"`, `"last Friday"`) (Requires GNU `date`).

### 4.10 Two-Phase Listen Logic (`listen`)
The `listen` verbs intelligently use a Two-Phase approach for optimal performance:
1. **Phase 1: Chronological Backfill**: If `--since` is provided, the script first fetches historical events, sorts them chronologically, and processes them.
2. **Phase 2: Live Real-Time Streaming**: After backfilling (or immediately if `--since` is omitted), the script switches to native real-time streaming (`nak req --stream`). This ensures zero-latency delivery of new events without the overhead of a polling loop.
Both modes trap `SIGINT` (Ctrl+C) to ensure a clean, graceful shutdown.

### 4.11 Hook Execution (`--exec`)
Available on all `listen` verbs. Executes a shell command for every received message.
- The raw JSON event is piped to the command's `stdin`.
- Metadata is provided via `OXCHATCLI_*` environment variables (e.g., `OXCHATCLI_KIND`, `OXCHATCLI_PUBKEY`, `OXCHATCLI_NPUB_SENDER`, `OXCHATCLI_ALIAS`, `OXCHATCLI_CONTENT`, `OXCHATCLI_CREATED_AT`, `OXCHATCLI_GROUP_NAME`, `OXCHATCLI_GROUP_ID`, `OXCHATCLI_CHANNEL_ID`).
- The command runs in the background (`&`) to prevent blocking the listener loop.

### 4.12 NIP-29 Authentication
Both Open and Closed Groups require authentication (`--nsec`) for `send`, `get`, and `listen` operations. The CLI automatically performs `nak auth` against the specific group relay to ensure proper access and event handling.

## 5. Centralized Limits & Defaults
| Variable | Value | Description |
| --- | --- | --- |
| `DEFAULT_GET_LIMIT` | 20 | Default `--limit` for `get` commands. |
| `MAX_GET_LIMIT` | 200 | Maximum allowed `--limit` for `get` commands. |
| `MAX_CONTACT_RECIPIENTS` | 20 | Max recipients for standard DMs. |
| `MAX_GROUP_MEMBERS` | 20 | Max members for private groups. |
| `MAX_TEXT_MESSAGES` | 20 | Max `--text` / `--text-file` arguments per execution. |
| `MAX_RELAYS` | 20 | Max relays to publish/query per execution. |

## 6. Exit Codes & Output Formatting
| Code | Constant | Description |
| --- | --- | --- |
| 0 | `EXIT_OK` | Success. |
| 1 | `EXIT_ERROR` | General execution error (e.g., `nak` failure, network issue). |
| 2 | `EXIT_USAGE` | Invalid arguments, missing required flags, or validation failure. |
| 69 | `EXIT_NOT_IMPLEMENTED` | The requested verb/command is stubbed but not yet fully implemented. |

**Color Coding**:
- **Green**: Successful operations and summary lines indicating 100% success.
- **Red**: Hard errors, usage errors, and summary lines indicating partial/total failure.
- **Yellow**: Warnings (e.g., mismatched `subject` tags, graceful Ctrl+C shutdowns).

## 7. NIP Implementations
- **NIP-01 / NIP-05**: Basic event fetching, profile metadata, and NIP-05 identifier resolution.
- **NIP-17**: Encrypted Direct Messages and Private Groups. Uses Kind 14 (content) wrapped in Kind 1059 (gift wrap). Private groups are differentiated by the presence of a `subject` tag and strict `p`-tag member matching.
- **NIP-19**: Bech32-encoded entities (`nevent`, `npub`, `nsec`). Handled natively via the `event` command and auto-resolution logic.
- **NIP-28**: Public Channels (Kind 42). Handled via the `public-channel` command suite.
- **NIP-29**: Open and Closed Groups. Handled via `open-group` and `closed-group` commands. Uses Kind 9 with `h` tag. Requires authentication for all operations.
