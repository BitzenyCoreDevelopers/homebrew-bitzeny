# homebrew-bitzeny

bitzenyのウォレットや、関連するツールなどが追加されたHomebrewリポジトリです。

## リポジトリの追加の仕方

```bash
$ brew tap BitzenyCoreDevelopers/bitzeny
```

## Formula（パッケージ）のインストール

```bash
$ brew install <Formula名>
```

## リポジトリ内のFormula

### `bitzenyqt`

GUIウォレットであるbitzeny-qtがインストールできます。
一般ユーザー向けです。

### `bitzenyd`

coindであるbitzenydと、bitzeny-cli、bitzeny-txをインストールできます。
またsystemdやplistに対する自動起動などの機能も追加済みです。
通常は、サービスを提供するエンジニア向けです。

