envs:
	conda env create --prefix envs/unsupervised-learning-trick

.PHONY: data
data: data/raw data/processed

.PHONY: data/processed
data/processed: data/processed/train-images-idx3-ubyte \
	data/processed/train-labels-idx1-ubyte \
	data/processed/t10k-images-idx3-ubyte \
	data/processed/t10k-labels-idx1-ubyte

.PHONY: data/raw
data/raw: data/raw/train-images-idx3-ubyte.gz \
	data/raw/train-labels-idx1-ubyte.gz \
	data/raw/t10k-images-idx3-ubyte.gz \
	data/raw/t10k-labels-idx1-ubyte.gz

data/processed/%: data/raw/%.gz
	gunzip -c $< > $@

data/raw/%:
	wget http://yann.lecun.com/exdb/mnist/$* -P data/raw/
