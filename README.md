# Samlinks

URL shortening is a technique on the World Wide Web in which a Uniform Resource Locator (URL) may be made substantially shorter and still direct to the required page.

## Local setup

  * Install dependencies with `mix deps.get`
  * Setup Postgres `./bin/setup`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with

   `PGDATABASE=samlinks PGUSER=samlinks PGPASSWORD=samlinks mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Docker

with docker-compose:  `docker-compose up`

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

- [x] When users access a short link, our service should redirect them to the original link.
  `http://localhost:4000/:link`

- [x] In some cases we need to redirect to the URL by dynamic params that is not known when creating shortened URL. For such cases we want to send URL by some placeholders like <%token%> and those placeholders would be replace in redirection phase with the same param name. As an example we call endpoint to create shortened url with the URL "http://example.com/about/index.html?uid=<%token%>" and the endpoint would return "https://goo.gl/aO3Ssc".

- [x] Links will expire after 30 days default timespan, if link is not visisted within that period.
- [x] Analytics; We want to track clicks on a shortened URL in a queryable fashion for analytics purpose. e.g., how many times a redirection happened?
- [x] Package and run application in a docker container

## Non-Functional Requirements:

- [x] URL redirection should happen in real-time with minimal latency.
- [x] Shortened links should not be guessable (not predictable).
- [x] Our shortlinks should be as short as possible.
