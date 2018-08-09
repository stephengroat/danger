# coding: utf-8

require "danger/request_sources/vsts"

RSpec.describe Danger::RequestSources::VSTS, host: :vsts do
  let(:env) { stub_env }
  let(:vstssg) { Danger::RequestSources::VSTS.new(stub_ci, env) }

  describe "#new" do
    it "does not raise uninitialized constant error" do
      expect { described_class.new(stub_ci, env) }.not_to raise_error
    end
  end

  describe "#host" do
    it "sets the host specified by `DANGER_VSTS_HOST`" do
      expect(vstssg.host).to eq("https://example.visualstudio.com/example")
    end
  end

  describe "#validates_as_api_source" do
    it "validates_as_api_source for non empty `DANGER_VSTS_API_TOKEN`" do
      expect(vstssg.validates_as_api_source?).to be true
    end
  end

  describe "#pr_json" do
    before do
      stub_pull_request
      vstssg.fetch_details
    end

    it "has a non empty pr_json after `fetch_details`" do
      expect(vstssg.pr_json).to be_truthy
    end

    describe "#pr_json[:pullRequestId]" do
      it "has fetched the same pull request id as ci_sources's `pull_request_id`" do
        expect(vstssg.pr_json[:pullRequestId]).to eq(1)
      end
    end

    describe "#pr_json[:title]" do
      it "has fetched the pull requests title" do
        expect(vstssg.pr_json[:title]).to eq("This is a danger test")
      end
    end
  end

  describe "#no_danger_comments" do
    before do
      stub_get_comments_request_no_danger
    end

    it "has to post a new comment" do
      allow(vstssg).to receive(:post_new_comment)
      expect(vstssg).to receive(:post_new_comment)
      vstssg.update_pull_request!(warnings: [], errors: [], messages: [], markdowns: [], danger_id: "danger", new_comment: false)
    end
  end

  describe "#danger_comment_update" do
    before do
      stub_get_comments_request_with_danger
    end

    it "has to update the previous comment" do
      allow(vstssg).to receive(:update_old_comment)
      expect(vstssg).to receive(:update_old_comment)
      vstssg.update_pull_request!(warnings: [], errors: [], messages: [], markdowns: [], danger_id: "danger", new_comment: false)
    end
  end
end
