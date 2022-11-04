### Cache ###
FROM dokken/centos-8:latest

# update OS + dependencies & run Caché silent instal
RUN yum -y update \
 && yum -y install which tar hostname net-tools wget git \
 && yum -y clean all \ 
 && ln -sf /etc/locatime /usr/share/zoneinfo/Europe/Netherlands

ARG cache=IRIS-2022.1.1.374.0

ENV TMP_INSTALL_DIR=/tmp/distrib

# vars for Caché silent install
ENV ISC_PACKAGE_INSTANCENAME="ENSEMBLE" \
    ISC_PACKAGE_INSTALLDIR="/opt/ensemble/" \
    ISC_PACKAGE_UNICODE="Y" \
    ISC_PACKAGE_CLIENT_COMPONENTS=""

# set-up and install Caché from distrib_tmp dir 
WORKDIR ${TMP_INSTALL_DIR}

COPY cache.key $ISC_PACKAGE_INSTALLDIR/mgr/

COPY ${cache}-lnxrh8x64.tar.gz .

# cache distributive
RUN tar xvfzC $cache-lnxrh8x64.tar.gz . \
 && ./$cache-lnxrhx64/cinstall_silent \
 && cat $ISC_PACKAGE_INSTALLDIR/mgr/cconsole.log \
 && ccontrol stop $ISC_PACKAGE_INSTANCENAME quietly 
##\
#  && rm -rf $TMP_INSTALL_DIR

# Caché container main process PID 1 (https://github.com/zrml/ccontainermain)
RUN curl -L https://github.com/daimor/ccontainermain/releases/download/0.1/ccontainermain -o /ccontainermain \
 && chmod +x /ccontainermain

EXPOSE 57772 1972 22

ENTRYPOINT ["/ccontainermain", "-cconsole", "-i", "iris"]