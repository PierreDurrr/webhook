#!/bin/sh

echo "🚀 Starting NAME_OF_THE_CONTAINER_OR_SCRIPT container..."
echo ""
echo "🔄 Copying files to mounted volume (/config)..."
cp -rv /config/* /config/

echo ""
echo "✅ Verification of mounted directory (/config):"
ls -la /config

echo "⚙️  Starting cron service..."
service cron start
echo "✅ Cron started at $(date)"

# Verify that the cron job is loaded correctly
echo "✅ Verifying loaded crontab..."
crontab -l

# Echo the start of the container process
echo "🚀 Container started and waiting..."
echo "⏰ Started at: $(date)"

# Start the Flask app in the background
echo "⚙️  Starting Flask app..."
python /app/webhook.py &

# Keep the container running indefinitely
exec tail -f /dev/null 2>&1
