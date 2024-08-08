import os
import typer
import vegmod.ingress
from vegmod import reddit

app = typer.Typer()

@app.command()
def ingress():
    """
    Pull data from the subreddits and save it to a JSON file.
    """
    subreddits = os.environ.get("INGRESS_SUBREDDITS").split(",")
    typer.echo(f"Pulling data from {subreddits}")
    vegmod.ingress.pull([reddit.subreddit(subreddit) for subreddit in subreddits])
    typer.echo(f"Data pulled and saved to {vegmod.ingress.INGRESS_FILE_PATH}")

@app.command()
def ls():
    """
    Lists the subreddits that will be pulled from.
    """
    subreddits = os.environ.get("INGRESS_SUBREDDITS").split(",")
    for subreddit in subreddits:
        typer.echo(subreddit)

def main():
    app()
