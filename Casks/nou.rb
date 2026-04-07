cask "nou" do
  version "2.3.0"

  url "https://github.com/yukihamada/NOU/releases/download/v#{version}/NOU-Installer.dmg"
  name "NOU"
  desc "Private AI — local LLM proxy running in your menu bar"
  homepage "https://nou.link"

  sha256 :no_check

  app "NOU.app"

  zap trash: [
    "~/Library/Preferences/com.enablerdao.nou.plist",
    "~/Library/Logs/NOU",
    "~/.nou",
  ]
end
