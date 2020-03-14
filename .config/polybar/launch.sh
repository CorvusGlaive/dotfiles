
#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

BAR="$1"
if [ -z "$1" ]; then 
  echo "No defined bar. Use default one"
  BAR="example" 
fi

# Launch bar1 and bar2
polybar "$BAR" &

echo "Polybar launched..."
