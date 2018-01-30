---
layout: post
title: "A Simple, Stateless Password Manager"
excerpt: "A new project that uses a tabula recta to create and store passwords."
#modified:
tags: [JavaScript, password manager, cryptography, seedrandom.js, sjcl.js]
comments: true
share: false

---

I was recently doing some research into different password managers, and I came across an interesting [blog post](http://blog.jgc.org/2010/12/write-your-passwords-down.html).  Apparently, the author uses an old cryptographic tool called a [tabula recta](https://en.wikipedia.org/wiki/Tabula_recta) to generate and remember his passwords:

> Research says you need 80-bits of entropy in your password so it needs to be long, chosen from a wide range of characters and chosen randomly. My scheme gives me 104 bits of entropy.  My passwords are generated using a little program I wrote that chooses random characters (using a cryptographically secure random number generator) and then printing them out on a tabula recta. . . I use that sheet as follows. If I'm logging into Amazon I'll find the intersection of column M and column A (the second and third letters of Amazon) and then read off diagonally 16 characters. . . The security of this system rests on the randomness of the generated characters and the piece of paper.

After reading this, I realized it might be possible to make this system a little more user friendly by automating some of the steps.  I ended up making a simple webpage that generates a tabula based on a master password, which then can be used to generate site-specific passwords.  Here are the steps: 

1. Enter a strong master password.  This password is used as the seed for an in-browser random number generator ([seedrandom.js](https://github.com/davidbau/seedrandom)), which will always generate the same unique grid of characters based your the master password.    
2. Select a pattern to follow.  Current options are `line`, `step`, `spiral`, or `manual` (if you want to to create your own pattern).  
3. Click a memorable starting cell for the pattern, such as the grid location [A,N] for **a**mazo**n**.com.  If you chose an automated pattern, the password will be generated after you click.  
4. When you need the password in the future, repeat steps 1-3 above. 

Try it out below:

**Note**: This project is still experimental, so it needs more scrutiny before I'd recommend using it. If you do, print out a copy of the table so you have a backup if I change the code.

<!--https://stackoverflow.com/questions/5867985-->
<div class="outer">
<div class="inner">
<iframe src="{{ site.baseurl }}/projects/tabula-embed.html"
    style="width: 98vw; height: 110vh; border: none; position: relative; right:-50%; scrolling:no;"></iframe>
</div>
</div> 

## How secure is this system?

#### Web Security

This approach does sacrifice security for convenience to some extent -- you're using your computer and a web browser to create passwords rather than a piece of paper. This leaves you vulnerable to script injections or keylogging software.  The master password is never sent to a server and the code doesn't make any network requests, so some risks can be reduced by turning your internet connection off or using a local version of the HTML page.  On the other hand, you don't have to store a physical copy of your table anywhere, so it's a little more secure in that sense.

#### Cryptography

`Hashed password -> Decrypted password`

If someone gets a hashed version of one of your passwords and doesn't know your grid, these passwords would take a very long time to crack.  For example, using a password with 16 of the advanced characters has `log_2(88^16) = 103` bits of entropy.

`Decrypted Password -> Reconstruction of master password and table`

If someone obtained one of your site-specific passwords, it's possible that they could re-create a copy of your grid.  They would do this by trying a bunch of different master password inputs, and checking if the output contains a string that matches your site password.  I don't know how to estimate the feasibility of this attack, but choosing a strong master password could help mitigate the risk.  In addition, I use [scrypt](https://en.wikipedia.org/wiki/Scrypt) to convert the master password into a seed for the random number generator, which should make it more resource-intensive to try this attack.  

`Copy of Master password or grid -> Reconstruction of site-specific passwords`

If someone were to steal your master password or table they'd get an ordered grid of characters.  They would still need to perform a brute force attack to get a password, but it wouldn't be very hard to do so by trying common patterns. I estimate it would take anywhere from a year to less than a second depending on whether they're using a rate-limited web form or trying to break a hashed password from a leaked database (see the appendix).

Once they have one password, they could probably figure out the rest if you used the same generating pattern for all of them.  It might be possible to improve this system by having the user add a salt to the password after it's generated, but that would only add security until someone obtains a raw version of one of your passwords.

#### Usability

The interface allows the user to hide the grid, toggle password highlighting, and hide password forms to prevent [shoulder surfing](https://en.wikipedia.org/wiki/Shoulder_surfing_%28computer_security%29).  It also includes some automated patterns that users can choose between.  While these patterns do give an attacker a template to follow during a brute force attack, I think people would probably choose more obvious patterns if they had to manually enter them.  For extra security, one could select the manual option and use a unique, site-specific pattern for each password.     

## How does this stack up against other password managers?

It seems like my approach would be a little more secure, but less capable than cloud based versions of [LastPass](https://www.lastpass.com/) or [1password](https://1password.com/).  With those systems, if your master password is compromised and you don't have two factor authentication enabled, your entire vault is compromised.  With my system, someone still needs to brute force your grid of characters.  But the downside is you don't have some of the perks of those systems like storing encrypted documents, group sharing, or emergency credential release. 

Using a tabula is probably less secure than local password managers like the ([disappearing](https://medium.com/@kennwhite/who-moved-my-cheese-1password-6a98a0fc6c56)) desktop version of 1password, [Pass](https://www.passwordstore.org/), [Enpass](https://www.enpass.io/), [KeePass](https://keepass.info/), [pick](https://github.com/bndw/pick), or [Codebook](https://www.zetetic.net/codebook/).  If you only use a local manager on a single device, that's probably the most secure option (assuming you trust the developers and their code).  Even if you back up your local database in the cloud with a service like DropBox, it's probably still secure if you use strong encryption.  The only real vulnerability is if your device is compromised, as the attacker could access all your passwords at once.       

## Summary 

So, to sum up, this is what my system does:

* Generates site-specific passwords with as many bits of entropy as you need
* Allows users to choose between broad character-sets depending on site requirements  
* Makes it easy to remember complex passwords without storing them anywhere
* Allows access anywhere, on any computer or smartphone you trust

What it doesn't do:

* Store existing passwords
* Create passwords for sites with detailed character requirements
* Encrypt documents
* Protect against [keyloggers](https://en.wikipedia.org/wiki/Keystroke_logging), or other malware  
* Protect against phishing attempts
* Securely share passwords
* Incorporate two-factor authentication

## Next Steps

I put the code up on [GitHub](https://github.com/psthomas/tabula) so anyone can contribute and review.  I'm especially interested in improving the security against the potential attacks I outlined above.  Also, I want to know more about the [quality](http://davidbau.com/archives/2010/01/30/random_seeds_coded_hints_and_quintillions.html) of the [random number](https://github.com/davidbau/seedrandom/blob/released/seedrandom.js#L144) generator I'm using because this system depends on having a random grid of characters.

If there's interest, I could also look into making a desktop app using something like the Electron framework, or a mobile app using React Native to avoid the browser altogether.   

## Appendix

Brute forcing a tabula recta is discussed on stackexchange [here](https://security.stackexchange.com/questions/13579/using-a-tabula-recta-to-store-passwords/13745#13745).  Here's a basic calculation:

`(26*26 cells) * (20 common patterns) * (20 potential password lengths, 10-30chars) * (8 starting directions, including diagonals) = ~2 million options`.

So on average this would take about `2 million/2 = 1 million` guesses to crack.  Using rates from [zxcvbn](https://github.com/dropbox/zxcvbn#usage):

On a rate limited site: `1,000,000 / (100/hour) = 10000 hrs = 416 days`  
On a non-rate limited site: `1,000,000/(10*60*60) = 27.8 hrs`    
Offline, slow hashing algorithm: `1,000,000/(1e4*60) = 1.7 minutes`  
Offline, fast hashing algorithm: `1,000,000/(1e10/second) = <<1 second`  