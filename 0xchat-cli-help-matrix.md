# 0xchat-cli Help Matrix

This matrix outlines the supported arguments for each command and verb combination in `0xchat-cli`.

**Legend**:
- ✅ : Supported / Required
- `(1+)` : Must be provided 1 or more times (either via CLI or configuration file)
- `(1)` : Must be provided exactly once
- `[C]` : Can be supplied via Configuration file instead of CLI flag
- `*` : If omitted, triggers native real-time streaming (`--stream`) instead of backfilling.
- `(Cond)` : Conditional based on configuration file presence.

| Command | Verb | --nsec | --npub | --channel-id | --group-id | --relay | --text / --text-file | --group-name | --limit | --since | --until | --exec | --json |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **event** | (auto) | | | | | | | | | | | | ✅ |
| **timestamp** | (auto) | | | | | | | | | | | | ✅ |
| **profile** | get | | ✅ | | | ✅ (1+) [C] | | | ✅ (1) | ✅ (1) | ✅ (1) | | ✅ |
| | set | ✅ (1) | | | | ✅ (1+) [C] | | | | | | | ✅ |
| **contact** | send | ✅ (1) | ✅ (1+) | | | ✅ (1+) [C] | ✅ (stdin -) | | | | | | ✅ |
| | get | ✅ (1) | ✅ | | | ✅ (1+) [C] | | | ✅ (1) | ✅ (1) | ✅ (1) | | ✅ |
| | listen | ✅ (1) | ✅ | | | ✅ (1+) [C] | | | ✅* (1) | ✅* (1) | ✅* (1) | ✅ | ✅ |
| **private-group** | send | ✅ (1) | ✅ (Cond) | | | ✅ (1+) [C] | ✅ (stdin -) | ✅ (1) | | | | | ✅ |
| | get | ✅ (1) | ✅ (Cond) | | | ✅ (1+) [C] | | ✅ (1) | ✅ (1) | ✅ (1) | ✅ (1) | | ✅ |
| | listen | ✅ (1) | ✅ (Cond) | | | ✅ (1+) [C] | | ✅ (1) | ✅* (1) | ✅* (1) | ✅* (1) | ✅ | ✅ |
| **open-group** | send | ✅ (1) | | | ✅ (1+) | ✅ (1) | ✅ (stdin -) | | | | | | ✅ |
| | get | ✅ (1) | ✅ | | ✅ (1) | ✅ (1) | | | ✅ (1) | ✅ (1) | ✅ (1) | | ✅ |
| | listen | ✅ (1) | ✅ | | ✅ (1) | ✅ (1) | | | ✅* (1) | ✅* (1) | ✅* (1) | ✅ | ✅ |
| **closed-group** | send | ✅ (1) | | | ✅ (1+) | ✅ (1) | ✅ (stdin -) | | | | | | ✅ |
| | get | ✅ (1) | ✅ | | ✅ (1) | ✅ (1) | | | ✅ (1) | ✅ (1) | ✅ (1) | | ✅ |
| | listen | ✅ (1) | ✅ | | ✅ (1) | ✅ (1) | | | ✅* (1) | ✅* (1) | ✅* (1) | ✅ | ✅ |
| **public-channel** | send | ✅ (1) | | ✅ (1+) [C] | | ✅ (1+) [C] | ✅ (stdin -) | | | | | | ✅ |
| | get | | | ✅ (1) | | ✅ (1+) [C] | | | ✅ (1) | ✅ (1) | ✅ (1) | | ✅ |
| | listen | | | ✅ (1) | | ✅ (1+) [C] | | | ✅* (1) | ✅* (1) | ✅* (1) | ✅ | ✅ |
| **post** | send | ✅ (1) | | | | ✅ (1+) [C] | ✅ (stdin -) | | | | | | ✅ |
| | get | | ✅ | | | ✅ (1+) [C] | | | ✅ (1) | ✅ (1) | ✅ (1) | | ✅ |
| | listen | | ✅ | | | ✅ (1+) [C] | | | ✅* (1) | ✅* (1) | ✅* (1) | ✅ | ✅ |
| **key** | generate | | | | | | | | | | | | ✅ |
| | convert-* | ✅* (1) / ✅* / ✅* | | | | | | | | | | | ✅ |
| | derive-* | ✅ (1) | | | | | | | | | | | ✅ |

**Notes0**:
- `--exec`: Available on all `listen` verbs. Executes a shell command for every received message. The raw JSON event is piped to `stdin`, and metadata is provided via `OXCHATCLI_*` environment variables. The command runs in the background to prevent blocking the listener.
- `--nsec`: Accepts an alias (from `identities.sh`), an `nsec1...` string, or a 64-char private hex. Required for NIP-29 (open/closed groups) across all verbs.
- `--npub` for `private-group` (Cond):
  - If `private-groups.sh` config is present: `--npub` is **FORBIDDEN**.
  - If `private-groups.sh` config is absent: `--npub` is **ALLOWED/REQUIRED**.
- `key convert-*`: Requires `--nsec` (for nsec-to-hex), `--npub` (for npub-to-hex), or `--hex` (for hex-to-nsec/npub) depending on the specific verb.
