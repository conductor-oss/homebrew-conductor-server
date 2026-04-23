# AGENTS.md — homebrew-conductor-server

Guidance for AI agents working in this Homebrew tap.

## After any formula change, run audit before committing

```shell
brew tap conductor-oss/conductor-server .
brew audit --strict conductor-oss/conductor-server/conductor
```

The audit must pass with zero warnings. Common violations caught here:

- **Description** must not start with the formula name (case-insensitive).
- **License** must be a valid SPDX identifier — `"Apache-2.0"`, not `"Apache 2.0"`.
- **`version`** field is redundant when the version appears in the URL; omit it.
- **`assert_predicate ..., :exist?`** is deprecated — use `assert_path_exists`.
- **Field order**: `desc`, `homepage`, `url`, `sha256`, `license`.

## Updating the formula to a new release

1. Find the latest stable release (not pre-release, not draft):
   ```shell
   gh release list --repo conductor-oss/conductor | grep -v "Pre-release\|Draft" | head -3
   ```

2. Verify the asset name for that release:
   ```shell
   gh release view <tag> --repo conductor-oss/conductor --json assets --jq '.assets[].name'
   ```
   Since v3.22.0 the asset is named `conductor-lite-{version}.jar`.

3. Download the JAR and compute sha256:
   ```shell
   curl -sL https://github.com/conductor-oss/conductor/releases/download/<tag>/conductor-lite-<version>.jar \
     -o /tmp/conductor-lite-<version>.jar
   shasum -a 256 /tmp/conductor-lite-<version>.jar
   ```

4. Update `Formula/conductor.rb`: URL, sha256, and the two JAR filename
   references inside `install` and `test`.

5. Run `brew audit --strict` (see above). Fix any warnings before committing.

## Java path in the wrapper script

The wrapper must use the Homebrew-managed Java, not the system default:

```ruby
exec "#{Formula["openjdk@21"].opt_bin}/java" -jar "#{libexec}/conductor-lite-<version>.jar" "$@"
```

Never use bare `java` — it will fail at runtime if the user's system Java is
not 21.

## Test block

The server JAR ignores `--version` and starts Tomcat, so never call the binary
in `test do`. Use existence checks instead:

```ruby
test do
  assert_predicate bin/"conductor", :executable?
  assert_path_exists libexec/"conductor-lite-<version>.jar"
end
```

## GitHub account

Always use `nthmost-orkes` for all `gh` commands in this repo:

```shell
gh auth switch --user nthmost-orkes && gh ...
```
