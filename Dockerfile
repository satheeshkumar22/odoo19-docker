FROM odoo:19

USER root

# Install only the required OS packages
RUN apt-get update && apt-get install -y \
    git \
    python3-venv \
    python3-dev \
    gcc \
    g++ \
    build-essential \
    libffi-dev \
    libssl-dev \
    libjpeg-dev \
    zlib1g-dev \
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libsasl2-dev \
    libmagic1 \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python3 -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip
RUN pip install --upgrade pip setuptools wheel

# Install Python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copy custom addons
COPY addons /mnt/extra-addons

# Copy configuration
COPY config/odoo.conf /etc/odoo/

# Set permissions
RUN chown -R odoo:odoo /mnt/extra-addons /etc/odoo /opt/venv

USER odoo

EXPOSE 8069
