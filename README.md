# event_manager

## Event Manager

A Ruby application to manage event attendees and generate personalized thank-you letters for conference participants.

## Overview

This project reads attendee data from a CSV file, fetches their representatives using the Google Civic Information API, and generates personalized thank-you letters in HTML format. The letters are saved in the `output` folder.

## Features

- **CSV Processing**: Reads attendee data from `event_attendees.csv`.
- **API Integration**: Fetches legislator information using the Google Civic Information API.
- **Template Rendering**: Uses ERB templates (`form_letter.erb`) to generate personalized thank-you letters.
- **Output Generation**: Saves generated letters in the `output` folder.

## Setup

1. **Install Dependencies**:
   Ensure you have Ruby installed. Then, install the required gems:

   ```bash
   bundle install