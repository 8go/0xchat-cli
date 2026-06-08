# open-closed-groups.sh
# open-groups and closed-groups are built in NIP-29.
# Not all relays support NIP-29. Hence it is crucial that a relay
# is used that does support NIP-29.
#
# Format: "alias|type|group-id|relay" OR "type|group-id|relay"
# - alias: Optional nickname for the group
# - type: Must be exactly "open" or "closed"
# - group-id: The NIP-29 group ID (looks like 3db98c...8fa1)
# - relay: The specific WebSocket relay that manages this group

# You can get this info also from a nostr:naddr1... object. Use 0xchat-cli.sh to
# extract the values from such an naddr1 object.

# CONFIG_NIP29_GROUPS=(
#     "dev-chat|open|abc123def456abc0123456789abcdef0123456789abcde0123456789012345cb9|wss://groups.0xchat.com"
#     "closed|0123456789012345cb9abc123def456abc0123456789abcde46z1abcde0d1e2|wss://private-relay.example.com"
# )
