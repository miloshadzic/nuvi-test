# nuvi test

This is a very simple solution based on the problem description:

> This URL (http://bitly.com/nuvi-plz) is an http folder containing a list of zip files. Each zip file contains a bunch of xml files. Each xml file contains 1 news report.
>
> Your application needs to download all of the zip files, extract out the xml files, and publish the content of each xml file to a redis list called “NEWS_XML”.
>
> Make the application idempotent. We want to be able to run it multiple times but not get duplicate data in the redis list.

This ruby script goes through all of the links in the URL in sequence, downloads them, unpacks and publishes to the ``NEWS_XML`` Redis list.

Run it with ``bundle exec ruby nuvi.rb``

Some notes:

* The idempotency requirement is satisfied in the simplest possible way by deleting the list at the start. I didn't do upserting since the required structure for insertion is a redis list and the keys are indexes.

* The logging is super basic

* I wrote a version that splits downloading and publishing into two threads but on my connection the gains were minimal so I reverted to this simpler version. Would probably make sense for the real world version of this app.
