FROM jupyterhub/jupyterhub

COPY requirements.txt /tmp/requirements.txt

RUN python3 -m pip install --no-cache -r /tmp/requirements.txt

COPY jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py
COPY allowedusers.txt /srv/jupyterhub/allowedusers.txt
COPY native_auth /srv/jupyterhub/native_auth

# Install the custom authenticator in editable mode
RUN python3 -m pip install -e /srv/jupyterhub/native_auth
