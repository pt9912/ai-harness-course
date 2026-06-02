# docs-check — reproduzierbarer Markdown-Link-Validator
# Node ohne externe Dependencies. Vorbild: euler-fourier-hilbert/tools/.

FROM node:22-alpine
WORKDIR /work
COPY docs-check.js /usr/local/bin/docs-check.js
RUN chmod +x /usr/local/bin/docs-check.js
ENTRYPOINT ["node", "/usr/local/bin/docs-check.js"]
