import os
import time
from loguru import logger
import praw
from vegmod.serializer import serialize, serialize_list
import json

DATA_DIR = f"{os.path.dirname(__file__)}/../data"
INGRESS_FILE_PATH=f"{DATA_DIR}/ingress.json"

def pull(subreddits: list[praw.models.Subreddit]):
    """
    Pull data from the subreddits and save it to a JSON file.
    """
    data = {}
    for subreddit in subreddits:
        time.sleep(1)
        logger.info(f"Pulling subreddit={subreddit.display_name}")
        subreddit_data = serialize(subreddit)
        time.sleep(1)
        logger.info(f"Pulling subreddit={subreddit.display_name} submissions")
        submissions = list(subreddit.new(limit=25))
        time.sleep(1)
        logger.info(f"Pulling subreddit={subreddit.display_name} comments")
        comments = list(subreddit.comments(limit=25))
        time.sleep(1)
        logger.info(f"Pulling subreddit={subreddit.display_name} removal reasons")
        removal_reasons = list(subreddit.mod.removal_reasons)
        time.sleep(1)
        logger.info(f"Pulling subreddit={subreddit.display_name} reports")
        reports = list(subreddit.mod.reports())
        time.sleep(1)
        subreddit_data["submissions"] = serialize_list(submissions)
        subreddit_data["comments"] = serialize_list(comments)
        subreddit_data["removal_reasons"] = serialize_list(removal_reasons)
        subreddit_data["reports"] = serialize_list(reports)
        data[subreddit.display_name] = subreddit_data
    save(data)

def save(data: dict):
    """
    Save the data to a JSON file.
    """
    with open(INGRESS_FILE_PATH, "w", encoding="utf-8") as f:
        f.write(json.dumps(data, indent=4))
