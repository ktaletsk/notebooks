# For Streamlit:

from __future__ import absolute_import, division, print_function
import random
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import streamlit as st
import tensorflow as tf
from PIL import Image
from tensorflow import keras
from keras import Model, layers
from keras.datasets import mnist
import io


# Below is markdown for Streamlit.
st.title('Neural Network Example')

st.subheader('Neural Network Example Using Streamlit Framework')

st.image(Image.open('pict/neural_network_overview.jfif'), caption='', width=400)

st.markdown(
    """
    The object was to build a 2-hidden layers fully connected neural network (a.k.a multilayer perceptron) with TensorFlow.

    This example is using a low-level approach to better understand all mechanics behind building neural networks and the training process.

    You can find example used in Jupyter Notebooks here:
    https://github.com/aymericdamien/TensorFlow-Examples/blob/master/tensorflow_v2/notebooks/3_NeuralNetworks/neural_network.ipynb

    This example is using MNIST handwritten digits (picture below). The dataset contains 60,000 examples for training and 10,000 examples for testing. The digits have been size-normalized and centered in a fixed-size image (28x28 pixels) with values from 0 to 255.

    In this example, each image will be converted to float32, normalized to [0, 1] and flattened to a 1-D array of 784 features (28*28).

    """, unsafe_allow_html=True)

st.image(Image.open('pict/mnist_dataset_overview.png'), caption='')

# MNIST dataset parameters.
num_classes = 10  # total classes (0-9 digits).
num_features = 784  # data features (img shape: 28*28).

# Initial Training parameters.
learning_rate = 0.1
training_steps = 2000
batch_size = 256
display_step = 100

# Form Streamlit Input

st.markdown(
    """
Default training parameters:

**Learning Rate** = 0.1

**Training Steps** = 2000

**Batch Size** = 256

**Display Step** = 100
    """
)

with st.form("initial_params"):
    st.markdown("**Change default parameters**")
    training_steps = st.number_input(
        label='Training steps: ', value=training_steps, step=50)
    display_step = st.number_input(
        label="Display step: ", value=display_step, step=50)
    learning_rate = st.number_input(
        label='learning rate: ', value=learning_rate, step=.1)
    batch_size = st.number_input(
        label="batch size: ", value=batch_size)

    # Every form must have a submit button.
    submitted = st.form_submit_button("Apply")
    if not submitted:
        st.stop()


# Below is markdown for Streamlit.
st.markdown(
    """

MNIST default dataset parameters.

**Number of classes** = 10 (total classes 0-9 digits).

**Number of features** = 784  (data features).

    """
)


# Network parameters.
n_hidden_1 = 128  # 1st layer number of neurons.
n_hidden_2 = 256  # 2nd layer number of neurons.

# Prepare MNIST data.
(x_train, y_train), (x_test, y_test) = mnist.load_data()
# Convert to float32.
x_train, x_test = np.array(x_train, np.float32), np.array(x_test, np.float32)
# Flatten images to 1-D vector of 784 features (28*28).
x_train, x_test = x_train.reshape(
    [-1, num_features]), x_test.reshape([-1, num_features])
# Normalize images value from [0, 255] to [0, 1].
x_train, x_test = x_train / 255., x_test / 255.
# Use tf.data API to shuffle and batch data.
train_data = tf.data.Dataset.from_tensor_slices((x_train, y_train))
train_data = train_data.repeat().shuffle(5000).batch(batch_size).prefetch(1)


# Create TF Model.
# NeuralNet class is based on Keras Model class
class NeuralNet(Model):
    # Set layers.
    def __init__(self):
        super(NeuralNet, self).__init__()
        # First fully-connected hidden layer.
        self.fc1 = layers.Dense(n_hidden_1, activation=tf.nn.relu)
        # First fully-connected hidden layer.
        self.fc2 = layers.Dense(n_hidden_2, activation=tf.nn.relu)
        # Second fully-connecter hidden layer.
        self.out = layers.Dense(num_classes)

    # Set forward pass.
    def call(self, x, is_training=False):
        x = self.fc1(x)
        x = self.fc2(x)
        x = self.out(x)
        if not is_training:
            # tf cross entropy expect logits without softmax, so only
            # apply softmax when not training.
            x = tf.nn.softmax(x)
        return x


# Build neural network model.
neural_net = NeuralNet()
# Cross-Entropy Loss.
# Note that this will apply 'softmax' to the logits.


