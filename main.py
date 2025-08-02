from fastapi import FastAPI
from fastmcp.server import FastMCP

# 1. Créez une instance de FastMCP
# C'est votre serveur principal.
server = FastMCP(
    name="MySimpleServer",
    instructions="Un exemple de serveur MCP simple.",
)

# 2. Utilisez le décorateur @server.prompt() pour définir des prompts
@server.prompt()
async def echo(message: str) -> str:
    """
    Une fonction simple qui renvoie le message reçu.
    """
    return message

# 3. Créez une instance de FastAPI
app = FastAPI(
    title="FastMCP Server",
    description="Un exemple de déploiement de FastMCP avec FastAPI et Docker.",
    version="1.0.0",
)

# 4. Montez votre serveur MCP sur l'application FastAPI
app.mount("/mcp", server.http_app())

# 5. (Optionnel) Ajoutez un point de terminaison racine pour les vérifications de santé
@app.get("/")
def read_root():
    """Un point de terminaison simple pour vérifier que le serveur est en ligne."""
    return {"status": "online", "message": "Welcome to the FastMCP API"}
