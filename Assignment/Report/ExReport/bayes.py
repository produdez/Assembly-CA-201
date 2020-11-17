import numpy as np
import sys

# equivalent sample size
m = 3

def binarize_attr(row):
    attrs_b = []
    for i in range(n_attrs):
        for zeroone in np.isin(features[i], row[i]):
            attrs_b.append(zeroone)
    return attrs_b

def binarize_label(label):
    return np.isin(labels, label).astype(np.uint8)

def argmax(row):
    return row == np.amax(row)

def find_label(vector):
    return labels[np.where(vector)]

# Load data from csv file
dataset = np.loadtxt(sys.argv[1], delimiter=",", dtype=np.object_)
testset = np.atleast_2d(np.loadtxt(sys.argv[2], delimiter=",", dtype=np.object_))
trainset, label = np.split(dataset, [-1], axis=1)

n_attrs = trainset.shape[1]
labels, label_count = np.unique(label, return_counts=True)

# Find attribute values
features = []
for col in np.transpose(np.concatenate((trainset, testset))):
    features.append(np.unique(col))

# priori estimate for each feature
priori = []
for attr in features:
    for _ in range(len(attr)):
        priori.append(1/len(attr))
priori = np.array(priori)

# Generate zero-one matrix for training set, test set and labels
trainset_b = np.apply_along_axis(binarize_attr, 1, trainset)
testset_b = np.apply_along_axis(binarize_attr, 1, testset)
label_b = np.apply_along_axis(binarize_label, 1, label)

count = np.dot(label_b.T, trainset_b)

# Calculate Bayes probality
prob = (count + m * priori) / (label_count[:,None] + m)
func = np.log(label_count) + testset_b @ np.log(prob.T)
print(func)
predict_b = np.apply_along_axis(argmax, 1, func)

predict = np.apply_along_axis(find_label, 1, predict_b)
print(predict)
