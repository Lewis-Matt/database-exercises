# Passwords
One of the things that should constantly be on our minds as developers is the best interests of the users of the software we are creating. People tend to reuse passwords, and for a too large number of people, if a single password were ever compromised, an attacker could have access to all of their online accounts. This means that we should take great care when storing user passwords.

## Hashing & Salting Passwords
The best practice for handling users credentials is by hashing their passwords. Hashing is applying an irreversible mathematical function to an input string to produce an output string. Importantly, hashing is distinct from encryption, which is applying a reversible function to an input to produce an output that can later be decoded.

There's actually even more going on than just plain hashing; we also should salt passwords. Salting is simply the addition of a unique, random string of characters known only to the site to each password before it is hashed, typically this “salt” is placed in front of each password.

Without salt, an attacker could try a dictionary attack. Using a pre-arranged listing of words, such as the entries from the English dictionary (there are many dictionaries that have been created, e.g. leetspeak), with their computed hash, the attacker easily compares the hashes from a stolen password table with every hash on the list. If a match is found, the password then can be deduced.

https://auth0.com/blog/adding-salt-to-hashing-a-better-way-to-store-passwords/

In contrast to encryption, once you hash something, the original input value cannot be retrieved, although, through fancy mathematical means, we can verify that two hashes came from the same original input. 

### How to hash
1. When we create a user record in our database, we want to make sure the password is hashed before it is stored.
2. When a user tries to log in, we will try to verify the submitted password against the hash we have stored in our database.

In order to do implement this, we'll use the BCrypt algorithm to hash passwords. We can find an implementation of bcrypt through this library:

    <!-- https://mvnrepository.com/artifact/org.mindrot/jbcrypt -->
    <dependency>
        <groupId>org.mindrot</groupId>
        <artifactId>jbcrypt</artifactId>
        <version>0.4</version>
    </dependency>
Let's take a look at what happens when we hash a password:

    String password = "password123";
    String hash = BCrypt.hashpw(password, BCrypt.gensalt());
    System.out.println(hash);
    // Output: $2a$10$TbjLzPRB1MBIQAQbFsmANOumLP0oOEU1b.MvZFkeqIG0D8RqzFbIq
Here we use the `hashpw` method of the BCrypt class to generate our hashed password, then print it out. Salt was also added, so if we were to compute the hash of the original password twice, the results would be different (w/o salt, the hash would be the same).

- Within your web application, when a user signs up, your application will have access to their plain text password. You should make sure that you don't store this plain text value in your database. Instead, you should hash the password, and store the hash in your database.

### Verifying Hashes
We can check to see if a given plaintext string matches a known hash like so:

    String password = "password123";
    String hash = BCrypt.hashpw(password, BCrypt.gensalt());
    
    boolean passwordsMatch = BCrypt.checkpw("mypassword", hash);
    System.out.println(passwordsMatch); // false
    
    passwordsMatch = BCrypt.checkpw("password123", hash);
    System.out.println(passwordsMatch); // true

Here we use the `checkpw` method of the BCrypt class to check if a plaintext password matches the calculated hash. If the first argument is the same as the original input that was used to create the hash, it will return true, otherwise it will return false.

- When a user logs in, you will check the value they entered into the login form (the plaintext password) against the value you have stored in your database (the hash). Based on the return value of the `checkpw` method, you can either log the user in, or send them back to the login page.

## Summary
        Method 	                                            Description
    BCrypt.hashpw(password, BCrypt.gensalt()) 	    Generate a hash from the given plaintext password
    BCrypt.checkpw(password, hash) 	                    Verify that a given plaintext password matches a known hash