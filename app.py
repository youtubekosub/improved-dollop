import os
from flask import Flask, render_template, request, jsonify, Response
import requests

app = Flask(__name__)

# ffmpeg.wasmのために必須のセキュリティヘッダー
@app.after_request
def add_header(response):
    response.headers['Cross-Origin-Opener-Policy'] = 'same-origin'
    response.headers['Cross-Origin-Embedder-Policy'] = 'require-corp'
    return response

@app.route('/')
def index():
    return render_template('index.html')

# 外部サイトのCORS制限を回避するためのプロキシ
@app.route('/proxy')
def proxy():
    url = request.args.get('url')
    if not url:
        return "URL is required", 400
    
    res = requests.get(url, stream=True)
    return Response(res.iter_content(chunk_size=1024*1024), content_type=res.headers.get('Content-Type'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 5000)))

