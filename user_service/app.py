from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/users', methods=['GET'])
def get_users():
    return jsonify({"users": ["Rohan", "Sohan", "Mohan"]})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

