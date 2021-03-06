FROM gitlab/gitlab-ce:8.15.5-ce.0

MAINTAINER beginor <beginor@qq.com>

ENV TMPDIR=/tmp/gitlab-zh
ENV GITLAB_VERSION=v8.15.5

# clone && apply zh patch.
RUN git clone --progress --verbose https://gitlab.com/xhang/gitlab.git $TMPDIR && \
    cd $TMPDIR && \
    git diff $GITLAB_VERSION..$GITLAB_VERSION-zh > $TMPDIR/$GITLAB_VERSION-zh.diff && \
    cd /opt/gitlab/embedded/service/gitlab-rails && git apply $TMPDIR/$GITLAB_VERSION-zh.diff && \
    rm -rf $TMPDIR

# Expose web & ssh
EXPOSE 443 80 22

# Define data volumes
VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]
# Wrapper to handle signal, trigger runit and reconfigure GitLab
CMD ["/assets/wrapper"]
