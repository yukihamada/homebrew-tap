cask "nou" do
  version "2.3.1"

  url "https://github.com/yukihamada/NOU/releases/download/v#{version}/NOU-Installer.dmg"
  name "NOU"
  desc "Private AI — local LLM proxy running in your menu bar"
  homepage "https://nou.link"

  sha256 "036ed8ec3a618ce8b7afc521a617d2cbc589a7d35ae38af715952533eaf516aa"

  app "NOU.app"

  zap trash: [
    "~/Library/Preferences/com.enablerdao.nou.plist",
    "~/Library/Logs/NOU",
    "~/.nou",
  ]
end
