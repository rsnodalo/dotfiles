# iTerm2 preferences

`bootstrap.sh` points iTerm2 here via `PrefsCustomFolder`, so its settings are
version-controlled and restored on every machine.

**First-time setup (once):**

1. Open iTerm2.
2. Settings → Profiles → Text → Font → **Monaspace Neon** (or Argon/Xenon —
   the `font-monaspace-nf` cask installs all styles with Nerd Font icons).
3. iTerm2 menu → **Make iTerm2 Default Term**.
4. Settings → General → Settings → enable **Save changes to folder when iTerm2 quits**.
5. Quit iTerm2 → a `com.googlecode.iterm2.plist` appears here → commit it.

After that, this folder's plist is the source of truth across machines.
