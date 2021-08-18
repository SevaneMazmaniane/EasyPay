from flask import Flask, request, jsonify
from flask_pymongo import PyMongo
from bson.objectid import ObjectId
from flask_cors import CORS
import socket

# Configuration
DEBUG = True

# Instantiate the app
app = Flask(__name__)
app.config["MONGO_URI"] = "mongodb://mongo:27017/dev"
app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True
mongo = PyMongo(app)
db = mongo.db

# enable CORS
CORS(app, resources={r'/*': {'origins': '*'}})

# UI message to show which pods the Payment API container is running
@app.route("/")
def index():
    hostname = socket.gethostname()
    return jsonify(
        message="Welcome to the EasyPay app. I am running inside the {} pod!".format(hostname)
    )

@app.route("/payments")
def get_all_payments():
    payments = db.payment.find()
    data = []
    for payment in payments:
        item = {
            "id": str(payment["_id"]),
            "payment": payment["payment"]
        }
        data.append(item)
    return jsonify(
        data=data
    )

# POST Method to collect a user's payment
@app.route("/payments", methods=["POST"])
def collect_payment():
    data = request.get_json(force=True)
    db.payment.insert_one({"payment": data["payment"]})
    return jsonify(
        message="Payment saved successfully to your account!"
    )

# PUT Method to update a user's payment
@app.route("/payments/<id>", methods=["PUT"])
def update_task(id):
    data = request.get_json(force=True)["payment"]
    response = db.payment.update_one({"_id": ObjectId(id)}, {"$set": {"payment": data}})
    if response.matched_count:
        message = "Payment updated successfully!"
    else:
        message = "No Payments were found!"
    return jsonify(
        message=message
    )

# DELETE Method to delete a user's payment
@app.route("/payments/<id>", methods=["DELETE"])
def delete_task(id):
    response = db.payment.delete_one({"_id": ObjectId(id)})
    if response.deleted_count:
        message = "Payment deleted successfully!"
    else:
        message = "No Payments were found!"
    return jsonify(
        message=message
    )

# The app server will be able to run locally at port 5000
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)