#!/bin/bash
# im-hanzou and L

# ANSI color codes
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "\n\t\t${YELLOW}im-hanzou | https://www.rdatadao.org Auto Verifier${NC}\n"
echo -e "\t\t\t\t${CYAN}==> Step By Step <==${NC}\n"
echo -e "${CYAN}1. Login to rdatadao.org then insert your reddit username and connect your EVM wallet.${NC}"
echo -e "${CYAN}2. Open this link ${NC}[ ${YELLOW}https://www.rdatadao.org/claim/verification?_data=routes/claim.verification ${NC}]${CYAN} in your browser.${NC}"
echo -e "${CYAN}3. Copy and paste your full response data here.${NC} \n"
echo -ne "${CYAN}Insert full data: ${NC}"
read DATA

TOKEN=$(echo "$DATA" | sed -n 's/.*"token":"\([^"]*\)".*/\1/p')
USER=$(echo "$DATA" | sed -n 's/.*"user":"\([^"]*\)".*/\1/p')

CODE=$(curl -s -X POST "https://api.vana.com/api/v0/verification" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{"username": "'"$USER"'", "service": "reddit"}' | sed -n 's/.*"verificationCode":\([^,}]*\).*/\1/p' )

if [ -z "$CODE" ]; then
    echo -e "${RED}\nFailed to retrieve verification code! Your data is wrong or expired! Try again in 1 minute!\n${NC}"
    exit 1
fi

echo -e "\n${CYAN}Your verification code: ${NC}${GREEN}$CODE${NC}"
echo -e "${CYAN}\n4. Open ${NC}[ ${YELLOW}https://www.reddit.com/settings/profile${CYAN} ]${CYAN} in your browser then insert your code: ${GREEN}$CODE${NC}${CYAN} in about form.${NC}"
echo -e "\n${CYAN}I give you 1 minute, then the script will continue to verifying ...${NC}"
sleep 60
echo -e "\n${CYAN}Verification Process ... Wait :)${NC}"
VERIF=$(curl -s -X POST "https://api.vana.com/api/v0/verification/reddit" -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d '{"username": "'"$USER"'"}')

if [[ $VERIF == *"\"verified\":true"* ]]; then
    VERIFC="${GREEN}Success - Enjoy! <3${NC}"
else
    VERIFC="${RED}Failed - Try again in 1 minute!${NC}"
fi

echo -e "\n${CYAN}Verification Result: $VERIFC${NC}"
