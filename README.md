URL shortening is a technique on the World Wide Web in which a Uniform Resource Locator (URL) may be made substantially shorter and still direct to the required page.

## Local setup

  * Install dependencies with `mix deps.get`
  * Setup Postgres `./bin/setup`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with

   `$ PGDATABASE=samlinks PGUSER=samlinks PGPASSWORD=samlinks mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Docker

with docker-compose:  `$ docker-compose up`

## Test

With [ab - Apache HTTP server benchmarking tool](https://httpd.apache.org/docs/2.4/programs/ab.html):

`$ ab -p test/post_data.json -T application/json -n 100 -c 10 http://127.0.0.1:4000/api`


## Functional Requirements:

- [x] Given a URL, our service should generate a shorter and unique alias of it. This is called a short link.

  ```shell
    [dev][yao@moonboots-2:~/samlinks]
    λ curl -d '{"url":"http://example.com/about/index.html?uid=<%token%>&email=<%email%>&city=<%city%>"}' -H "Content-Type: application/json" -X POST http://localhost:4000/api | jq '.'

    {
      "data": {
        "link": "s.am/jRqXNio",
        "slug": "jRqXNio",
        "url": "http://example.com/about/index.html?uid=%3C%25token%25%3E&email=%3C%25email%25%3E&city=%3C%25city%25%3E"
      }
    }
    ```
