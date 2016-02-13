#!/usr/bin/env ruby
require 'awesome_print'
require 'ruby-debug'

#this fails badly, cause binding's all wrong.
def ap2_fail(x) 
 Binding.of_caller do | b |
  y = b.eval x
  y_ap = y.ai
  puts "#{x}=#{y_ap}"
  y
 end
end

#lambda works fine
ap2_lambda = lambda do | x | 
  y = eval x
  y_ap = y.ai
  puts "#{x}=#{y_ap}"
  y
end

#so does proc.
ap2_proc = Proc.new do | x |
  y = eval x
  y_ap = y.ai
  puts "#{x}=#{y_ap}"
  y
end

ap2 = ap2_proc


def commits_away_from_origin_master (target_branch)
  `git log --no-merges --pretty=%H origin/master..#{target_branch}`.split("\n")
end

#rem_goog = commits_away_from_origin_master("remove-google-analytics-and-fiksu-sdk-events-support-53894355")
#mig_cur =  commits_away_from_origin_master("migrate-current-custom-system-to-cancan-57800178");
ref_att =  commits_away_from_origin_master("refactor-attribute-level-authorization-58560422");
old_stuff = commits_away_from_origin_master("old_merged_stuff");
what_i_want =
   ref_att - old_stuff

#what_i_need =
#  what_i_want - mig_cur

print "git cherry-pick " + what_i_want.reverse.join(" ")

=begin
what_i_want.each do | sha |
  the_commit = `git log -1 --pretty="%H # %s" #{sha}`
  puts the_commit
  do_the_merge=false
  if do_the_merge
    merge_line = "git show #{sha}" #"git merge #{sha}"
    puts merge_line
    merge_msg = `#{merge_line}`
    print merge_msg
  end
end
=end

if false #print counts
ap2.("rem_goog.count")
ap2.("mig_cur.count")
ap2.("ref_att.count")
ap2.("what_i_want.count")
ap2.("what_i_need.count")
end
