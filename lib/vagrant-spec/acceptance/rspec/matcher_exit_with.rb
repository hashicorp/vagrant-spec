# This verifies that the given subprocess command exits with the right code.
RSpec::Matchers.define :exit_with do |code|
  match do |actual|
    actual.exit_code == code
  end

  failure_message do |actual|
    "expected command to exit with #{code} but got exit code: #{actual.exit_code}\n\n" +
      "stdout: #{actual.stdout}\n\n" +
      "stderr: #{actual.stderr}"
  end
end
