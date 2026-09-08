# Homebrew formula for Sente (teai.io CLI)
#
# 二段構え(tasks/sente-gaps/06-distribution.md):
#   ① Sente バイナリ(yukihamada/opencode fork)を brew で配置
#   ② 設定注入(teai.io /te/config 取得 + APIキー)は初回 `te` 起動時の
#      自己初期化に任せる — brew install 時にネットワークアクセスしない。
#
# url は必ずタグ固定(releases/download/<tag>/...)。latest は sha256 と相性が悪い。
# 🔄 自動更新: .github/workflows/release.yml の homebrew-tap ジョブが、
#   リリースの SHA256SUMS.txt から各アーキの sha256 を抽出してこのファイルの
#   version/url/sha256 を機械置換し homebrew-tap へ push する(HOMEBREW_TAP_TOKEN)。

class TeaiCli < Formula
  desc "Sente (先手) — teai.io's coding agent CLI"
  homepage "https://teai.io"
  version "0.0.0-headless-model-fallback-202609071115"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/yukihamada/opencode/releases/download/sente-0.0.0-headless-model-fallback-202609071115/sente-darwin-arm64.tar.gz"
      sha256 "0a30f02d2899ac4514f310b1a6d7d4e0341e3214f7d03ee2933a0bc69055452f"
    else
      url "https://github.com/yukihamada/opencode/releases/download/sente-0.0.0-headless-model-fallback-202609071115/sente-darwin-x64.tar.gz"
      sha256 "04db857ffc97351aace5c10315195d2d1832d567cdb9e1000fe585a27e1d93d9"
    end
  end
  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/yukihamada/opencode/releases/download/sente-0.0.0-headless-model-fallback-202609071115/sente-linux-arm64.tar.gz"
      sha256 "54510dcb4cc178268ec6add88832996acb0f93f86fdefd839ad17f69641fa576"
    else
      url "https://github.com/yukihamada/opencode/releases/download/sente-0.0.0-headless-model-fallback-202609071115/sente-linux-x64.tar.gz"
      sha256 "b91b4cff0a7e24b25614064a21efa739119d205c71c3703aa6564f119d49dc04"
    end
  end

  def install
    # 実体は Sente(yukihamada/opencode fork)。sst/tap/opencode との衝突を避ける
    # ためバイナリは libexec に置き、公開コマンドは `te` ランチャーのみ。
    libexec.install "sente" => "sente-bin"
    (bin/"te").write te_launcher_script
    (bin/"te").chmod 0755
  end

  def te_launcher_script
    <<~EOS
      #!/bin/sh
      # te = Sente を teai.io 設定で起動する薄いランチャー(brew 版)。
      # 設定は初回起動時に自己初期化: ~/.config/teai/opencode.json が無ければ
      # #{homepage}/te/config から取得する(brew install 時には触らない)。
      set -eu
      CONFIG_DIR="$HOME/.config/teai"
      mkdir -p "$CONFIG_DIR" && chmod 700 "$CONFIG_DIR" 2>/dev/null || true
      if [ ! -f "$CONFIG_DIR/opencode.json" ]; then
        curl -fsSL -m 10 "#{homepage}/te/config" -o "$CONFIG_DIR/opencode.json.tmp" 2>/dev/null \\
          && grep -q '"provider"' "$CONFIG_DIR/opencode.json.tmp" \\
          && mv "$CONFIG_DIR/opencode.json.tmp" "$CONFIG_DIR/opencode.json" \\
          || { echo "✗ teai.io 設定の取得に失敗。ネットワークを確認して再実行してください" >&2; rm -f "$CONFIG_DIR/opencode.json.tmp"; exit 1; }
      fi
      OPENCODE_CONFIG="${OPENCODE_CONFIG:-$CONFIG_DIR/opencode.json}"
      export OPENCODE_CONFIG
      exec "#{opt_libexec}/sente-bin" "$@"
    EOS
  end

  def caveats
    <<~EOS
      次の一歩:
        te register   # メールだけで新規登録(ブラウザ不要)
        te login      # 既にAPIキーがある場合
      注: curl 版(te-install.sh)で入れた ~/.local/bin/te と二重管理になる
      場合は PATH の先にある方が使われます。
    EOS
  end

  test do
    assert_predicate bin/"te", :executable?
  end
end
