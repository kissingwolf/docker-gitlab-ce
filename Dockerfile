FROM gitlab/gitlab-ce:8.7.5-ce.0

MAINTAINER beginor <beginor@qq.com>

ENV TMPDIR=/tmp/gitlab-zh
ENV GITLAB_BRUNCH=8-7

# clone && apply zh patch.
RUN git clone https://gitlab.com/larryli/gitlab.git $TMPDIR && \
    cd $TMPDIR && \
    git diff origin/$GITLAB_BRUNCH-stable..$GITLAB_BRUNCH-zh > $TMPDIR/$GITLAB_BRUNCH-zh.diff && \
    cd /opt/gitlab/embedded/service/gitlab-rails && git apply $TMPDIR/$GITLAB_BRUNCH-zh.diff &&\
    rm -rf $TMPDIR

# Expose web & ssh
EXPOSE 443 80 22

# Define data volumes
VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]
# Wrapper to handle signal, trigger runit and reconfigure GitLab
CMD ["/assets/wrapper"]
