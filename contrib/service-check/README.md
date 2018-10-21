# Service checker for PI services

This is a looping bash script which checks that the node is online

## Invocation

```bash
./check.sh &
```

or 

```bash
curl "https://gitlab.com/nolim1t/financial-independence/raw/master/contrib/service-check/check.sh" 2>/dev/null | bash &
```

