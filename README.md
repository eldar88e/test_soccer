# Soccer

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version 3.2.2

* System dependencies
    - rails 7.1.4
    - sidekiq 7.3.2

* Database config(example)
  
  - create .env file and add the next lines
    ```yaml
      RAILS_MASTER_KEY=2234234234234
    
      REDIS_URL="redis://localhost:6379/1"
    
      DB_HOST=localhost
      DB_USER=admin
      DB_PASSWORD=admin
    ```

* Database creation
  ```yaml
    rails db:setup
  ```

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)
  ```shell
    bundle exec sidekiq
  ```

* Example json for adding new match:

```ruby
{ "data": {
    "importance": 2,
    "date": "2024-02-02",
    "home_team": {
      "name": "Pumas",
      "statistics": [
        { "name": "Player 1", "role": "Goalkeeper", "saves": 5, "interceptions": 2, "distribution": 2 },
        { "name": "Player 2", "role": "Forward", "goals": 2, "assists": 2, "shots": 2 },
        { "name": "Player 3", "role": "Forward", "goals": 1, "assists": 4, "shots": 3 },
        { "name": "Player 4", "role": "Midfielder", "assists": 2, "tackles": 8 },
        { "name": "Player 5", "role": "Midfielder", "assists": 2, "tackles": 8 },
        { "name": "Player 6", "role": "Midfielder", "assists": 2, "tackles": 8 },
        { "name": "Player 7", "role": "Midfielder", "assists": 2, "tackles": 8 },
        { "name": "Player 8", "role": "Defender", "assists": 3, "tackles": 6, "blocks": 7 },
        { "name": "Player 9", "role": "Defender", "assists": 3, "tackles": 6, "blocks": 7 },
        { "name": "Player 10", "role": "Defender", "assists": 3, "tackles": 6, "blocks": 7 },
        { "name": "Player 11", "role": "Defender", "assists": 3, "tackles": 6, "blocks": 7 }
      ]
    },
    "away_team": {
      "name": "Titans",
      "statistics": [
        { "name": "Player 1", "role": "Goalkeeper", "saves": 8, "interceptions": 2, "distribution": 2 },
        { "name": "Player 2", "role": "Forward", "goals": 1, "assists": 2, "shots": 2 },
        { "name": "Player 3", "role": "Forward", "assists": 4, "shots": 3 },
        { "name": "Player 4", "role": "Midfielder", "assists": 2, "tackles": 8 },
        { "name": "Player 5", "role": "Midfielder", "assists": 2, "tackles": 8 },
        { "name": "Player 6", "role": "Midfielder", "assists": 2, "tackles": 8 },
        { "name": "Player 7", "role": "Midfielder", "goals": 1, "assists": 2, "tackles": 8 },
        { "name": "Player 8", "role": "Defender", "assists": 3, "tackles": 6, "blocks": 7 },
        { "name": "Player 9", "role": "Defender", "assists": 3, "tackles": 6, "blocks": 7 },
        { "name": "Player 10", "role": "Defender", "assists": 3, "tackles": 6, "blocks": 7 },
        { "name": "Player 11", "role": "Defender", "assists": 3, "tackles": 6, "blocks": 7 }
      ]
    }
  }
}
```

* Example url for getting a match information:

```http://127.0.0.1:3000/statistics?team_id=2&top=3&page=1&per_page=2&from=2023-01-01&to=2024-12-31&role=Defender```
