FROM python:3.10
RUN pip install django==3.2

COPY python-jenkins-argocd-k8s /app
WORKDIR /app
RUN python manage.py migrate

EXPOSE 8000
CMD ["python","manage.py","runserver","0.0.0.0:8000"]


