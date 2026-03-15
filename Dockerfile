# 軽量なPythonイメージをベースに使用
FROM python:3.9-slim

# 1. 必要なシステムパッケージ（FFmpeg）のインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. 作業ディレクトリの設定
WORKDIR /app

# 3. 依存ライブラリのインストール
# 先にrequirements.txtをコピーすることでキャッシュを有効化
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4. アプリケーションコードのコピー
COPY . .

# 5. Renderのポート番号に対応
ENV PORT=5000
EXPOSE 5000

# 6. Gunicornでアプリを起動
# --timeout を長めに設定（動画処理に時間がかかる場合があるため）
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:$PORT --timeout 120 app:app"]

