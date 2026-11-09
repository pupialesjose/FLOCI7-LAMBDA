# Practica 6 - Lambda: crear e invocar una funcion en floci
# Ejecutar desde la carpeta "PRACTICA 6"

$env:AWS_DEFAULT_REGION = "us-east-1"
$env:AWS_ENDPOINT_URL = "http://localhost:4566"

# 1. Codigo de la funcion
@'
def handler(event, context):
    numero = event.get("numeroPoliza", "desconocida")
    return {"mensaje": f"Poliza {numero} procesada"}
'@ | Set-Content -Path lambda_function.py -Encoding ascii

# 2. Empaquetar en zip
Compress-Archive -Path lambda_function.py -DestinationPath funcion.zip -Force

# 3. Crear la funcion
aws lambda create-function `
  --function-name procesar-poliza `
  --runtime python3.12 `
  --handler lambda_function.handler `
  --role arn:aws:iam::000000000000:role/rol-lambda `
  --zip-file fileb://funcion.zip

# 4. Evento de entrada
'{"numeroPoliza": "POL-001"}' | Set-Content -Path evento.json -Encoding ascii

# 5. Invocar la funcion
aws lambda invoke `
  --function-name procesar-poliza `
  --payload file://evento.json `
  --cli-binary-format raw-in-base64-out `
  salida.json

# 6. Ver el resultado
Get-Content salida.json