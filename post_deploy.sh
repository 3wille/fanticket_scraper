#!/usr/bin/bash

bundle
sudo systemctl restart fansale_listener.service
sudo systemctl restart fansale_scrape.service
sudo systemctl status fansale_listener.service
sudo systemctl status fansale_scrape.service
