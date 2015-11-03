class DB
  def main
    db_abbr = ARGV[0]
    fail 'missing db_abbr' unless db_abbr
    fail 'db_abbr too short' unless db_abbr.length >= 3
    db_parsed = psql_for_db(db_abbr)


    #    puts psql_args

    do_psql(db_abbr, db_parsed)
  end

#  prod-audience-data-rs.fiksu.com
#  prod-rtb-data-rs.fiksu.com
#  prod-analytics-rs.fiksu.com

  def do_psql(db_abbr, db_parsed)
    hash =
      case db_abbr
      when 'app'
        { host: "prod-audience-data-db-01.cqq6ffee15f2.us-east-1.rds.amazonaws.com", db: "p13n_production" }
      when 'arp'
        { rc: "~/.psqlrc-rs", host: "prod-audience-data-rs.fiksu.com", port: "5439", db: "p13nproduction" }
      when 'arp_su'
        { rc: "~/.psqlrc-rs", pwd: "${SECRET_PGPASSWORD_PERSONALIZATION_PROD}", host: "prod-audience-data-rs.fiksu.com",
          db: "p13nproduction", port: "5439", user: "db_personalization_prod" }
      end

    env_vars = {}
    env_vars[:pgpassword] = hash[:pwd] if hash[:pwd]
    env_vars[:psqlrc] = hash[:rc] if hash[:rc]

    psql_args = ["-h", hash[:host]] +
                (hash[:port] ? ["-p", hash[:port]] : []) +
                ["-d", hash[:db]] +
                ["-U", (hash[:user] ? hash[:user] : ENV["USER"])]

    psql = (hash[:pwd] ? "PGPASSWORD=#{hash[:pwd]} " : "") +
           (hash[:rc] ? "PSQLRC=#{hash[:rc]} " : "") +
           "psql " +
           "-h #{hash[:host]} " +
           (hash[:port] ? "-p #{hash[:port]} " : "") +
           "-d #{hash[:db]} " +
           (hash[:user] ? "-U #{hash[:user]} " : "-U #{ENV["USER"]} ")

    env_vars.each do |k, v|
      ENV[k.to_s.upcase] =
        if (k == :pgpassword) && (db_abbr.end_with?("_su"))
          `. ~/.pgsecrets ; echo #{v}`.chomp
        else
          v
        end
    end
    exec("psql", *psql_args)
  end

=begin
function psqlard {
  PSQLRC=~/.psqlrc-rs psql -h development-rsdb-01.fiksu.com -p 5439 -U ${USER} -d audience_data_${USER}_development "$@"
}
export -f psqlard

function psqlard_su {
  PSQLRC=~/.psqlrc-rs psql -h development-rsdb-01.fiksu.com -p 5439 -U analytics_stage -d audience_data_${USER}_development "$@"
}
export -f psqlard_su

function psqlart {
  PSQLRC=~/.psqlrc-rs psql -h development-rsdb-01.fiksu.com -p 5439 -U ${USER} -d audience_data_${USER}_test "$@"
}
export -f psqlart

function psqlart_su {
  PSQLRC=~/.psqlrc-rs psql -h development-rsdb-01.fiksu.com -p 5439 -U analytics_stage -d audience_data_${USER}_test "$@"
}
export -f psqlart_su

# rtb-compute
alias psqlcrp="PSQLRC=~/.psqlrc-rs psql -h prod-rtb-compute-rs.fiksu.com -d p13nproduction -p 5439"
alias psqlcrp_su="PSQLRC=~/.psqlrc-rs PGPASSWORD=${SECRET_PGPASSWORD_PERSONALIZATION_PROD} psql -h prod-rtb-compute-rs.fiksu.com   -d p13nproduction -p 5439 -U db_personalization_prod"
alias psqlcpp="psql -h prod-rtb-compute-db-01.cqq6ffee15f2.us-east-1.rds.amazonaws.com -d p13n_production"

# ad/rtb staging
alias psqlcrs="PSQLRC=~/.psqlrc-rs psql -h staging-rs.fiksu.com -d p13nstaging -p 5439"
alias psqlars="PSQLRC=~/.psqlrc-rs psql -h staging-rs.fiksu.com -d p13nstaging -p 5439"

alias psqlcrs_su="PSQLRC=~/.psqlrc-rs PGPASSWORD=${SECRET_PGPASSWORD_PERSONALIZATION_STAGING} psql -h staging-rs.fiksu.com -d p13nstaging -p 5439 -U db_personalization_staging"
alias psqlars_su="PSQLRC=~/.psqlrc-rs PGPASSWORD=${SECRET_PGPASSWORD_PERSONALIZATION_STAGING} psql -h staging-rs.fiksu.com -d p13nstaging -p 5439 -U db_personalization_staging"


