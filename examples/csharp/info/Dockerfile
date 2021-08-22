# escape=`
ARG DOTNET_SDK_IMAGE
ARG DOTNET_RUNTIME_IMAGE

FROM ${DOTNET_SDK_IMAGE} AS builder
WORKDIR /app
COPY *.csproj ./
RUN dotnet restore
COPY *.cs ./
RUN dotnet publish -c Release -o out

FROM ${DOTNET_RUNTIME_IMAGE}
WORKDIR /app
COPY --from=builder /app/out ./
ENTRYPOINT ["Info.exe"]
