#!/usr/bin/env bash
set -euo pipefail


echo "-> Atualizando pip e instalando dependências"
python -m pip install --upgrade pip
python -m pip install -r requirements.txt


echo "-> Coletando static files"
python manage.py collectstatic --noinput


# Rodar migrations somente se DATABASE_URL estiver configurada
if [ -n "${DATABASE_URL:-}" ]; then
echo "-> Rodando migrations"
python manage.py migrate --noinput
else
echo "-> DATABASE_URL não encontrada — pulando migrate"
fi


# Copiar staticfiles para a saída esperada pelo vercel static-build
mkdir -p .vercel/output/static
cp -r staticfiles/* .vercel/output/static/ || true


echo "-> Build finalizado"