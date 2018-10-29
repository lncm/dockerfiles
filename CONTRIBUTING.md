# Contributing guidelines

When contributing to this repository, even though we do check all submissions please ensure yourself that your submissions actually work as well as we may miss something.

In addition, make use of the description (long and short) space in the pull request as common courtesy to let us know in english what the change is and maybe why its a good idea to include it. Blank or unmeaningful pull request messages may be rejected.

## Best Practices

Even though not required, it is **highly recommended** that your commits are signed with your PGP Signature.

The first steps is the install GnuPGP for your preferred platform.

Next once you've set up your keys (and stored it in a safe place), that you enable signing on git

### Recommended git signing settings

```bash
# Set up so that your git commit signs automatically
git config --global commit.gpgsign true

# Assign your userid as the signing userid
git config --global user.signingkey <your-key-id>


# Assign your email address to match your PGP signed key
git config --global user.email <your-email-address>
```

## Pull Request guidelines

Make a fork of this project first. Then create a branch within your fork with the changes. That way if you're asked to make certain changes it all can be reviewed in the pull request.
