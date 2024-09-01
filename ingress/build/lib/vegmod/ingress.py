import os
import time
from loguru import logger
import praw
from vegmod.serializer import serialize, serialize_list
from vegmod.utils import save_dict
from vegmod.cache import Cache

DATA_DIR = f"{os.path.dirname(__file__)}/../data"
INGRESS_FILE_PATH=f"{DATA_DIR}/ingress.json"
CACHE_FILE_PATH=f"{DATA_DIR}/ingress_cache.json"
REQUEST_DELAY = 5

def pull(subreddits: list[praw.models.Subreddit]):
    """
    Pull data from the subreddits and save it to a JSON file.
    """
    data = {}
    for subreddit in subreddits:
        cache = Cache(CACHE_FILE_PATH)
        time.sleep(REQUEST_DELAY)
        logger.info(f"Pulling subreddit={subreddit.display_name}")
        subreddit_data = serialize(subreddit, cache=cache)
        time.sleep(REQUEST_DELAY)
        logger.info(f"Pulling subreddit={subreddit.display_name} submissions")
        submissions = list(subreddit.new(limit=25))
        time.sleep(REQUEST_DELAY)
        logger.info(f"Pulling subreddit={subreddit.display_name} comments")
        comments = list(subreddit.comments(limit=25))
        time.sleep(REQUEST_DELAY)
        logger.info(f"Pulling subreddit={subreddit.display_name} removal reasons")
        removal_reasons = list(subreddit.mod.removal_reasons)
        time.sleep(REQUEST_DELAY)
        # logger.info(f"Pulling subreddit={subreddit.display_name} reports")
        # reports = list(subreddit.mod.reports())
        # time.sleep(REQUEST_DELAY)
        subreddit_data["submissions"] = serialize_list(submissions, cache=cache)
        subreddit_data["comments"] = serialize_list(comments, cache=cache)
        subreddit_data["removal_reasons"] = serialize_list(removal_reasons, cache=cache)
        # subreddit_data["reports"] = serialize_list(reports, cache=cache)
        data[subreddit.display_name] = subreddit_data
        cache.save()

    save_dict(data, INGRESS_FILE_PATH)
