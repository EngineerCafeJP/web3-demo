# 💎 Demo Token - ERC20 Mint Demo

シンプルな ERC20 トークンのミントデモプロジェクトです。  
Foundry を使用してスマートコントラクトを開発し、HTML フロントエンドからトークンをミントできます。


## 📋 概要

このプロジェクトには以下が含まれています：

- **DemoToken.sol**: 誰でもミント可能なシンプルな ERC20 トークンコントラクト  
- **DeployDemoToken.s.sol**: Forge を使ったデプロイスクリプト  
- **index.html**: トークンをミントするためのフロントエンド

## 🚀 クイックスタート

### 1️⃣ 依存関係のインストール

このプロジェクトは Foundry を使用します。まだインストールしていない場合：

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### 2️⃣ 環境変数の設定

`.env` ファイルを作成して、必要な環境変数を設定します：

```bash
cp env.template .env
```

`.env` ファイルを編集して、以下の値を設定：

**必須の環境変数:**
- `PRIVATE_KEY`: デプロイ用の秘密鍵（0xプレフィックスなし）
- `RPC_URL`: 接続先の RPC URL

**オプションの環境変数:**
- `ETHERSCAN_API_KEY`: コントラクト検証用（`--verify` オプション使用時に必要）

詳細は `env.template` を参照してください。

### 3️⃣ ビルド

```bash
forge build
```

### 4️⃣ ローカル環境でテスト

#### 🧱 Anvil の起動（ローカルノード）

```bash
anvil
```

Anvil が起動すると、テスト用のアカウントと秘密鍵が表示されます。

#### 🚀 デプロイ

**必要な環境変数:**
- `PRIVATE_KEY`: デプロイ用の秘密鍵（必須）
- `RPC_URL`: RPC URL（コマンドラインで指定するため、.env には不要）

**方法1: 環境変数を読み込んでデプロイ**

```bash
source .env
forge script script/DeployDemoToken.s.sol:DeployDemoToken \
  --rpc-url http://127.0.0.1:8545 \
  --broadcast
```

**方法2: 直接指定（Anvil の場合）**

```bash
forge script script/DeployDemoToken.s.sol:DeployDemoToken \
  --rpc-url http://127.0.0.1:8545 \
  --private-key <AnvilのPrivate Key> \
  --broadcast
```

デプロイ後、コントラクトアドレスがコンソールに表示されます。このアドレスをメモしてください。

### 5️⃣ フロントエンドの使用

#### ⚠️ 重要: ローカルサーバーで開く必要があります

MetaMask は `file://` プロトコルでは正しく動作しません。必ず HTTP サーバー経由で開いてください。

**方法1: Python を使用（推奨）**

```bash
# プロジェクトのルートディレクトリで実行
python3 -m http.server 8000
```

