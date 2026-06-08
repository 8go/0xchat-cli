# ==============================================================================
# 0xchat-cli Consolidated Private Groups Configuration
# ==============================================================================
# Default location: ~/.config/0xchat-cli/private-groups.sh
#
# FORMAT:
#   You can define members on separate lines for large groups,
#   or use pipes (|) on a single line for small groups.
#
# Member entries can be:
#   - npub1...
#   - 64-char public hex
#   - alias (from contacts.sh)
#   - NIP-05 identifier (user@domain)
#
# NOTE: Do NOT include your own identity in member lists.
#       The CLI adds the sender automatically.
#
# This file defines ALL private groups in one place.
#
# USAGE:
#   When this file exists, --group-name is REQUIRED and --npub is FORBIDDEN.
#   When this file does NOT exist, --group-name is REQUIRED and
#     --npub options are ALLOWED.
# ==============================================================================

# # Large group: Easy to read, one member per line
# CONFIG_PRIVATE_GROUPS["My family"]="
#     npub1alice................................................................
#     abc123def456abc123def456abc123def456abc123def456abc123def456abcd
#     npub1charlie..............................................................
# "

# # Medium group: Aliases with spaces are perfectly preserved
# CONFIG_PRIVATE_GROUPS["Our work group"]="
#     Alice
#     Bob Smith
#     id@nip-05.com
# "

# # Small group: Pipes or spaces on a single line work perfectly too
# CONFIG_PRIVATE_GROUPS["Example group name"]="npub3example... |Member 2 Alias|Alias-member3"

# Provide one CONFIG_PRIVATE_GROUPS["name"]="member1|member2|member3" for each private group.
