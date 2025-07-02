# Dockerfile for Microsoft SQL Server Developer Edition
FROM mcr.microsoft.com/mssql/server:2022-latest

ARG SA_PASSWORD_ARG

# Set environment variables for SQL Server
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=${SA_PASSWORD_ARG}

# Expose SQL Server port
EXPOSE 1433

USER root
# Copy initialization scripts
COPY ./utils/init/ /tmp/initialisation-scripts/

RUN chmod +x /tmp/initialisation-scripts/*.sh

user mssql
ENTRYPOINT ["/tmp/initialisation-scripts/entry-point.sh"]

