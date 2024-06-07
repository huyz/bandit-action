FROM python:3.12-alpine

WORKDIR /app

COPY dist/bandit_github_formatter-1.2.0.tar.gz bandit_github_formatter-1.2.0.tar.gz
RUN pip install pyyaml==6.0.1 bandit requests bandit_github_formatter-1.2.0.tar.gz
RUN rm bandit_github_formatter-1.2.0.tar.gz

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
