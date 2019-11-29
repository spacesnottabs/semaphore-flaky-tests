# Description

This application will scrape through Semaphore logs looking for flaky Rspec tests, reporting the results as follows:

```
{
  "path": <rpsec path>,
  "line": <line number>,
  "git_sha": <git sha>,
  "pipeline_id": <Semaphore pipeline id>,
  "job_id": <Semaphore job id>,
  "branch": <git branch>,
  "github_link": "#{GITHUB_PATH}/blob/#{git_sha}/{path}##{line}",
  "semaphore_job_link": "https://${COMPANY}.semaphoreci.com/jobs/#{job_id}",
  "created_at": "2019-11-28 14:47:29 +0000"
}   <error count>
```


# Prerequisites

- Project using Semaphore v2.0

# Installation instructions

`bundle install`

# Setup Semaphore

## Find your API Key

Find your API key from Semaphore, found at https://me.semaphoreci.com/account

## Connect your Semaphore CLI

Setup the sem CLI tool using this reference page:
https://docs.semaphoreci.com/article/53-sem-reference

The command to connect the sem CLI tool should be of the format:

`sem connect #{COMPANY}.semaphoreci.com #{API_KEY}`

## Find your Semaphore PROJECT_ID.

Find your PROJECT_NAME running:

`sem get projects`

and then use it to find your PROJECT_ID by running:

`sem get projects #{PROJECT_NAME}`

and capturing the 'id' field of the response.

# ENV file

Create a .env file based on .env.example using from the previous stage:

- API_KEY
- COMPANY
- PROJECT_ID
- Set the GITHUB_PROJECT_URL to your project path to get links to view the version of code that had the flaky test, eg https://github.com/spacesnottabs/semaphore-flaky-tests
- Set the MAX_PAGES setting to the number of pages you want to visit from the Semaphore logs. More pages means better analysis but takes longer and generates older output.

# Run script

Make sure that the script file has executable permissions and then run:

`bin/flaky_test`
