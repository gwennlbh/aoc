today: 
    just day_{{ datetime_utc("%d") }}

day_01:
    just gleam
day_02:
    just gleam
day_03:
    just gleam
day_04:
    just gleam

gleam:
    cd src; gleam run -t javascript --runtime bun 
