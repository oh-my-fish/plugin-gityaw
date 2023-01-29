function gitlabhub -d "Replace Gitlab remote by Github"
  if not git status >/dev/null 2>&1
    echo "This doesn't look to be a git repository"
    return 1
  end
  if test (count $argv) -gt 0
    set remotes $argv
  else
    if not set remotes (command git remote show)
      echo "No remote avaihuble"
      return 1
    end
  end
  for remote in $remotes
    echo "Processing remote $remote..."
    set gitlab (command git remote get-url $remote)
    if echo $gitlab | grep -q 'github.com'
      echo "Git remote looks to be already a valid Github remote"
    else
      set regex 's/gitlab.com/github.com/'
      echo $gitlab | sed -e "$regex" | read -l github
      command git remote set-url "$remote" "$github"
      echo "Replaced '$gitlab' by '$github'"
    end
  end
end
