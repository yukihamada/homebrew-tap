cask "nou" do
  version "2.3.1"

  url "https://github.com/yukihamada/NOU/releases/download/v#{version}/NOU-Installer.dmg"
  name "NOU"
  desc "Private AI — local LLM proxy running in your menu bar"
  homepage "https://nou.link"

  sha256 "6e41d0c1b17c017e7e83bddc0d25283cf1325b7138e7f9be1ca5de3bae5720aa"

  app "NOU.app"

  zap trash: [
    "~/Library/Preferences/com.enablerdao.nou.plist",
    "~/Library/Logs/NOU",
    "~/.nou",
  ]
end
