# ==============================================================================
# 0xchat-cli Multi-User Identity Configuration
# ==============================================================================
# Default location: ~/.config/0xchat-cli/identities.sh
#
# FORMAT: "alias|nsec-or-private-hex"
#   - alias: A short, memorable name for the identity (e.g., "alice", "work-bot")
#   - nsec-or-private-hex: The private key (nsec1... or 64-char private hex)
#
# DEFAULT_IDENTITY: The alias, nsec, or private hex to use
#   if --nsec is not provided.
#   Can be an alias, nsec1..., or 64-char private hex. Resolved heuristically.
#
# PRECEDENCE:
#   1. CLI --nsec (accepts alias, nsec, or private hex)
#   2. DEFAULT_IDENTITY below
#   3. First entry in CONFIG_IDENTITIES
#
# WARNING: Keep this file private! Anyone with these keys can impersonate you.
# ==============================================================================

# DEFAULT_IDENTITY="alice"

# CONFIG_IDENTITIES=(
#     "alice|nsec1yh8723648........................................123456abc"
#     "bob|25dd6612381659b7........................................1234563a"
#     "work-bot|nsec1f23442........................................12345698abcd"
# )
