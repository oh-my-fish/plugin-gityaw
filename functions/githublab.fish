function githublab -d "Replace Github remote by Gitlab"
  if not git status >/dev/null 2>&1
    echo "This doesn't look to be a git repository"
    return 1
  end
  if test (count $argv) -gt 0
    set remotes $argv
  else
    if not set remotes (command git remote show)
      echo "No remote available"
      return 1
    end
  end
  for remote in $remotes
    echo "Processing remote $remote..."
    set github (command git remote get-url $remote)
    if echo $github | grep -q 'gitlab.com'
      echo "Git remote looks to be already a valid Gitlab remote"
    else
      set regex 's/github.com/gitlab.com/'
      echo $github | sed -e "$regex" | read -l gitlab
      command git remote set-url "$remote" "$gitlab"
      echo "Replaced '$github' by '$gitlab'"
    end
  end
end
