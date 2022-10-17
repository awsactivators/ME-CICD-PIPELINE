from flask import Flask, jsonify, request

app = Flask(__name__)


@app.route('/hello', methods=['GET'])
def helloworld():
    if (request.method == 'GET'):
        data = {"blog": "Hello World", "url": "https://www.macro-eyes.com", "Author": "Amaka Genevieve Jane Awa"}
        return jsonify(data)


if __name__ == '__main__':
    app.run(debug=True)