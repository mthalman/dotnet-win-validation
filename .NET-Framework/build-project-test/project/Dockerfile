# escape=`

ARG WINDOWS_TAG
FROM $WINDOWS_TAG AS build
WORKDIR /app

RUN curl -SL --output vs_buildtools.exe https://aka.ms/vs/16/release/vs_buildtools.exe `
    && start /w vs_buildtools.exe --quiet --wait --norestart --nocache `
        --installPath "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\BuildTools" `
        --add Microsoft.VisualStudio.Workload.NetCoreBuildTools `
        --add Microsoft.Net.Component.4.8.SDK `
    && powershell -Command "if ($err = dir $Env:TEMP -Filter dd_setup_*_errors.log | where Length -gt 0 | Get-Content) { throw $err }" `
    # Cleanup
    && del vs_BuildTools.exe `
    && (for /D %i in ("%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\*") do rmdir /S /Q "%i") `
    && powershell Remove-Item -Force -Recurse "%TEMP%\*" 

# copy csproj and restore
COPY *.csproj .
RUN dotnet restore

# copy everything else and build app
COPY . .
WORKDIR /app
RUN dotnet build --no-restore


FROM build AS publish
WORKDIR /app
RUN dotnet publish -c Release -o out --no-restore


FROM $WINDOWS_TAG AS runtime
WORKDIR /app
COPY --from=publish /app/out ./
ENTRYPOINT ["dotnetapp.exe"]
