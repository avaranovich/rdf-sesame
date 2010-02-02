require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Sesame::Server do
  before :each do
    @url    = RDF::URI.new(ENV['SESAME_URL'] || "http://localhost:8080/openrdf-sesame")
    @server = RDF::Sesame::Server.new(@url)
  end

  it "should support URL construction" do
    @server.should respond_to(:url, :uri)
    @server.url.should be_instance_of(RDF::URI)
    @server.url.to_s.should == @url.to_s
    @server.url(:protocol).to_s.should == "#{@url}/protocol"
    @server.url('repositories/SYSTEM').to_s.should == "#{@url}/repositories/SYSTEM"
  end

  it "should return the Sesame connection" do
    @server.connection.should_not be_nil
    @server.connection.should be_instance_of(RDF::Sesame::Connection)
  end

  it "should return the protocol version" do
    @server.should respond_to(:protocol, :protocol_version)
    @server.protocol.should be_a_kind_of(Numeric)
    @server.protocol.should >= 4
  end

  it "should return available repositories" do
    @server.should respond_to(:repositories)
    @server.repositories.should be_a_kind_of(Enumerable)
    @server.repositories.should be_instance_of(Hash)
    @server.repositories.each do |identifier, repository|
      identifier.should be_instance_of(String)
      repository.should be_instance_of(RDF::Sesame::Repository)
    end
  end

  it "should indicate whether a repository exists" do
    @server.should respond_to(:has_repository?)
    @server.has_repository?(:SYSTEM).should be_true
    @server.has_repository?(:foobar).should be_false
  end

  it "should return existing repositories" do
    @server.should respond_to(:repository, :[])
    repository = @server.repository(:SYSTEM)
    repository.should_not be_nil
    repository.should be_instance_of(RDF::Sesame::Repository)
  end

  it "should not return nonexistent repositories" do
    lambda { @server.repository(:foobar) }.should_not raise_error
    repository = @server.repository(:foobar)
    repository.should be_nil
  end

  it "should support enumerating repositories" do
    @server.should respond_to(:each_repository, :each)
    @server.each_repository.should be_a_kind_of(Enumerable::Enumerator)
    @server.each_repository do |repository|
      repository.should be_instance_of(RDF::Sesame::Repository)
    end
  end
end
