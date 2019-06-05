#FROM centos:7.5.1804 as visit
FROM centos:7.5.1804

ADD visit3_0_0.linux-x86_64-rhel7-wmesa.tar.gz /visit
#ADD visit3_0_0.linux-x86_64-rhel7.tar.gz /visit

#FROM centos:7.5.1804
#COPY --from=visit /visit /visit

RUN yum install -y mesa-libGLU libpng harfbuzz libicu fontconfig libXi libSM libXrender \
    xorg-x11-server-Xvfb mesa-dri-drivers glx-utils driconf less xdpyinfo; yum clean all

RUN yum install -y net-tools

#ENV LD_LIBRARY_PATH /visit/visit3_0_0.linux-x86_64/3.0.0/linux-x86_64/lib:/visit/visit3_0_0.linux-x86_64/3.0.0/linux-x86_64/lib/osmesa/
ENV LD_LIBRARY_PATH /lib64:/visit/visit3_0_0.linux-x86_64/3.0.0/linux-x86_64/lib:/visit/visit3_0_0.linux-x86_64/3.0.0/linux-x86_64/lib/osmesa
ENV PATH $PATH:/visit/visit3_0_0.linux-x86_64/3.0.0/linux-x86_64/bin:/visit/visit3_0_0.linux-x86_64/bin

COPY visit.sh /visit/visit3_0_0.linux-x86_64/bin/visit
RUN chmod 755 /visit/visit3_0_0.linux-x86_64/bin/visit
COPY frontendlauncher.py /visit/visit3_0_0.linux-x86_64/bin/
COPY internallauncher /visit/visit3_0_0.linux-x86_64/3.0.0/bin/

RUN rm /visit/visit3_0_0.linux-x86_64/3.0.0/linux-x86_64/lib/osmesa/*

#/tmp/visit3_0_0.linux-x86_64/3.0.0/linux-x86_64/lib/osmesa:/tmp/visit3_0_0.linux-x86_64/3.0.0/linux-x86_64/lib
#
#ENTRYPOINT /visit/visit3_0_0.linux-x86_64/bin/visit
#CMD /visit/visit3_0_0.linux-x86_64/bin/visit

### NO it's a GUI app!  Use "ssh -Y symmetry1"...
# /usr/bin/Xvfb :1 -screen 0 1024x768x24 &
# export DISPLAY=:1
# /tmp/visit3_0_0.linux-x86_64/bin/visit &
