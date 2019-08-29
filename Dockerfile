ARG PYTHON_MAJOR=3
FROM alpine as intermediate

RUN apk update && apk add wget gcc build-base libxt-dev libx11-dev xorg-server-dev libxmu-dev libxaw-dev bdftopcf ncurses-dev tcl tcl-dev mkfontdir && \
	wget http://x3270.bgp.nu/download/03.06/suite3270-3.6ga5-src.tgz && \ 
	tar xzvf suite3270-3.6ga5-src.tgz && \
	cd suite3270-3.6 && \
	./configure && \
	make x3270

FROM python:${PYTHON_MAJOR}-alpine

COPY --from=intermediate /suite3270-3.6/obj/x86_64-unknown-linux-gnu/x3270 /usr/lib/x3270

RUN apk update && apk add xvfb libxaw && rm -rf /var/cache/apk/* && \
    pip install robotframework six robotremoteserver robotframework-seleniumlibrary && \
	mkdir /reports

RUN	ln -s /usr/lib/x3270/x3270 /usr/bin/x3270
ARG PYTHON_MAJOR
COPY source /usr/local/lib/python${PYTHON_MAJOR}.7/site-packages/rbfZOS

# Setup X Window Virtual Framebuffer
ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_HEIGHT 1080
ENV SCREEN_WIDTH 1920

# Set number of threads for parallel execution
# By default, no parallelisation
ENV ROBOT_THREADS 1

# Dependency versions
ENV CHROMIUM_VERSION 76.0
ENV DATABASE_LIBRARY_VERSION 1.2
ENV FAKER_VERSION 4.2.0
ENV FIREFOX_VERSION 68.0
ENV FTP_LIBRARY_VERSION 1.6
ENV GECKO_DRIVER_VERSION v0.22.0
ENV PABOT_VERSION 0.84
ENV REQUESTS_VERSION 0.5.0
ENV ROBOT_FRAMEWORK_VERSION 3.1.2
ENV SELENIUM_LIBRARY_VERSION 3.3.1
ENV SSH_LIBRARY_VERSION 3.3.0
ENV XVFB_VERSION 1.20

# Prepare binaries to be executed
COPY bin/chromedriver.sh /opt/robotframework/bin/chromedriver
COPY bin/chromium-browser.sh /opt/robotframework/bin/chromium-browser
COPY bin/run-tests-in-virtual-screen.sh /opt/robotframework/bin/
#COPY tests/sample.robot /opt/robotframework/tests

RUN chmod 777 /opt/robotframework/bin/chromium-browser
RUN chmod 777 /opt/robotframework/bin/run-tests-in-virtual-screen.sh

# Install system dependencies
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk update \
  && apk --no-cache upgrade \
  && apk --no-cache --virtual .build-deps add \
    gcc \
    libffi-dev \
    linux-headers \
    make \
    musl-dev \
    openssl-dev \
    which \
    wget \
  && apk --no-cache add \
    "chromium~$CHROMIUM_VERSION" \
    "chromium-chromedriver~$CHROMIUM_VERSION" \
    "firefox~$FIREFOX_VERSION" \
    xauth \
    "xvfb-run~$XVFB_VERSION" \
  && mv /usr/lib/chromium/chrome /usr/lib/chromium/chrome-original \
  && ln -sfv /opt/robotframework/bin/chromium-browser /usr/lib/chromium/chrome \
# FIXME: above is a workaround, as the path is ignored

# Install Robot Framework and Selenium Library
  && pip3 install \
    --no-cache-dir \
    robotframework==$ROBOT_FRAMEWORK_VERSION \
    robotframework-databaselibrary==$DATABASE_LIBRARY_VERSION \
    robotframework-faker==$FAKER_VERSION \
    robotframework-ftplibrary==$FTP_LIBRARY_VERSION \
    robotframework-pabot==$PABOT_VERSION \
    robotframework-requests==$REQUESTS_VERSION \
    robotframework-seleniumlibrary==$SELENIUM_LIBRARY_VERSION \
    robotframework-sshlibrary==$SSH_LIBRARY_VERSION \
    PyYAML \

# Download Gecko drivers directly from the GitHub repository
  && wget -q "https://github.com/mozilla/geckodriver/releases/download/$GECKO_DRIVER_VERSION/geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz" \
    && tar xzf geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz \
    && mkdir -p /opt/robotframework/drivers/ \
    && mv geckodriver /opt/robotframework/drivers/geckodriver \
    && rm geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz \
  && apk del --no-cache --update-cache .build-deps

# Update system path
ENV PATH=/opt/robotframework/bin:/opt/robotframework/drivers:$PATH

#ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/sh"]
