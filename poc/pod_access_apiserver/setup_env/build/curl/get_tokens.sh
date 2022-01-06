#!/bin/bash
get_secrets(){
    
}

get_token_from_secret(){
    kd secret $1 | grep -E '^token' | cut -f2 -d":"|tr -d '\t' | tr -d ' '
}