ブラウザで [http://localhost:8000](http://localhost:8000) を開く

**方法2: Node.js を使用**

Node.jsがインストールされている場合：

```bash
# http-serverをグローバルインストール（初回のみ）
npm install -g http-server

# サーバーを起動
http-server -p 8000
```

ブラウザで [http://localhost:8000](http://localhost:8000) を開く

**方法3: VS Code Live Server 拡張を使用**

1. VS Code で「Live Server」拡張をインストール  
2. `index.html` を右クリック → 「Open with Live Server」

#### 🦊 MetaMask の設定

1. MetaMask をインストール（まだの場合）  
2. Anvil のネットワーク設定を追加：  
   - ネットワーク名: Anvil  
   - RPC URL: `http://127.0.0.1:8545`  
   - チェーン ID: `31337`  
   - 通貨記号: `ETH`  
3. Anvil のテストアカウントの秘密鍵をインポート  

#### 💰 トークンのミント手順

1. ブラウザで [http://localhost:8000](http://localhost:8000) を開く  
2. デプロイしたコントラクトアドレスを入力  
3. 「ウォレットを接続」ボタンをクリック  
4. MetaMask で接続を承認  
5. ミント数量を入力（デフォルト: 100）  
6. 「トークンをミント」ボタンをクリック  
7. MetaMask でトランザクションを承認  

## 💻 フロントエンドの動作補足

このセクションでは、`index.html` のフロントエンドが **どのUIで何をしているか** を簡単に補足します。  

### 🧭 主要UIのかんたん解説

- **① トークンコントラクトアドレス**  
  対象となるERC20トークンのコントラクトアドレスを入力します（Anvil標準のデプロイ先を既定値に設定）。

- **② ウォレットを接続**  
  MetaMaskと接続して自分のアドレスを取得し、選択したコントラクトで残高を初回取得します。  
  接続後はアドレス・残高・コントラクト要約が表示され、ミント操作が可能になります。

- **③ ミント数量 / トークンをミント**  
  入力した数量を、`decimals` に合わせて内部単位（Wei相当）へ変換し、`mint(address, amount)` を送信します。  
  送信完了後は残高が増えます（他タブや他端末の操作は自動反映されないため、必要に応じて「残高を更新」を押してください）。

### 🔄 「残高を更新」ボタンについて

#### 処理内容

1. **トークン残高の取得**
   ```javascript
   tokenContract.methods.balanceOf(userAddress).call()
   ```
   現在接続中のウォレットアドレスのトークン残高をブロックチェーンから取得。

2. **小数点情報の取得**
   ```javascript
   tokenContract.methods.decimals().call()
   ```
   トークンの `decimals` 値を取得。

3. **残高のフォーマット**
   ```javascript
   const formatted = balance / (10 ** decimals);
   ```
   例：残高 `1000000000000000000` かつ `decimals = 18` → 表示は `1.0 DEMO`

4. **UIの更新**
   ```javascript
   document.getElementById("tokenBalance").textContent = formatted.toLocaleString();
   ```

#### 使用される場面

- ウォレット接続時  
- ミント完了後  
- 「残高を更新」ボタンをクリックした時  

#### 現在の制限

このページにはリアルタイム更新機能がないため、以下のような場合には手動で更新が必要：

- 別ウィンドウや別タブでミントした場合  
- 他デバイス・他ユーザーが同じウォレットでミントした場合  
- 他の DApp でトークンを使用した場合  

#### 改善案（自動更新機能の追加）

1. **定期的な自動更新**
   ```javascript
   setInterval(updateBalance, 30000); // 30秒ごとに更新
   ```
2. **イベント監視**
   - MetaMaskのトランザクション完了イベントを監視  
   - コントラクトの `Transfer` イベントを購読  
3. **リアルタイム通知**
   - プッシュ通知や視覚的な更新インジケータを追加  

### 🧩 FAQ / トラブルシューティング

- `typeof window.ethereum` が `'undefined'` の場合 → HTTP サーバー経由で開いているか確認  
- ネットワークエラーが出る場合 → MetaMask のネットワークが Anvil（Chain ID: 31337）になっているか確認  

#### 🧩 MetaMaskでDEMOトークンが「ETH」と表示される場合（ローカルAnvil環境）

**現象:**  
ローカル環境でデプロイしたトークンを MetaMask にインポートした際、  
シンボルが「ETH」と表示され、残高桁数が異常になることがあります。

**原因:**  
MetaMask がトークン情報（`symbol()` / `decimals()`）を正しく取得できず、  
キャッシュされた古い情報を使用しているためです。  
同一アドレスに再デプロイした場合に特に発生します。

**対処法:**

1. **誤表示トークンを削除（非表示）**  
   - トークン一覧 → 対象トークンをクリック  
   - 右上の「︙」→ **「トークンを非表示」**

2. **再インポート**
   - トップ画面下部「トークンをインポート」→「カスタムトークン」タブ  
   - コントラクトアドレス：
     ```
     0x5FbDB2315678afecb367f032d93F642f64180aa3
     ```
   - `DEMO` / `18` が自動入力されればOK  
   - 「次へ」→「トークンを追加」

3. **（まだ直らない場合）MetaMask キャッシュをリセット**
   - MetaMask → 設定 → 詳細 → **「アカウントをリセット」**

4. **（最終手段）Anvil をリセットして再デプロイ**
   ```bash
   anvil --reset
   forge create --rpc-url http://127.0.0.1:8545 --private-key <key> src/DemoToken.sol:DemoToken
   ```

**確認コマンド例（Foundry）**
```bash
cast call <contract-address> "symbol()(string)"   # → "DEMO"
cast call <contract-address> "decimals()(uint8)"  # → 18
cast call <contract-address> "name()(string)"     # → "Demo Token"
```

**備考:**  
コントラクト自体に問題がなくても、MetaMask の UI キャッシュが誤表示の原因になる場合があります。  
再デプロイやリセットで確実に解消します。

## 📝 コントラクト詳細

### DemoToken

- **名前**: Demo Token  
- **シンボル**: DEMO  
- **初期供給量**: 10,000,000 DEMO（デプロイヤーに付与）

#### 主要な関数

| 関数 | 説明 |
|------|------|
| `mint(address to, uint256 amount)` | 誰でも任意のアドレスにトークンをミント可能（デモ用） |
| `mintByOwner(address to, uint256 amount)` | オーナーのみがミント可能 |

## 🌐 本番環境へのデプロイ

### Sepolia テストネットへのデプロイ例

**必要な環境変数:**
- `PRIVATE_KEY`: デプロイ用の秘密鍵（必須）
- `RPC_URL`: Sepolia RPC URL（必須）
- `ETHERSCAN_API_KEY`: Etherscan API Key（`--verify` 使用時に必須）

**手順:**

1. `.env` ファイルを編集して、以下を設定：
   ```bash
   PRIVATE_KEY=your_private_key_without_0x
   RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_KEY
   ETHERSCAN_API_KEY=your_etherscan_api_key
   ```
2. 環境変数を読み込み：
   ```bash
   source .env
   ```
3. デプロイ（検証なし）：
   ```bash
   forge script script/DeployDemoToken.s.sol:DeployDemoToken \
     --rpc-url $RPC_URL \
     --broadcast
   ```
4. デプロイ + Etherscan 検証：
   ```bash
   forge script script/DeployDemoToken.s.sol:DeployDemoToken \
     --rpc-url $RPC_URL \
     --broadcast \
     --verify \
     --etherscan-api-key $ETHERSCAN_API_KEY
   ```

**注意:** `--verify` オプションを使用する場合、`ETHERSCAN_API_KEY` が必須です。

## 🔐 環境変数リファレンス

| 環境変数 | 必須/オプション | 説明 | 使用コマンド |
|----------|----------------|------|--------------|
| `PRIVATE_KEY` | **必須** | デプロイ用の秘密鍵（0xプレフィックスなし） | すべてのデプロイコマンド |
| `RPC_URL` | **必須** | 接続先の RPC URL | すべてのデプロイコマンド |
| `ETHERSCAN_API_KEY` | オプション | Etherscan API Key（検証用） | `--verify` オプション使用時 |
| `CHAIN_ID` | オプション | チェーンID | 明示的に指定する場合のみ |


### RPC URL の例

| ネットワーク | RPC URL |
|--------------|---------|
| Anvil (ローカル) | `http://127.0.0.1:8545` |
| Sepolia | `https://sepolia.infura.io/v3/YOUR_PROJECT_ID` |
| Sepolia (Alchemy) | `https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY` |
| Mainnet | `https://mainnet.infura.io/v3/YOUR_PROJECT_ID` |

### チェーン ID

| ネットワーク | Chain ID |
|--------------|----------|
| Anvil (ローカル) | 31337 |
| Sepolia | 11155111 |
| Ethereum Mainnet | 1 |


## 🛠️ 開発コマンド

### テスト

```bash
forge test
```

### フォーマット

```bash
forge fmt
```

### ガススナップショット

```bash
forge snapshot
```


## 📚 使用技術

- 🧪 **Foundry** — スマートコントラクト開発フレームワーク  
- 🛡️ **OpenZeppelin** — セキュアな ERC20 実装  
- 🌐 **web3.js** — フロントエンドからのブロックチェーン操作  
- 🦊 **MetaMask** — ウォレット接続  


## ⚠️ 注意事項

- このプロジェクトは学習・デモ目的です  
- `mint` 関数は誰でも呼び出せるため、本番環境では使用しないでください  
- 本番運用時は必ずアクセス制御を実装してください  


## 📄 ライセンス

MIT