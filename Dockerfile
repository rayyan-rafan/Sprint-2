FROM python:3.10

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY requirements.txt /app/
RUN pip install --upgrade pip && \
    pip install -r /app/requirements.txt

RUN mkdir -p /app
WORKDIR /app/blog_project

COPY . /app/

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "blog_project.wsgi:application"]
