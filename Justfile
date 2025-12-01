today: 
    just day_{{ datetime_utc("%d") }}

day_01:
    cd src; gleam run -t javascript --runtime bun 
    
