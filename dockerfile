FROM python:3.10

# Configure Poetry
ENV POETRY_VERSION=1.5.1
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VENV=/opt/poetry-venv
ENV POETRY_CACHE_DIR=/opt/.cache

# Install poetry separated from system interpreter
RUN python3 -m venv $POETRY_VENV \
    && $POETRY_VENV/bin/pip install -U pip setuptools \
    && $POETRY_VENV/bin/pip install poetry==${POETRY_VERSION}

# Add `poetry` to PATH
ENV PATH="${PATH}:${POETRY_VENV}/bin"

WORKDIR /app

# Install dependencies
COPY pyproject.toml .
RUN poetry install

RUN apt-get update
RUN apt-get install libleptonica-dev tesseract-ocr libtesseract-dev python3-pil tesseract-ocr-eng tesseract-ocr-script-latn --yes

EXPOSE 8000

# Run your app
COPY . .

RUN mkdir /files

CMD [ "poetry", "run", "python", "app/main.py" ]