import json
import re
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

@app.command()
def inspect(object_type: str, object_id: str):
    """
    Object types: submission, comment, subreddit, redditor
    """
    if object_type == "submission":
        obj = reddit.submission(object_id)
        # t = obj.title
    elif object_type == "comment":
        obj = reddit.comment(object_id)
        typer.echo("comment vars")
        typer.echo(vars(obj))
        
        author = obj.author
        typer.echo("comment author vars")
        typer.echo(vars(author))
        
        typer.echo(f"comment author vars expanded {author.comment_karma}")
        typer.echo(vars(author))
        # t = obj.body
    elif object_type == "subreddit":
        obj = reddit.subreddit(object_id)
        typer.echo("subreddit vars")
        typer.echo(vars(obj))
        
        removal_reasons = obj.mod.removal_reasons
        typer.echo("subreddit removal reasons vars")
        typer.echo(vars(author))
        
        typer.echo(f"subreddit author vars expanded {author.comment_karma}")
        typer.echo(vars(author))
        # t = obj.body
    elif object_type == "redditor":
        obj = reddit.redditor(object_id)
        # t = obj.comment_karma
    else:
        raise ValueError(f"Invalid object type: {object_type}, must be one of: submission, comment, subreddit, user")
    # vars_string = str(vars(obj))
    
    # typer.echo("-vars_string-------------")
    # typer.echo(vars_string)
    # typer.echo("-------------------------")
    
    # # python objects are represented as strings in the vars() output
    # # '_reddit': <praw.reddit.Reddit object at 0x735720051f70>,
    # # so we need to convert them to
    # # '_reddit': "<praw.reddit.Reddit object at 0x735720051f70>",
    # json_string = re.sub(r'(<[a-zA-Z0-9._\s]+object[a-zA-Z0-9._\s]+>)', r'"\1"', vars_string)
    
    # # also UserSubreddit(display_name='vegmod'),
    # # should be converted to
    # # '<UserSubreddit>',
    # json_string = re.sub(r'(\s)([A-Z])([a-zA-Z]+)\(([^\)]+)\)', r'\1"<\2\3>"', json_string)
    
    # # replace all single quotes that are surrounded by double quotes with &apos;
    # # this is necessary because the JSON module does not support single quotes
    # # inside of double quotes
    # in_double_quotes = False
    # in_single_quotes = False
    # new_json_string = ""
    # for i, c in enumerate(json_string):
    #     if c == "'" and in_double_quotes:
    #         new_json_string += "&apos;"
    #         continue
    #     if c == '"' and in_single_quotes:
    #         new_json_string += "&quot;"
    #         continue
    #     if c == '"':
    #         in_double_quotes = not in_double_quotes
    #     if c == "'":
    #         in_single_quotes = not in_single_quotes
    #     new_json_string += c
    # json_string = new_json_string

    # json_string = json_string.replace("'", '"')
    # json_string = json_string.replace("&apos;", "'")
        
    # json_string = json_string.replace("None", "null").\
    #     replace("True", "true").\
    #     replace("False", "false")
        
    # typer.echo("-json_string-------------")
    # typer.echo(json_string)
    # typer.echo("-------------------------")
    
    # json_obj = json.loads(json_string)

    # typer.echo(json.dumps(json_obj, indent=4))
    


def main():
    app()
