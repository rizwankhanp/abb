FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base

RUN apk update && \
  apk upgrade && \
  apk add --update ca-certificates && \
  apk add chromium --update-cache --repository http://nl.alpinelinux.org/alpine/edge/community && \
  apk add --no-cache \
      nss \
      freetype \
      harfbuzz \
      ttf-freefont && \
  rm -rf /var/cache/apk/*

WORKDIR /app

EXPOSE 8080

ENV ASPNETCORE_URLS=http://+:8080

FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build

WORKDIR /src

COPY ["DocumentGeneratorService/DocumentGeneratorService.csproj", "DocumentGeneratorService/"]

RUN dotnet restore "DocumentGeneratorService/DocumentGeneratorService.csproj"

COPY . .

WORKDIR "/src/DocumentGeneratorService"

RUN dotnet build "DocumentGeneratorService.csproj" -c Release -o /app/build

FROM build AS publish

RUN dotnet publish "DocumentGeneratorService.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final

WORKDIR /app

COPY --from=publish /app/publish .

RUN adduser -D -u 1000 appuser && chown -R appuser /app
USER appuser

ENTRYPOINT ["dotnet", "DocumentGeneratorService.dll"]
