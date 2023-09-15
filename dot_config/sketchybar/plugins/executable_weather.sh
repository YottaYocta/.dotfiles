#!/usr/bin/env bash
# True = daytime
weather_icon_map() {
    shopt -s extglob
    if [ "$1" = "true" ]; then # Daytime
        case $2 in
            *Snow*)
                icon_result=""
                ;;
            *Rain*)
                icon_result=""
                ;;
            *"Partly Sunny"* | *"Partly Cloudy"*)
                icon_result=""
                ;;
            *Sunny*)
                icon_result=""
                ;;
            *Cloudy*)
                icon_result=""
                ;;
            *)
                icon_result=""
                ;;
        esac
    else
        case $2 in # Night
            *Snow*)
                icon_result=""
                ;;
            *Rain*)
                icon_result=""
                ;;
            *Clear*)
                icon_result=""
                ;;
            *Cloudy*)
                icon_result=""
                ;;
            *Fog*)
                icon_result=""
                ;;
            *)
                icon_result=""
                ;;
        esac
    fi
    echo "$icon_result"
}

render_bar() {
    sketchybar --set weather.icon icon="$icon"
    sketchybar --set weather.temp label="$temp""°"
}

render_popup() {
    #sketchybar --remove '/weather.details.\.*/'

    weather_details=(
        label="$forecast $popup_weather"
        label.padding_left=80
        click_script="sketchybar --set $NAME popup.drawing=off"
        position=popup.weather.temp
        drawing=on
    )

    COUNTER=0

    sketchybar --clone weather.details."$COUNTER" weather.details
    sketchybar --set weather.details."$COUNTER" "${weather_details[@]}"

    while IFS= read -r period; do
        COUNTER=$((COUNTER + 1))

        if [ "$COUNTER" -lt 4 ]; then
            decoded_period="$period"
            period_name=$(echo "$decoded_period" | grep -o '"name": *"[^"]*"' | sed -E 's/"name": *"([^"]*)"/\1/')
            detailed_forecast=$(echo "$decoded_period" | grep -o '"detailedForecast": *"[^"]*"' | sed -E 's/"detailedForecast": *"([^"]*)"/\1/')
            temperature=$(echo "$decoded_period" | grep -o '"temperature": *"[^"]*"' | sed -E 's/"temperature": *"([^"]*)"/\1/')
            temperature_unit=$(echo "$decoded_period" | grep -o '"temperatureUnit": *"[^"]*"' | sed -E 's/"temperatureUnit": *"([^"]*)"/\1/')

            weather_period=(
                icon="$period_name - $temperature $temperature_unit"
                icon.color="$BLUE"
                label="$sentence"
                label.drawing=on
                click_script="sketchybar --set $NAME popup.drawing=off"
                drawing=on
            )

            item=weather.details."$COUNTER"
            sketchybar --add item "$item" popup.weather.temp
            sketchybar --set "$item" "${weather_period[@]}"

            SUBCOUNTER=0
            echo "$detailed_forecast" | grep -o -E '\b[^.!?]*[.!?]' | while IFS= read -r sentence; do

                SUBCOUNTER=$((SUBCOUNTER + 1))
                weather_period=(
                    label="$sentence"
                    label.drawing=on
                    click_script="sketchybar --set $NAME popup.drawing=off"
                    drawing=on
                )

                item=weather.details."$COUNTER"."$SUBCOUNTER"
                sketchybar --add item "$item" popup.weather.temp
                sketchybar --set "$item" "${weather_period[@]}"
            done

            sketchybar --add item weather.details.newline."$COUNTER" popup.weather.temp
        fi
    done <<< "$weather"
}

update() {
    # Bar
    url=$(grep -o '"url": *"[^"]*"' $CONFIG_DIR/weather_config.json | sed -E 's/"url": *"([^"]*)"/\1/')
    weather=$(curl -s "$url")
    temp=$(echo "$weather" | grep -o '"temperature": *"[^"]*"' | sed -E 's/"temperature": *"([^"]*)"/\1/')
    forecast=$(echo "$weather" | grep -o '"shortForecast": *"[^"]*"' | sed -E 's/"shortForecast": *"([^"]*)"/\1/')
    time=$(echo "$weather" | grep -o '"isDaytime": *"[^"]*"' | sed -E 's/"isDaytime": *"([^"]*)"/\1/')
    icon=$(weather_icon_map "$time" "$forecast")

    # popup
    url=$(grep -o '"url": *"[^"]*"' $CONFIG_DIR/weather_config.json | sed -E 's/"url": *"([^"]*)"/\1/')
    popup_weather=$(curl -s "$url" | sed 's/  */ /g')

    render_bar
    render_popup

    if [ "$COUNT" -ne "$PREV_COUNT" ] 2>/dev/null || [ "$SENDER" = "forced" ]; then
        sketchybar --animate tanh 15 --set "$NAME" label.y_offset=5 label.y_offset=0
    fi
}

popup() {
    sketchybar --set "$NAME" popup.drawing="$1"
}

case "$SENDER" in
    "routine" | "forced")
        update
        ;;
    "mouse.entered")
        popup on
        ;;
    "mouse.exited" | "mouse.exited.global")
        popup off
        ;;
    "mouse.clicked")
        popup toggle
        ;;
esac
