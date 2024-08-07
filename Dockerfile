FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copiar os arquivos do projeto
COPY *.csproj ./
RUN dotnet restore

# Restore as distinct layers
RUN dotnet restore

# Copiar o restante do código e compilar a aplicação
COPY . .
RUN dotnet build --configuration Release --output /app/build

# Usar a imagem base do runtime do .NET para a imagem final
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/build .

EXPOSE 5203

# Definir o comando de inicialização
ENTRYPOINT ["dotnet", "HelloWorld.dll"]