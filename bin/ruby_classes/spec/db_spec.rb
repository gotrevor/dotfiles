require "spec_helper"

describe 'DB' do
  subject { DB.new }

  context "#psql_for_db" do
    it "can parse" do
#      expect_any_instance_of(Object).to receive(:puts).with("storage redshift staging")
      parsed = subject.psql_for_db("cpt")
      expect(parsed).to eq({
        app: "compute",
        type: "pg",
        env: "test"
      })
    end
  end
end
