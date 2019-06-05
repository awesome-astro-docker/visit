FROM centos:7.5.1804

ADD visit3_0_0.linux-x86_64-rhel7-wmesa.tar.gz /visit
#ADD visit3_0_0.linux-x86_64-rhel7.tar.gz /visit

RUN yum install -y mesa-libGLU libpng harfbuzz libicu fontconfig libXi libSM libXrender \
    xorg-x11-server-Xvfb mesa-dri-drivers glx-utils driconf less xdpyinfo; yum clean all

# Some of the visit scripts override this anyway (sigh), but good enough
ENV LD_LIBRARY_PATH /lib64:/visit/visit3_0_0.linux-x86_64/3.0.0/linux-x86_64/lib
ENV PATH $PATH:/visit/visit3_0_0.linux-x86_64/3.0.0/linux-x86_64/bin:/visit/visit3_0_0.linux-x86_64/bin

#COPY visit.sh /visit/visit3_0_0.linux-x86_64/bin/visit
#RUN chmod 755 /visit/visit3_0_0.linux-x86_64/bin/visit
#COPY frontendlauncher.py /visit/visit3_0_0.linux-x86_64/bin/
#COPY internallauncher /visit/visit3_0_0.linux-x86_64/3.0.0/bin/

RUN rm /visit/visit3_0_0.linux-x86_64/3.0.0/linux-x86_64/lib/osmesa/*
