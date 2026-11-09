def handler(event, context):
    numero = event.get("numeroPoliza", "desconocida")
    return {"mensaje": f"Poliza {numero} procesada"}
