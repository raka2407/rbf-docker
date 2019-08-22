FROM fedora:30

# Setup X Window Virtual Framebuffer
ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_HEIGHT 1080
ENV SCREEN_WIDTH 1920

# Set number of threads for parallel execution
# By default, no parallelisation
ENV ROBOT_THREADS 1

# Dependency versions
ENV CHROMIUM_VERSION 75.0.*
ENV FIREFOX_VERSION 68.0*
ENV GECKO_DRIVER_VERSION v0.22.0
ENV PYTHON_PIP_VERSION 19.0*
ENV XVFB_VERSION 1.20.*

USER root


# Prepare binaries to be executed
COPY bin/chromedriver.sh /opt/robotframework/bin/chromedriver
COPY bin/chromium-browser.sh /opt/robotframework/bin/chromium-browser
COPY bin/run-tests-in-virtual-screen.sh /opt/robotframework/bin/

# Install system dependencies
RUN dnf upgrade -y \
  && dnf install -y \
    chromedriver-$CHROMIUM_VERSION \
    chromium-$CHROMIUM_VERSION \
    firefox-$FIREFOX_VERSION \
    python3-pip-$PYTHON_PIP_VERSION \
    xauth \
    xorg-x11-server-Xvfb-$XVFB_VERSION \
    which \
    wget \
  && dnf clean all -y \
  && mv /usr/lib64/chromium-browser/chromium-browser /usr/lib64/chromium-browser/chromium-browser-original \
  && ln -sfv /opt/robotframework/bin/chromium-browser /usr/lib64/chromium-browser/chromium-browser
# FIXME: above is a workaround, as the path is ignored

# Make python 3 the default python      
RUN alternatives --install /usr/bin/python python /usr/bin/python3.7 2

# Install Robot Framework
RUN pip3 install --no-cache-dir rbf


# Download Gecko drivers directly from the GitHub repository
RUN wget -q "https://github.com/mozilla/geckodriver/releases/download/$GECKO_DRIVER_VERSION/geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz" \
      && tar xzf geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz \
      && mkdir -p /opt/robotframework/drivers/ \
      && mv geckodriver /opt/robotframework/drivers/geckodriver \
      && rm geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz

RUN chmod 777 /opt/robotframework/bin/chromium-browser
RUN chmod 777 /opt/robotframework/bin/run-tests-in-virtual-screen.sh

# Update system path
ENV PATH=/opt/robotframework/bin:/opt/robotframework/drivers:$PATH
