require "mina/svn/rsync/version"

set_default :repository, "."
set_default :rsync_options, []
set_default :rsync_copy, "rsync --archive --acls --xattrs"
set_default :svn_username, settings.user

# Stage is used on your local machine for rsyncing from.
set_default :rsync_stage, "tmp/deploy"

# Cache is used on the server to copy files to from to the release directory.
# Saves you rsyncing your whole app folder each time.
set_default :rsync_cache, "shared/deploy"

run = lambda do |*cmd|
  cmd = cmd[0] if cmd[0].is_a?(Array)
  print_command cmd.join(" ") if simulate_mode? || verbose_mode?
  Kernel.system *cmd unless simulate_mode?
end

rsync_cache = lambda do
  cache = settings.rsync_cache
  raise TypeError, "Please set rsync_cache." unless cache
  cache = settings.deploy_to + "/" + cache if cache && cache !~ /^\//
  cache
end

desc "Stage and rsync to the server (or its cache)."
task :rsync => %w[rsync:stage] do
  print_status "Rsyncing to #{rsync_cache.call}..."

  rsync = %w[rsync]
  rsync.concat settings.rsync_options
  rsync << settings.rsync_stage + "/"

  user = settings.user + "@" if settings.user
  host = settings.domain
  rsync << "#{user}#{host}:#{rsync_cache.call}"

  run.call rsync
end

namespace :rsync do
  task :create_stage do
    next if File.directory?(settings.rsync_stage)
    print_status "Cloning repository for the first time..."

    clone = %w[svn co]
    clone << settings.repository
    clone << settings.rsync_stage
    clone << settings.svn_username
    run.call clone
  end

  desc "Stage the repository in a local directory."
  task :stage => %w[create_stage] do
  end

  task :build do
    queue %(echo "-> Copying from cache directory to build path")
    queue! %(#{settings.rsync_copy} "#{rsync_cache.call}/" ".")
  end

  desc "Stage, rsync and copy to the build path."
  task :deploy => %w[rsync build]
e
