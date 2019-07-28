# escape=`
FROM dotnet-sdk:2.1.801 AS builder
WORKDIR /app
COPY *.csproj ./
RUN dotnet restore
COPY *.cs ./
RUN dotnet publish -c Release -o out

FROM dotnet-runtime:2.1.12
WORKDIR /app
COPY --from=builder /app/out ./
ENTRYPOINT ["C:/Program Files/dotnet/dotnet.exe", "Info.dll"]
