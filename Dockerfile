FROM golang:1.24.1 as build

ENV CGO_ENABLED=0

RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s -- -b $(go env GOPATH)/bin v2.1.2

WORKDIR /src/terraform-provider-rackcorp

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go install ./...

RUN go test -v ./...

RUN golangci-lint run

### END FROM build

FROM hashicorp/terraform:1.11 as base

COPY --from=build /go/bin/terraform-provider-rackcorp \
  /usr/share/terraform/plugins/registry.terraform.io/rackcorp/rackcorp/0.1.0/linux_amd64/terraform-provider-rackcorp

FROM base as test

WORKDIR /work
COPY example.tf ./main.tf

RUN terraform fmt -diff -check ./

ARG TF_LOG=WARN

RUN terraform init && \
  terraform plan -out=a.tfplan

FROM base
