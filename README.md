## Description
This project provides an api enpoint that helps with retrieving reviews in json from this site: https://www.lendingtree.com/reviews.
It was created using rails 5 api-only mode. There's no database setup. 

## Requirements 
ruby 2.5.1 was used to code this, but you should be fine with a lower version if you want. As long as it is compatible with rails 5.2 and you change the .ruby-version file. 
## Setup instructions. 
- Install Ruby 2.5.1. (I use [rvm](https://rvm.io/) to install ruby on my system, you can use that too if you want. [rbenv](https://github.com/rbenv/rbenv) is okay too. )
- run `gem install bundler -v 1.16.6`. Clone repo. Navigate to the repo and run `bundle`. 
- As needed, fix errors that come up. 
- Run `bundle exec rails s`. Navigate to `localhost:3000` on your browser and If you see the default rails welcome page, you're all set. 

## Usage
- Check that your rails server is already running, if it's not running, do `bundle exec rails s`. 
- The only enpoint available is `/reviews`. Using the client of your choice, You can get reviews for a lender on the site `https://www.lendingtree.com/reviews`. Simply send a get request to `localhost:3000/reviews` and pass in the `lender_url` as a query parameter. You should get back a json respone of all reviews for the lender. I've been testing with this lender url: https://www.lendingtree.com/reviews/personal/first-midwest-bank/52903183
- NOTE: There are 10 reviews available per page, so depending on how many pages of reviews are available, it might take some time to get all of them. But if you want to see some data right away, I added the option to pass in `page_limit` as a query param. So you can pass in 2 for instance, if you just wanted to see the first 2 pages of reviews. 

sample response: 

```
{
  "data": {
    "reviews_count": 10,
    "reviews": [
      {
        "title": "Great experience",
        "content": "Working with Max Ortiz was a breath of fresh air.",
        "star_rating": "5",
        "date_of_review": "April 2019",
        "author_name": "Bruce",
        "author_city": "BELLEVILLE",
        "author_state": "IL"
      },
      .
      .
      .
    ],
    "timestamp": "2019-04-13T14:38:16.154+00:00",
    "number_of_pages": 1,
    "lender_url": "https://www.lendingtree.com/reviews/personal/first-midwest-bank/52903183"
  }
}
```


## Testing
- I have some unit tests available. run `bundle exec rspec` to run the test suite. 

## Benchmarking
It may take some time to get all the reviews because there are multiple pages. But here's some benchmark info which may give you a rough idea. 
- 10 pages ~ 10 seconds. 
- 30 pages ~ 30 seconds. 
- 100 pages ~ 100 seconds. 

These are pretty rough estimates so YMMV. I used postman to make the requests. I don't know if I can really improve this much because I can't really control how fast I get the data from lendingtree website. 

## Questions/Comments.
- Feel free to create issues or reach out to me directly at markdamobi@gmail.com if you have questions/comments. 