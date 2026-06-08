# ==============================================================================
# 0xchat-cli Contacts Configuration
# ==============================================================================
# Default location: ~/.config/0xchat-cli/contacts.sh
#
# This file defines your known contacts. Each contact has an optional alias
# name and exactly one npub, Public-Hex or NIP-5 id like john@damus.com.
#
# FORMAT:
#   "npub1..."              # Contact with no alias
#   "alias|npub1..."        # Contact with alias (pipe-separated)
#
# NOTES:
# - Alias names are CASE-SENSITIVE.
# - You can reference contacts by alias or npub anywhere --npub is accepted.
# - If a contact is defined in both default and custom config, custom wins.
# - CLI --npub values always take precedence over config contacts.
# ==============================================================================

# CONFIG_CONTACTS=(
#   "Alice|npub1alice................................................................"
#   "Bob|abcf...public-hex-from-bob.................................................."
#   "charles@nip5server.com.........................................................."
#   "WorkBot|npub1workbot............................................................"
# )

# Tip: To create UNIQUE private rooms you can create one unique member for each room.
# You could create a user "beachparty" to make room "beachparty" unique.
# Then add "beachparty" here and as a member in your private "beachparty" group.