def cross_entropy_loss(x, y):
    # Convert labels to int 64 for tf cross-entropy function.
    y = tf.cast(y, tf.int64)
    # Apply softmax to logits and compute cross-entropy.
    loss = tf.nn.sparse_softmax_cross_entropy_with_logits(labels=y, logits=x)
    # Average loss across the batch.
    return tf.reduce_mean(loss)

# Accuracy metric.


def accuracy(y_pred, y_true):
    # Predicted class is the index of highest score in prediction vector (i.e. argmax).
    correct_prediction = tf.equal(
        tf.argmax(y_pred, 1), tf.cast(y_true, tf.int64))
    return tf.reduce_mean(tf.cast(correct_prediction, tf.float32), axis=-1)


# Stochastic gradient descent optimizer.
optimizer = tf.optimizers.SGD(learning_rate)
# Optimization process.


def run_optimization(x, y):
    # Wrap computation inside a GradientTape for automatic differentiation.
    with tf.GradientTape() as g:
        # Forward pass.
        pred = neural_net(x, is_training=True)
        # Compute loss.
        loss = cross_entropy_loss(pred, y)

    # Variables to update, i.e. trainable variables.
    trainable_variables = neural_net.trainable_variables

    # Compute gradients.
    gradients = g.gradient(loss, trainable_variables)

    # Update W and b following gradients.
    optimizer.apply_gradients(zip(gradients, trainable_variables))


# Run training for the given number of steps.
st.markdown(
    """

    **_The results below are for the training that was ran for the given number of steps._**

    """, unsafe_allow_html=True)


@st.experimental_singleton
def train_model(training_steps, display_step, learning_rate, batch_size):
    step_list = []
    loss_list = []
    acc_list = []

    for step, (batch_x, batch_y) in enumerate(train_data.take(training_steps), 1):
        # Run the optimization to update W and b values.
        run_optimization(batch_x, batch_y)

        if step % display_step == 0:
            pred = neural_net(batch_x, is_training=True)
            loss = cross_entropy_loss(pred, batch_y)
            acc = accuracy(pred, batch_y)

            step_list.append(step)
            loss_list.append(loss)
            acc_list.append(acc)
    return step_list, loss_list, acc_list, neural_net


step_list, loss_list, acc_list, neural_net = train_model(
    training_steps, display_step, learning_rate, batch_size)

df = pd.DataFrame(
    data={"Step": step_list, "Loss": loss_list, "Accuracy": acc_list}
)

# CSS to inject contained in a string to hide index (first column) in Streamlit app.
hide_table_row_index = """
            <style>
            thead tr th:first-child {display:none}
            tbody th {display:none}
            </style>
            """

# Inject CSS with Markdown (in Streamlit)
st.markdown(hide_table_row_index, unsafe_allow_html=True)

st.table(df)

# Test model on validation set.
pred = neural_net(x_test, is_training=False)

# Below is markdown for Streamlit.
st.markdown(
    """
    Test model on validation set.

    **_Test Accuracy:_**

    """, unsafe_allow_html=True)

st.write("Test Accuracy: %f" % accuracy(pred, y_test))

# Visualize predictions.
# Predict and provide 5 random images from data set.
n_images = 5


def shuffle_images():
    st.session_state.test_images = []
    for i in range(n_images):
        rand_index = random.randint(0, len(x_test)-1)
        st.session_state.test_images.append(x_test[rand_index])
    st.session_state.test_images = np.array(st.session_state.test_images)


if (not hasattr(st.session_state, 'test_images')):
    shuffle_images()

predictions = neural_net(st.session_state.test_images)

# Below is markdown for Streamlit.
st.markdown(
    """
       **_Model and image predictions are displayed below._**
    """, unsafe_allow_html=True)

# Display image and model prediction.
for i in range(n_images):
    plt.imshow(np.reshape(
        st.session_state.test_images[i], [28, 28]), cmap='gray')

    with io.BytesIO() as img_buf:
        plt.savefig(img_buf, format='png')
        st.image(img_buf, width=200)

    st.write("Model prediction: %i" % np.argmax(predictions.numpy()[i]))


st.markdown(
    """
   
   ***If you want to reshuffle images, click the button below.***

    """
)

# Button Widget in Streamlit
st.button("Shuffle Images", on_click=shuffle_images)
