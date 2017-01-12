READ ME :
Topic: Extracting and Analyzing Social Media Data

Steps to run the project:

Part 1:
Twitter data extraction and analysis:
API used: REST AP, Streaming API
Packages used: twitteR, streamR
After installing the above packages get the access token as follows:
1) Go to apps.twitter.com and sign in.
2) Click on Create New App.
3) Fill name, description, and website (it can be anything, even google.com).
4) Leave the 'Callback URL' empty.
5) Agree to user conditions.
6) Copy consumer key and consumer secret and paste in the source code to run the project further for accessing data from twitter.

There are four files in the folder Twitter_Analysis/Code&Output that need to be copied to the system on which the program will be 
executed: twitter.r (for collection of data), twitter-analysis.r(analysis part), function.r and lexicon.csv
--> twitter.r needs to be executed first with all the file url's(in twitter.r) replaced with local path in the system on which it is being run.
For example: In file twitter.r, consider the line 
	save(my_oauth, file="K:/GDrive/MS-CS/3rdSem/SocialMedia/Project/oauth_token.Rdata"). 
		Replace  K:/GDrive/MS-CS/3rdSem/SocialMedia/Project by the local-path i.e., 
	save(my_oauth, file="local-path/oauth_token.Rdata"). 

--> this is followed by the execution of twitter-analysis.r
 

Part 2:
Facebook data extraction and analysis:

Packages used: Rfacebook, tm and wordcloud
After installing the above packages get the access token as follows:
1) At the URL: https://developers.facebook.com/tools/explorer
2)Click on "Get Access Token" to get the user access token for the application.
3) Put this token in the source code to run the project further for accessing data from facebook.

The program FB.R can be found in the folder Facebook.





 