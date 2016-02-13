puts $_.split(/[,\s]+/)[1..-1].reject { 
  |host| host.match(/\*|\?/)
} if $_.match(/^\s*Host\s+/);
