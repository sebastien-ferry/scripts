#!/usr/bin/python
# Check HIBP Have I Been Pawned for SEVERAL *passwords*

# /!\ WARNING: passwords/arguments may be kept in command history (~/.bash_history)

# Note: sleep 1 second between requests (to follow recommendations)
# Usage hibp-check.py password1 password2 password3

from time import sleep
import requests
import hashlib

import sys

# Usage and warning
print("Warning: passwords may be stored in shell history (.bash_history) !")
print("Warning: quote the passwords as needed! pa$$word -> pa but 'pa$$word' is ok")
if len(sys.argv) < 2:
    print("usage %s password1 [password2...]" % sys.argv[0])
    sys.exit(-2)

if __name__ == "__main__":
    # Hide the command line (so ps, top can't display the passwords) 
    sys_argv_original = sys.argv
    sys.argv = [sys.argv[0]]

    for password in sys_argv_original[1:]:
        print('Checking: %s' % password)

        password_sha1 = hashlib.sha1(password.encode()).hexdigest().upper()
        password_hash_5_end = password_sha1[5:]
    
        api_return = requests.get('https://api.pwnedpasswords.com/range/' + password_sha1[:5]).content.decode().splitlines()
        
        for line in api_return:
            api_hash, api_occurences = line.split(':')
            if password_hash_5_end == api_hash:
                occurences = int(api_occurences)
                if occurences > 0:
                    print('Password: %s : %d times' % (password, occurences))
        sleep(1)
