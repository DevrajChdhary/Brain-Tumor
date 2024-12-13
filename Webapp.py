from flask import Flask, render_template, request, jsonify, send_file
from werkzeug.utils import secure_filename
import os
import numpy as np
import cv2
from tensorflow.keras.models import load_model

app = Flask(__name__)
app.secret_key = b'_5#y2L"F4Q8z\n\xec/'

# Define the upload folder and processed image folder
UPLOAD_FOLDER = 'uploads'
PROCESSED_FOLDER = 'processed'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['PROCESSED_FOLDER'] = PROCESSED_FOLDER

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# Load the model
Model = load_model('Model.h5',compile=False)

tumor_class = {
    0: 'glioma',
    1: 'meningioma',
    2: 'notumor',
    3: 'pituitary'
}

def model_predict(img_path, Model):
    img = cv2.imread(img_path)
    img = cv2.resize(img, (224, 224))
    img_array = np.array(img)
    img_array = img_array.reshape(1, 224, 224, 3)
    
    # Predict probabilities for each class
    predictions = Model.predict(img_array)
    
    # Get the index of the predicted class
    predicted_class_index = np.argmax(predictions)
    
    # Get the confidence level (percentage)
    confidence_percentage = np.max(predictions) * 100
    
    return predicted_class_index, confidence_percentage, predictions[0]

@app.route('/')
def index():
    return render_template('APP.html')

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(file_path)

        # Predict the class and confidence level
        predicted_class_index, confidence_percentage, probabilities = model_predict(file_path, Model)
        predicted_class = tumor_class[predicted_class_index]

        # Return the prediction probabilities and class labels
        return jsonify({
            'message': f"Analysis complete. {predicted_class} with {confidence_percentage:.2f}% confidence",
            'probabilities': {
                'glioma': probabilities[0] * 100,
                'meningioma': probabilities[1] * 100,
                'notumor': probabilities[2] * 100,
                'pituitary': probabilities[3] * 100
            }
        })
    else:
        return jsonify({'error': 'Allowed file types are png, jpg, jpeg, gif'}), 400
if __name__ == '__main__':
    app.run(debug=True)