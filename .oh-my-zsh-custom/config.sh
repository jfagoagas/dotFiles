## Usage: set "ZSH_CUSTOM" to this dir and add "source $ZSH_CUSTOM/config.sh" before "source $ZSH/oh-my-zsh.sh"
# oh-my-zsh config
alias difff="git diff --no-index"

haste() {
    a=$(cat)
    curl -X POST -s -d "$a" https://hastebin.com/documents | awk -F '"' '{print "https://hastebin.com/"$4}'
}

chkcert() {
    if [ "$#" -eq 2 ]; then
        chk_srv="$1"
        chk_port="$2"
        chk_sni=""
    elif [ "$#" -eq 3 ]; then
        chk_srv="$1"
        chk_port="$2"
        chk_sni="$3"
    else
        echo "Usage: $0 name_or_ip port optional_sni"
        return 1
    fi

    if [ -z "$chk_sni" ]; then
        openssl s_client -connect "${chk_srv}:${chk_port}"
    else
        openssl s_client -connect "${chk_srv}:${chk_port}" -servername "${chk_sni}"
    fi < /dev/null | openssl x509 -noout -text
}
# Terraform
stack()  {
    for workspace in $(echo dev stg pro); 
    do 
        terraform workspace select "${workspace}"
        terraform validate
        terraform apply 
    done
}

# Password generator
# Usage: passgen <false> (false to not use symbols)
passgen() {
    symbols="${1}"
    if ! ${symbols}
    then
        cat /dev/urandom | env LC_CTYPE=C tr -dc a-zA-Z0-9 | head -c 24; echo
    else
        cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9%^&*()_+-=[]{}|' | head -c 24; echo
    fi
}

# Excalidraw shared session
excalidraw() {
    BASE_URL="https://excalidraw.com/#room="
    ROOM=$(cat /dev/urandom | env LC_CTYPE=C tr -dc a-f0-9 | head -c 20)
    KEY=$(cat /dev/urandom | env LC_CTYPE=C tr -dc a-f0-9 | head -c 22)
    echo "${BASE_URL}${ROOM},${KEY}"
}


# Golang project directories
init-go-project() { 
    PROJECT_NAME="${1}"
    mkdir -p "${PROJECT_NAME}"/{cmd,internal,lib}
    mkdir -p "${PROJECT_NAME}"/cmd/"${PROJECT_NAME}"
    touch "${PROJECT_NAME}"/cmd/"${PROJECT_NAME}"/main.go
    cd "${PROJECT_NAME}" || return
    go mod init "${PROJECT_NAME}" 
    go mod tidy
}
