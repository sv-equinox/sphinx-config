# Building stage for the docs
FROM sphinxdoc/sphinx:5.3.0 as builder

WORKDIR /docs

# Install the requirements
ADD requirements.txt .
RUN pip3 install -r requirements.txt

# Copy the docs
ADD . .

# Build the docs
RUN make html


# Serving stage for the docs
# This is the final image that will be used to serve the docs,
# This will keep the final image as small as possible.
FROM nginx:1.23-alpine as server

COPY --from=builder /docs/build/html /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
