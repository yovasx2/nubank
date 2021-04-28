# Nubank

This is an interview exercise for Nubank

## Pre-requisites

In order to execute this project you need to install:

* [Docker compose](https://www.docker.com/)

## Run project

1. Move into it

       $ cd nubank

1. Build with docker

       $ docker-compose build

1. Up all containers

       $ docker-compose run nubank ruby main.rb < operations

    Where `operations` is a file containing JSON lines with account/transactions info as follows:

    ```
    { "account": { "activeCard": true, "availableLimit": 10 } }
    { "transaction": { "merchant": "Burger King1", "amount": 2, "time": "2019-02-13T10:05:01.000Z" } }
    { "transaction": { "merchant": "Burger King2", "amount": 2, "time": "2019-02-13T10:05:02.000Z" } }
    { "transaction": { "merchant": "Burger King3", "amount": 2, "time": "2019-02-13T10:05:03.000Z" } }
    { "transaction": { "merchant": "Burger King4", "amount": 2, "time": "2019-02-13T10:05:04.000Z" } }

    ```

## Run specs

       $ docker-compose run nubank bundle exec rspec

## Design choices

    - Docker, for portability and ease of deployment
    - Ruby, it allows you to build things quickly and reliably
    - Rspec, the de facto ruby test suite for integration and unit testing

### Overall architecture

    - main, the entrypoint that reads from STDIN
      - authorizer, the one on charge to keep track of the account and execute 
        each line of information
        - processors, each kind of entity is attended by a particular processor, 
          making it extensible
          - models, the detected entities in the business logic
          - validators, the business rules, each rule is attended by a particular 
            validator, making it extensible if new rules are coming
          - serializers, the responsibles to format the entities for the STDOUT
