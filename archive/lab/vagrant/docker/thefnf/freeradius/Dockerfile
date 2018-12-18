FROM ubuntu:14.04
EXPOSE 1813 1863
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y freeradius
CMD freeradius -f