# tracking
alias psqltr="psql -h prod-trackdb-replica-02.fiksu.com -U postgres -d tracking_production"
alias psqltrs="psql -h localhost -p 15443 -U tmorris -d tracking_staging"
# warehousing staging
alias psqlwhs="psql -h localhost -p 15435 -U tmorris -d warehousing_staging"
alias psqlwhs="psql -h staging-data-api-db-primary-01.fiksu.com -U ${USER} -d warehousing_staging"
alias psqlwhs_su="PGPASSWORD=${SECRET_PGPASSWORD_WAREHOUSING_STAGING} psql -h staging-data-api-db-primary-01.fiksu.com -U db_analytics_staging -d warehousing_staging"
# warehousing production
WAREHOUSING_PRODUCTION_DB=prod-data-api-db-primary.fiksu.com
alias psqlwhp="psql -h ${WAREHOUSING_PRODUCTION_DB} -U ${USER} -d warehousing_production"
alias psqlwhp_su="PGPASSWORD=${SECRET_PGPASSWORD_WAREHOUSING_PRODUTION} psql -h ${WAREHOUSING_PRODUCTION_DB} -U dbadmin -d warehousing_production"
# warehousing development
alias psqlwhd="psql -h localhost -U ${USER} -d warehousing_development"
alias psqlwht="psql -h localhost -U ${USER} -d warehousing_test"
# PG production
alias psqlp="psql -h localhost -p 15440 -U ${USER} -d analytics_production"
alias psqlp_su="PGPASSWORD=${SECRET_PGPASSWORD_WAREHOUSING_PRODUTION} psql -h localhost -p 15440 -U dbadmin -d analytics_production"
# PG local
alias psqld="psql -h localhost -d analytics_development"
alias psqlt="psql -h localhost -d analytics_test"
# Control production
alias psqlcp="psql -h prod-analytics-control-db.fiksu.com -d analytics_control_production"
alias psqlcp_su="PGPASSWORD=${SECRET_PGPASSWORD_CONTROL_PRODUCTION} psql -U db_analytics_prod -h prod-analytics-control-db.fiksu.com -d analytics_control_production"
# RS "per Yml"
alias psqlrsy="$(ruby -rerb -ryaml -e 'y=YAML.load(ERB.new(IO.read("#{Dir.home}/work/aso-data-processor/config/database.yml")).result)["redshift_#{ENV["RAILS_ENV"]||"development"}"]; puts "psql -h #{y["host"]} -p #{y["port"]} -U #{y["username"]} -d #{y["database"]}"')"
# RS test
RS_DEVELOPMENT_DB_HOST=development-rsdb-01.fiksu.com
RS_DEVELOPMENT_DB_HOST=$( ruby -ryaml -e 'puts YAML.load(File.open("#{Dir.home}/work/aso-data-processor/config/database.yml"))["redshift_development"]["host"]' )
alias psqlrst="PSQLRC=~/.psqlrc-rs psql -h ${RS_DEVELOPMENT_DB_HOST} -p 5439 -U ${USER} -d analytics_${USER}_test"
alias psqlrst_su="PSQLRC=~/.psqlrc-rs psql -h ${RS_DEVELOPMENT_DB_HOST} -p 5439 -U analytics_stage -d analytics_${USER}_test"
# RS development
function psqlrsd {
  PSQLRC=~/.psqlrc-rs psql -h development-rsdb-01.fiksu.com -p 5439 -U ${USER} -d analytics_${USER}_development "$@"
}
export -f psqlrsd

function psqlrsd_su {
  PSQLRC=~/.psqlrc-rs psql -h development-rsdb-01.fiksu.com -p 5439 -U analytics_stage -d analytics_${USER}_development "$@"
}
export -f psqlrsd_su

# RS staging
RS_STAGING_DB_HOST=$(ruby -ryaml -e 'puts YAML.load(File.open("#{Dir.home}/work/aso-data-processor/config/database-staging.yml"))["redshift_staging"]["host"]')
alias psqlrss="psql -h $RS_STAGING_DB_HOST -p 5439 -U ${USER} -d analytics_staging"
alias psqlrss_su="psql -h $RS_STAGING_DB_HOST -p 5439 -U analytics_stage -d analytics_staging"

# RS production
RS_PRODUCTION_DB_HOST=prod-analytics-rs.fiksu.com
function psqlrsp {
  PSQLRC=~/.psqlrc-rs psql -h prod-analytics-rs.fiksu.com -p 5439 -U ${USER} -d p13nproduction "$@"
}
export -f psqlrsp

function psqlrsp_su {
  PGPASSWORD=${SECRET_PGPASSWORD_RS_PRODUCTION} PSQLRC=~/.psqlrc-rs psql -h prod-analytics-rs.fiksu.com -p 5439 -d p13nproduction -U p13nadmin "$@"
}
export -f psqlrsp
# RS RTB Compute
alias psqlrsrtbp="psql -h prod-rtb-compute-rsdb-01.ctsyndlntwtd.us-east-1.redshift.amazonaws.com -p 5439 -U ${USER} -d p13nproduction"
alias psqlrsrtbp_su="PGPASSWORD=${SECRET_PGPASSWORD_RS_PRODUCTION} psql -h prod-rtb-compute-rsdb-01.ctsyndlntwtd.us-east-1.redshift.amazonaws.com -p 5439 -U p13nadmin -d p13nproduction"
# local-test
alias psqlss="PGPASSWORD=Tjm--123 psql -h localhost -p 15442 -U tjmadmin -d analytics_staging"
# adobe-hacker
alias psqlrsa_su="PGPASSWORD='A4d0b3h4ck1n6' psql -U adobe_hacker -d adobehacking -h adobe-hacking.ctsyndlntwtd.us-east-1.redshift.amazonaws.com -p 5439"
# warehousing preview
a  end
=end

  def psql_for_db(db_name)
    app =
      case db_name[0]
      when 'a'
        'analytics'
      when 's'
        'storage'
      when 'c'
        'compute'
      when 't'
        'tracking'
      when 'w'
        'warehousing'
      else
        fail "unrecognized app: #{db_name[0]}"
      end

    db_type =
      case db_name[1]
      when 'r'
        'redshift'
      when 'p'
        'pg'
      when 'c'
        'control'
      else
        fail "unrecognized app: #{db_name[1]}"
      end

    env =
      case db_name[2]
      when 'p'
        'production'
      when 's'
        'staging'
      when 'd'
        'development'
      when 't'
        'test'
      when 'r'
        'replica'
      else
        fail "unrecognized env: #{db_name[2]}"
      end

    { app: app,
      type: db_type,
      env: env }
  end
end
