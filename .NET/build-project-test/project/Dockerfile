# escape=`

ARG WINDOWS_TAG
FROM $WINDOWS_TAG AS build

USER ContainerAdministrator
RUN curl -fSLo dotnet-sdk-win-x64.zip https://aka.ms/dotnet/current/dotnet-sdk-win-x64.zip `
    && mkdir "\Program Files\dotnet" `
    && tar -C "\Program Files\dotnet" -oxzf dotnet-sdk-win-x64.zip

RUN setx /M PATH "%PATH%;C:\Program Files\dotnet"
USER ContainerUser

WORKDIR /app

RUN dotnet new console `
    && dotnet publish -c release -o out


FROM $WINDOWS_TAG AS app

USER ContainerAdministrator
RUN curl -fSLo dotnet-runtime-win-x64.zip https://aka.ms/dotnet/current/dotnet-runtime-win-x64.zip `
    && mkdir "\Program Files\dotnet" `
    && tar -C "\Program Files\dotnet" -oxzf dotnet-runtime-win-x64.zip

RUN setx /M PATH "%PATH%;C:\Program Files\dotnet"
USER ContainerUser

WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "app.dll"]
