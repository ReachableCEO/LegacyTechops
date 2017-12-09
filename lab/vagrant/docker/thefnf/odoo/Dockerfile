FROM python:2.7
RUN apt-get install -y libldap2-dev libsasl2-dev && \
  adduser odoo --system --group --shell /bin/bash
USER odoo
ENV HOME /home/odoo
ENV PATH $HOME/.local/bin:$PATH
WORKDIR /home/odoo
RUN curl http://nightly.odoo.com/8.0/nightly/src/odoo_8.0-latest.tar.gz |tar xz --strip-components 1 && \
  python setup.py install --user && \
  python setup.py install --user --single-version-externally-managed --root / # Strips version hash from module directories
ADD openerp_serverrc /home/odoo/.openerp_serverrc
EXPOSE 8069 8072
CMD openerp-server