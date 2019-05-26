# escape=`
FROM dotnet-sdk:2.1.700 AS builder
WORKDIR /app
COPY *.csproj ./
RUN dotnet restore
COPY *.cs ./
RUN dotnet publish -c Release -o out

FROM dotnet-runtime:2.1.11
WORKDIR /app
COPY --from=builder /app/out ./
ENTRYPOINT ["C:/Program Files/dotnet/dotnet.exe", "Info.dll"]
