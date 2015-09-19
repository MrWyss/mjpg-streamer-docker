FROM debian:wheezy
MAINTAINER marius.wyss+dockerhub@gmail.com

RUN apt-get update && apt-get install -y --no-install-recommends \
	libv4l-dev \
	libjpeg-dev \
	make \
	gcc \
	imagemagick

RUN apt-get clean \
	&& rm -rf /tmp/* /var/tmp/*  \
    && rm -rf /var/lib/apt/lists/*

ADD mjpg-streamer.tar.gz /
WORKDIR /mjpg-streamer

#RUN ln -s /usr/include/linux/videodev2.h /usr/include/linux/videodev.h
RUN make 


RUN cp mjpg_streamer /usr/local/bin
RUN cp output_http.so input_file.so input_uvc.so /usr/local/lib/
RUN cp -R www /usr/local/www
ENV LD_LIBRARY_PATH /usr/local/lib/

EXPOSE 80
CMD mjpg_streamer -i "input_uvc.so -y -n -f 30" -o "output_http.so -p 80 -w /usr/local/www"
