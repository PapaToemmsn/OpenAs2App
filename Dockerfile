FROM eclipse-temurin:11.0.22_7-jdk-jammy AS builder
COPY . /usr/src/openas2
WORKDIR /usr/src/openas2
# To test Locally builder environment:
# docker run --rm -it -v $(pwd):/usr/src/openas2 openjdk:11 bash
RUN apt update
RUN apt-get install -y unzip
RUN rm -f Server/dist/*
RUN rm -f Remote/dist/*
RUN rm -f Bundle/dist/*
RUN ./mvnw clean package
RUN mkdir ./Runtime && unzip Server/dist/OpenAS2Server-*.zip -d Runtime
RUN ./mvnw clean
COPY start-container.sh /usr/src/openas2/Runtime/bin/
RUN cd /usr/src/openas2/Runtime/bin && \
    chmod 755 *.sh && \
    cd /usr/src/openas2/Runtime && \
    mv config config_template


FROM eclipse-temurin:11.0.22_7-jre-jammy
ENV OPENAS2_BASE=/opt/openas2
ENV OPENAS2_HOME=/opt/openas2
ENV OPENAS2_TMPDIR=/opt/openas2/temp
RUN groupadd  openas2 -g 5001  && \
    groupadd  as2data -g 10001  && \
    useradd -m -d /opt/openas2 -u 5001 -g openas2 -G as2data openas2
COPY --chown=openas2:openas2 --from=builder /usr/src/openas2/Runtime/bin ${OPENAS2_BASE}/bin
COPY --chown=openas2:openas2 --from=builder /usr/src/openas2/Runtime/lib ${OPENAS2_BASE}/lib
COPY --chown=openas2:openas2 --from=builder /usr/src/openas2/Runtime/resources ${OPENAS2_BASE}/resources
COPY --chown=openas2:openas2 --from=builder /usr/src/openas2/Runtime/config_template ${OPENAS2_HOME}/config_template
RUN mkdir ${OPENAS2_BASE}/config ${OPENAS2_BASE}/logs ${OPENAS2_BASE}/data
RUN chown openas2:openas2 ${OPENAS2_BASE}/config ${OPENAS2_BASE}/logs ${OPENAS2_BASE}/data
WORKDIR $OPENAS2_HOME
USER openas2
ENTRYPOINT ${OPENAS2_BASE}/bin/start-container.sh
