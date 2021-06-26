FROM python:3.9.0-buster
LABEL maintainer="lauwarm@mailbox.org"


ENV streamlinkVersion=2.2.0

ADD https://github.com/streamlink/streamlink/releases/download/${streamlinkVersion}/streamlink-${streamlinkVersion}.tar.gz /opt/

RUN apt-get update && apt-get install gosu

RUN tar -xzf /opt/streamlink-${streamlinkVersion}.tar.gz -C /opt/ && \
	rm /opt/streamlink-${streamlinkVersion}.tar.gz && \
	cd /opt/streamlink-${streamlinkVersion}/ && \
	python setup.py install

RUN mkdir /home/download
RUN mkdir /home/script
RUN mkdir /home/plugins

COPY ./streamlink-recorder.sh /home/script/
COPY ./entrypoint.sh /home/script
WORKDIR /home/script

RUN ["chmod", "+x", "/home/script/entrypoint.sh" ]
RUN chmod +x /home/script/streamlink-recorder.sh

#ENTRYPOINT [ "/home/script/entrypoint.sh" ]
#ENTRYPOINT ["/bin/sh"]

# replace with gosu???
#USER myuser

# point entrypoint to /bin/sh???
#CMD /home/script/streamlink-recorder.sh ${streamOptions} ${streamLink} ${streamQuality} ${streamName}
CMD /home/script/streamlink-recorder.sh ${streamOptions} ${streamLink} ${streamQuality} ${streamName}
