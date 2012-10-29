# Mightbuy - track things you might buy!
    This repository began it's long and tortured life as a separate
    application, prizzm-invites.  It has been converted over to MightBuy,
    but there is lots of legacy remnants at this point.

    See the app here: [www.mightbuy.it]

# Environment Variables

#### `RAILS_DONT_DELAY_JOBS`
    Setting this variable to `true` will prevent `Delayed::Job` to defer jobs. So,
    if mails will be delivered instantly.

    This is particularly useful when deploying to staging. Just inject this
    variable to heroku, and DelayedJobs wont be delayed
