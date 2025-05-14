# これはなに?

このプロジェクトは [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html)（GPLv3）で公開されています。

`ffmpeg`コマンドをローカルで入れずにDockerでラッピングしているだけです。

## ライセンス

本プロジェクトは [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html) のもとで公開されています。  
GPL3は、ソフトウェアの自由な利用・改変・再配布を認めるライセンスです。詳細は上記リンクをご参照ください。

Copying is allowed under the terms of the GPL3 license.

Copyright (C) 2025 SATO Daisuke(densuke)

無保証ですが、PRは受け付けます。

## なんでこんなの作ったの?

macOS上で、

```zsh
% brew install ffmpeg
```

すればいいだけなのですが、たいして使わないのにいろいろ依存関係が入ってしまうのが気になってしまったのです。

```{note}
もちろん使った後に `brew uninstall ffmpeg` すればいい。
```

ですが、Dockerで使えば何かのおりに`docker image prune`で消せるので、試しにラップした次第です。

## 使い方

```zsh
% docker run --rm -v ${PWD}:/app -w /app ghcr.io/densuke/ffmpeg-docker -i INPUT.wav OUTPUT.m4a
```

という具合に、カレントディレクトリをマウントする形で起動し、後は`ffmpeg`コマンドの引数を渡すだけです。
ただしDockerであるが故に **カレントディレクトリ以下しかアクセスしない、させない** 路線で使うべきとなります。

呼び出しが若干面倒なので、ラッパースクリプトを用意しています(`wrapper.sh`)。

```zsh
% make install
```

で `~/bin` にインストールされます。

## 性能面

Dockerであるが故に、ローカルで`ffmpeg`を使うよりは遅くなります。
遅くはなるのですが、Docker上では実測の145倍というところがローカル実行だと165倍という感じのため『これぐらいだったら別にいいか』ということで、あまり気にしないことにしました(ぉぃ)。

```
# 本ラッパーによるDocker上での実行
size=    9477kB time=00:16:47.82 bitrate=  77.0kbits/s speed= 144x  
# ネイティブでのffmpeg実行
size=    9478KiB time=00:16:47.85 bitrate=  77.0kbits/s speed= 165x
```
## 実行環境

- macBook Air 13-inch M4 2025(32GB RAM)
- macOS 15.4.1
- Docker Desktop 4.41.2

## おまけ

- ラッパースクリプトは、イメージが1週間以上古くなっている場合はイメージのプルを行おうとします
- 一応dependabotで週1でのイメージ更新の必要性をチェックするようにしていますが、正直わかりません
- ローカルではactを使ってテストをすることができます
- arm64とamd64の両対応のイメージ構成にしています
  - 地味に苦労しました
  
