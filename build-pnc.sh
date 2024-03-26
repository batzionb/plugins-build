#!/bin/bash

# Function to process each plugin
process_plugin() {
  PLUGIN_NAME=$1
  echo "Processing $PLUGIN_NAME..."

  # Change directory to the plugin
  cd "plugins/$PLUGIN_NAME" || exit

  # Replace package name in package.json
  sed -i 's/@janus-idp\/backstage-plugin-'"$PLUGIN_NAME"'/@redhat\/backstage-plugin-'"$PLUGIN_NAME"'/g' package.json

  # Compile TypeScript
  yarn tsc

  # Build
  yarn build

  # Export dynamic
  yarn export-dynamic

  # Update version in package.json
  sed -i 's/"version": "\(.*\)"/"version": "\1-redhat-00001"/' package.json

  # Publish to npm
  npm publish

  # Go back to the original directory
  cd - || exit
}

# Process each plugin
plugins=("orchestrator" "orchestrator-backend" "notifications" "notifications-backend")
for plugin in "${plugins[@]}"; do
  process_plugin "$plugin"
done
