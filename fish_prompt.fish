# name: osakana
# cf. https://github.com/oh-my-fish/theme-trout

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _file_count
  ls -1 | wc -l | sed 's/\ //g'
end

function _prompt_dir
  echo (prompt_pwd)
end

function fish_prompt
  # set variables
  set -l last_status $status
  set -l path (_prompt_dir)
  set -l count (_file_count)

  # color
  set -l yellow (set_color yellow)
  set -l red (set_color red)
  set -l green (set_color green)
  set -l blue (set_color blue)
  set -l magenta (set_color magenta)
  set -l normal (set_color normal)

  if [ (rbenv version-name) ]
    set ruby_version (rbenv version-name)
    set ruby_info "$red($ruby_version)$normal"
  end

  if [ (_git_branch_name) ]
    set -l git_branch $magenta(_git_branch_name)
    set git_info "$git_branch"

    if [ (_is_git_dirty) ]
      set git_info "$git_info$yellow*"
    end

    set git_info "$magenta($git_info$magenta)$normal"
  end

  set directory_info "$blue($path ($count))"

  if test $last_status = 0
    set prompt " $green><(((+>$normal "
  else
    set prompt " $redx><(((+>$normal "
  end

  echo -n -s $ruby_info $directory_info $git_info $prompt
end
