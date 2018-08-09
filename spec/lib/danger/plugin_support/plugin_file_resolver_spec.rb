require "lib/danger/plugin_support/plugin_file_resolver"

RSpec.describe Danger::PluginFileResolver do
  describe "#resolve" do
    context "Given list of gems" do
      it "resolves for gems" do
        resolver = described_class.new(["danger", "rails"])

        expect(Danger::GemsResolver).to receive_message_chain(:new, :call)

        resolver.resolve
      end
    end
  end
end
