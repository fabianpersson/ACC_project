FROM redis
ARG pw=default
ENV pw=$pw

CMD ["sh", "-c", "exec redis-server --requirepass $pw"]


