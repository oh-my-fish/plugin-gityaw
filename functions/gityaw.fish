function gityaw -d "Replace Git HTTPS remote by SSH"
  if not git status >/dev/null ^&1
    echo "This doesn't look to be a git repository"
    return 1
  end

  if not set remote (command git remote show)
    echo "No remote available"
    return 1
  end

  set https (command git remote get-url $remote)

  if echo $https | grep -q '.*@.*:.*'
    echo "Git remote looks to be already a valid SSH remote"
    return 1
  end

  set regex 's/https:\/\/\(.*\)\/\(.*\)\/\(.*\)\(.git\)*/git@\1:\2\/\3.git/' 

  echo $https | sed -e "$regex" | read -l ssh

  command git remote set-url "$remote" "$ssh"

  echo "Replaced '$https' by '$ssh'"
end
