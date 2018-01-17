describe "vagrant CLI: box", component: "cli/box" do
  include_context "acceptance"

  let(:support_path) { Vagrant::Spec.source_root.join("acceptance", "support-boxes") }
  let(:empty_box)    { support_path.join("empty.box") }

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

  context "adding with metadata" do
    it "can add a box" do
      tf = Tempfile.new(["vagrant", ".json"]).tap do |f|
        f.write(<<-RAW)
        {
          "name": "foo/bar",
          "versions": [
            {
              "version": "0.5",
              "providers": [
                {
                  "name": "empty_provider",
                  "url":  "#{empty_box}"
                }
              ]
            },
            {
              "version": "0.7",
              "providers": [
                {
                  "name": "empty_provider",
                  "url":  "#{empty_box}"
                }
              ]
            }
          ]
        }
        RAW
        f.close
      end

      md_path = Pathname.new(tf.path)
      with_web_server(md_path) do |port|
        url = "http://127.0.0.1:#{port}/#{md_path.basename}"
        result = execute("vagrant", "box", "add", url)
        expect(result).to exit_with(0)
        expect(result.stdout).to match_output(
          :box_added_detailed, "foo/bar", "0.7", "empty_provider")
      end
    end
  end

  context "outdated --global" do
    let(:box_name) { "foo/bar" }
    let(:md_tmpfile) { Tempfile.new(["vagrant", ".json"]).tap(&:close) }
    let(:md_path)  { Pathname.new(md_tmpfile.path) }
    let(:port) { 3838 }

    around(:each) do |example|
      md_path.open("w") do |f|
        f.write(<<-RAW)
        {
          "name": "#{box_name}",
          "versions": [
            {
              "version": "0.5",
              "providers": [
                {
                  "name": "empty_provider",
                  "url":  "#{empty_box}"
                }
              ]
            },
            {
              "version": "0.7",
              "providers": [
                {
                  "name": "empty_provider",
                  "url":  "#{empty_box}"
                }
              ]
            }
          ]
        }
        RAW
      end

      with_web_server(md_path, port: port) do |_|
        url = "http://127.0.0.1:#{port}/#{md_path.basename}"
        assert_execute("vagrant", "box", "add", url)
        example.run
      end
    end

    it "should have no outdated if there aren't any" do
      result = execute("vagrant", "box", "outdated", "--global")
      expect(result).to exit_with(0)
      expect(result.stdout).to match_output(:box_outdated_current, box_name)
    end

    # GH-4618
    it "should have no outdated if we have the latest with multiple versions" do
      # Add the older version too
      url = "http://127.0.0.1:#{port}/#{md_path.basename}"
      assert_execute("vagrant", "box", "add", "--box-version", "= 0.5", url)

      # No outdated
      result = execute("vagrant", "box", "outdated", "--global")
      expect(result).to exit_with(0)
      expect(result.stdout).to match_output(:box_outdated_current, box_name)
    end

    it "should have outdated if there are some" do
      md_path.open("w") do |f|
        f.write(<<-RAW)
        {
          "name": "#{box_name}",
          "versions": [
            {
              "version": "0.5",
              "providers": [
                {
                  "name": "empty_provider",
                  "url":  "#{empty_box}"
                }
              ]
            },
            {
              "version": "0.9",
              "providers": [
                {
                  "name": "empty_provider",
                  "url":  "#{empty_box}"
                }
              ]
            }
          ]
        }
        RAW
      end

      result = execute("vagrant", "box", "outdated", "--global")
      expect(result).to exit_with(0)
      expect(result.stdout).to match_output(:box_outdated, "foo/bar", "empty_provider", "0.7", "0.9")
    end
  end
end
