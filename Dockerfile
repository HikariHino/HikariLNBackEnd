# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy toàn bộ repo (gồm folder HikariLN.Api)
COPY . .

# Chuyển vào đúng thư mục project .NET
WORKDIR /src/HikariLN.Api

# Restore + Publish
RUN dotnet restore
RUN dotnet publish -c Release -o /app/out

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

COPY --from=build /app/out .

# Render sẽ chạy app trên 8080 (dotenv chuẩn của ASP.NET)
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "HikariLN.Api.dll"]
