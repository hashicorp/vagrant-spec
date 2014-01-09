describe "vagrant CLI: box", component: "cli/box" do
  include_context "acceptance"

  let(:empty_box) do
    Vagrant::Spec.source_root.join(
      "acceptance", "support-boxes", "empty.box")
  end

  it "has no boxes by default" do
    result = execute("vagrant", "box", "list")
    expect(result).to exit_with(0)
    expect(result.stdout).to match_output(:box_list_no_boxes)
  end

  context "basic adding" do
    it "can add a box" do
      assert_execute("vagrant", "box", "add", "foo", empty_box.to_s)

      result = execute("vagrant", "box", "list")
      expect(result).to exit_with(0)
      expect(result.stdout).to match_output(:box_list_box, "foo")
    end

    it "can't add a box that exists" do
      assert_execute("vagrant", "box", "add", "foo", empty_box.to_s)
      result = execute("vagrant", "box", "add", "foo", empty_box.to_s)
      expect(result).to exit_with(1)
    end

    it "can force add a box that exists" do
      assert_execute("vagrant", "box", "add", "foo", empty_box.to_s)
      result = execute("vagrant", "box", "add", "--force", "foo", empty_box.to_s)
      expect(result).to exit_with(0)
      expect(result.stdout).to match_output(:box_list_added, "foo")
    end
  end

  context "adding with a --provider flag" do
    it "can add with the --provider flag" do
      assert_execute("vagrant", "box", "add",
        "foo", empty_box.to_s, "--provider", "empty_provider")

      result = execute("vagrant", "box", "list")
      expect(result).to exit_with(0)
      expect(result.stdout).to match_output(:box_list_box, "foo")
    end

    it "can force add a box that exists with the --provider flag" do
      assert_execute("vagrant", "box", "add", "foo", empty_box.to_s)
      result = execute("vagrant", "box", "add", "--force",
          "--provider", "empty_provider", "foo", empty_box.to_s)
      expect(result).to exit_with(0)
      expect(result.stdout).to match_output(:box_list_added, "foo")
    end

    it "fails to add a box if the provider given doesn't match" do
      result = execute("vagrant", "box", "add",
                       "foo", empty_box.to_s, "--provider", "wrong")
      expect(result).to exit_with(1)
      expect(result.stderr).to match_output(:box_add_wrong_provider)
    end
  end
end
