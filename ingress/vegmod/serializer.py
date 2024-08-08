"""
This module contains functions for serializing PRAW objects into JSON-serializable dictionaries.
"""
import time
import praw
from loguru import logger

def serialize(o) -> dict:
    """
    Serialize a PRAW object into a JSON-serializable dictionary.
    """
    if o is None:
        return None

    s = {}
    try:
        s = _switch_case(o)
    except Exception as e:
        logger.error(f"Failed to serialize object={o} type={type(o).__name__} error={e}")
        s["_error"] = str(e)
        s["_error_type"] = type(e).__name__
    finally:
        s["_type"] = type(o).__name__
        s["_serialized_at"] = time.time()
    return s

def serialize_list(o: list) -> list:
    """
    Serialize a list of PRAW objects into a list of JSON-serializable dictionaries.
    """
    data = []
    for item in o:
        data.append(serialize(item))
    return data

def _switch_case(o) -> dict:
    """
    Serialize a PRAW object into a JSON-serializable dictionary using a switch-case pattern.
    """
    return {
        praw.models.Submission: _serialize_submission,
        praw.models.Comment: _serialize_comment,
        praw.models.Subreddit: _serialize_subreddit,
        praw.models.Redditor: _serialize_redditor,
        praw.models.Rule: _serialize_rule,
        praw.models.RemovalReason: _serialize_removal_reason,
        praw.models.PollOption: _serialize_poll_option,
        praw.models.PollData: _serialize_poll_data,
        praw.models.reddit.subreddit.SubredditRedditorFlairTemplates: _serialize_subreddit_flair_templates,
    }[type(o)](o)

def _serialize_submission(o: praw.models.Submission):
    # https://praw.readthedocs.io/en/stable/code_overview/models/submission.html
    # if the submission is a poll, the poll_data attribute will be a PollData object
    try:
        poll_data = serialize(o.poll_data)
    except AttributeError:
        poll_data = None
    
    try:
        link_flair_template_id = o.link_flair_template_id
    except AttributeError:
        link_flair_template_id = None

    return {
        "author": serialize(o.author),
        "author_flair_text": o.author_flair_text,
        "created_utc": o.created_utc,
        "distinguished": o.distinguished,
        "edited": o.edited,
        "id": o.id,
        "is_original_content": o.is_original_content,
        "is_self": o.is_self,
        "link_flair_template_id": link_flair_template_id,
        "link_flair_text": o.link_flair_text,
        "locked": o.locked,
        "name": o.name,
        "num_comments": o.num_comments,
        "over_18": o.over_18,
        "permalink": o.permalink,
        "poll_data": poll_data,
        "score": o.score,
        "selftext": o.selftext,
        "spoiler": o.spoiler,
        "stickied": o.stickied,
        "title": o.title,
        "upvote_ratio": o.upvote_ratio,
        "url": o.url,
    }

def _serialize_comment(o: praw.models.Comment):
    # https://praw.readthedocs.io/en/stable/code_overview/models/comment.html
    return {
        "author": serialize(o.author),
        "body": o.body,
        "body_html": o.body_html,
        "created_utc": o.created_utc,
        "distinguished": o.distinguished,
        "edited": o.edited,
        "id": o.id,
        "is_submitter": o.is_submitter,
        "link_id": o.link_id,
        "parent_id": o.parent_id,
        "permalink": o.permalink,
        "score": o.score,
        "stickied": o.stickied,
        "subreddit_id": o.subreddit_id,
    }

def _serialize_subreddit(o: praw.models.Subreddit):
    # https://praw.readthedocs.io/en/stable/code_overview/models/subreddit.html
    return {
        "can_assign_link_flair": o.can_assign_link_flair,
        "can_assign_user_flair": o.can_assign_user_flair,
        "created_utc": o.created_utc,
        "description": o.description,
        "description_html": o.description_html,
        "display_name": o.display_name,
        "flair_templates": _serialize_subreddit_flair_templates(o.flair.templates),
        "id": o.id,
        "name": o.name,
        "over18": o.over18,
        "public_description": o.public_description,
        "spoilers_enabled": o.spoilers_enabled,
        "subscribers": o.subscribers,
    }

def _serialize_redditor(o: praw.models.Redditor):
    # https://praw.readthedocs.io/en/stable/code_overview/models/redditor.html
    return {
        "comment_karma": o.comment_karma,
        "created_utc": o.created_utc,
        "has_verified_email": o.has_verified_email,
        "icon_img": o.icon_img,
        "id": o.id,
        "is_employee": o.is_employee,
        "is_mod": o.is_mod,
        "is_gold": o.is_gold,
        "name": o.name,
    }

def _serialize_rule(o: praw.models.Rule):
    # https://praw.readthedocs.io/en/stable/code_overview/other/rule.html
    return {
        "created_utc": o.created_utc,
        "description": o.description,
        "kind": o.kind,
        "priority": o.priority,
        "short_name": o.short_name,
        "violation_reason": o.violation_reason,
    }

def _serialize_removal_reason(o: praw.models.RemovalReason):
    # https://praw.readthedocs.io/en/stable/code_overview/other/removalreason.html
    return {
        "id": o.id,
        "message": o.message,
        "title": o.title,
    }

def _serialize_poll_option(o: praw.models.PollOption):
    # https://praw.readthedocs.io/en/stable/code_overview/other/polloption.html
    return {
        "id": o.id,
        "text": o.text,
        "vote_count": o.vote_count,
    }

def _serialize_poll_data(o: praw.models.PollData):
    # https://praw.readthedocs.io/en/stable/code_overview/other/polldata.html
    return {
        "options": [serialize(option) for option in o.options],
        "total_vote_count": o.total_vote_count,
        "voting_end_timestamp": o.voting_end_timestamp,
    }

def _serialize_subreddit_flair_templates(o: praw.models.reddit.subreddit.SubredditRedditorFlairTemplates):
    # https://praw.readthedocs.io/en/stable/code_overview/other/subredditredditorflairtemplates.html
    templates = []
    for template in o:
        templates.append(_serialize_subreddit_flair_template(template))
    return templates

def _serialize_subreddit_flair_template(o: dict):
    return o
