######################################################################
# Builder stage
FROM ruby:2.7.2-alpine3.12 as Builder
LABEL mantainer="Alberto Gil <agildav@gmail.com>"
LABEL version="1.0"

ARG RAILS_ROOT="/home/admin/csv-importer"
ARG BUILD_PACKAGES="build-base git postgresql-dev"
ARG DEV_PACKAGES="curl file less curl-dev postgresql-client"
ARG RUBY_PACKAGES="tzdata"
ARG EXCLUDE_BUNDLE
ARG HIVEMIND_PATH="bin/hivemind"
ARG ENTRYPOINT_PATH="docker-entrypoint.sh"

RUN apk add --update --no-cache --virtual build-dependencies ${BUILD_PACKAGES} \
  && apk add --update --no-cache ${DEV_PACKAGES} ${RUBY_PACKAGES}

WORKDIR ${RAILS_ROOT}

COPY Gemfile* ./

ENV RUBY_MAJOR_VERSION="2.7.0"
ENV GEM_HOME="/usr/local/bundle"
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG $GEM_HOME
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$GEM_HOME/ruby/$RUBY_MAJOR_VERSION/bin:$PATH
ENV BUNDLER_VERSION="2.1.4"

RUN gem update --system \
  && gem install bundler -v $BUNDLER_VERSION \
  && bundle config git.allow_insecure true \
  && bundle install ${EXCLUDE_BUNDLE} --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3 \
  && rm -rf ${BUNDLE_PATH}/ruby/*/cache/*.gem \
  && rm -rf ${BUNDLE_PATH}/ruby/*/gems/*.c \
  && rm -rf ${BUNDLE_PATH}/ruby/*/gems/*.o \
  && rm -rf ${BUNDLE_PATH}/cache/*.gem \
  && rm -rf ${BUNDLE_PATH}/gems/*/gems/*.c \
  && rm -rf ${BUNDLE_PATH}/gems/*/gems/*.o

COPY . ./
RUN rm -rf tmp/* log/* \
  && rm -rf /tmp/* /var/cache/apk/* \
  && apk del build-dependencies \
  && chmod +x ${HIVEMIND_PATH} \
  && chmod +x ${ENTRYPOINT_PATH}

######################################################################
# Final stage
FROM ruby:2.7.2-alpine3.12 as Runner
LABEL mantainer="Alberto Gil <agildav@gmail.com>"
LABEL version="1.0"

ARG RAILS_ROOT="/home/admin/csv-importer"
ARG DEV_PACKAGES="curl file less curl-dev postgresql-client"

ARG RUBY_PACKAGES="tzdata"
ARG HIVEMIND_PATH="bin/hivemind"

ENV RUBY_MAJOR_VERSION="2.7.0"
ENV GEM_HOME="/usr/local/bundle"
ENV BIN_HOME="/usr/local/bin"
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG $GEM_HOME
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$GEM_HOME/ruby/$RUBY_MAJOR_VERSION/bin:$PATH
ENV BUNDLER_VERSION="2.1.4"

RUN apk add --update --no-cache ${DEV_PACKAGES} ${RUBY_PACKAGES} \
  && rm -rf /tmp/* /var/cache/apk/* \
  && addgroup -g 1000 -S admin \
  && adduser -u 1000 -S admin -G admin \
  && rm -rf ${BUNDLE_PATH}
USER admin

COPY --from=Builder --chown=admin:admin ${BUNDLE_PATH}/ ${BUNDLE_PATH}/
COPY --from=Builder --chown=admin:admin ${RAILS_ROOT}/ ${RAILS_ROOT}/
COPY --from=Builder --chown=admin:admin ${RAILS_ROOT}/${HIVEMIND_PATH} ${BIN_HOME}/

ENV RAILS_LOG_TO_STDOUT true

WORKDIR ${RAILS_ROOT}

EXPOSE 3000

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["hivemind"]
