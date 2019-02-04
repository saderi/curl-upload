# Upload files and folders with curl like using FTP
This is a simple bash script for upload files and folders with curl.

If you use Travis-CI and you want to deploy your project with FTP, it would not help, beacuse of NAT layer is added.

Read [this](https://blog.travis-ci.com/2018-07-23-the-tale-of-ftp-at-travis-ci) if you don't know the story.

I wrote this simple bash script to upload content of **build/dist** folder.