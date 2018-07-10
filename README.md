# FC St.Pauli Fanticket Scraper

## Subscribe

Send ``/start`` to [@fcsp_ticket_bot](https://t.me/fcsp_ticket_bot) on Telegram.
To unsubscribe send ``/stop``.

## Intro
This is a scraping service intended to gain an advantage in buying second-market tickets for (european-)football matches of FC St. Pauli.
It uses ruby with Nokogiri for scraping the Website with a 10sec delay between scrape runs.
Once a new ticket is found, notifications are distributed to subscribers via a Telegram Bot.
