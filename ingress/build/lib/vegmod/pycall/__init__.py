"""
vegmod.pycall exposes simple functions that can be called from the Ruby language.
Each function must only accept and return simple types (numeric, string, arrays, hashes, etc.)
"""
from vegmod import reddit

def comment_delete(comment_id : str) -> None:
    """
    Delete a comment by ID.
    """
    return reddit.comment(comment_id).delete()

def comment_edit(comment_id : str, body : str) -> None:
    """
    Edit a comment by ID.
    """
    return reddit.comment(comment_id).edit(body)

def comment_mod_approve(comment_id : str) -> None:
    """
    Approve a comment by ID.
    """
    return reddit.comment(comment_id).mod.approve()

def comment_mod_note(comment_id : str, note : str) -> None:
    """
    Create a mod note on a comment.
    """
    return reddit.comment(comment_id).mod.note(note)

def comment_mod_distinquish(comment_id : str, how : str = 'yes', sticky: bool = False) -> None:
    """
    Distinguish a comment by ID.
    
    how can be "yes", "no", "admin", or "special".
    """
    return reddit.comment(comment_id).mod.distinguish(how=how, sticky=sticky)

def comment_mod_ignore_reports(comment_id : str) -> None:
    """
    Ignore reports on a comment.
    """
    return reddit.comment(comment_id).mod.ignore_reports()

def comment_mod_lock(comment_id : str) -> None:
    """
    Lock a comment by ID.
    """
    return reddit.comment(comment_id).mod.lock()

def comment_mod_remove(comment_id : str, mod_note : str = '', spam: bool = False, reason_id: str | None = None) -> None:
    """
    Remove a comment by ID.
    """
    return reddit.comment(comment_id).mod.remove(mod_note=mod_note, spam=spam, reason_id=reason_id)

def comment_mod_send_removal_message(comment_id : str, message: str) -> None:
    """
    Send a removal message to the author of a comment.
    """
    return reddit.comment(comment_id).mod.send_removal_message(message=message)

def comment_mod_undistinguish(comment_id : str) -> None:
    """
    Undistinguish a comment by ID.
    """
    return reddit.comment(comment_id).mod.undistinguish()

def comment_mod_unignore_reports(comment_id : str) -> None:
    """
    Unignore reports on a comment.
    """
    return reddit.comment(comment_id).mod.unignore_reports()

def comment_mod_unlock(comment_id : str) -> None:
    """
    Unlock a comment by ID.
    """
    return reddit.comment(comment_id).mod.unlock()

def comment_report(comment_id : str, reason : str) -> None:
    """
    Report a comment by ID.
    """
    return reddit.comment(comment_id).report(reason)

def comment_reply(comment_id : str, body : str) -> str:
    """
    Reply to a comment with a reply.
    """
    return reddit.comment(comment_id).reply(body)

def submission_delete(submission_id : str) -> None:
    """
    Delete a submission by ID.
    """
    return reddit.submission(submission_id).delete()

def submission_edit(submission_id : str, body : str) -> None:
    """
    Edit a submission by ID.
    """
    return reddit.submission(submission_id).edit(body)

def submission_mod_approve(submission_id : str) -> None:
    """
    Approve a submission by ID.
    """
    return reddit.submission(submission_id).mod.approve()

def submission_mod_create_note(submission_id : str, label : str, note : str) -> None:
    """
    Create a mod note on a submission.
    """
    return reddit.submission(submission_id).mod.create_note(label=label, note=note)

def submission_mod_distinguish(submission_id : str, how : str = 'yes', sticky: bool = False) -> None:
    """
    Distinguish a submission by ID.
    
    how can be "yes", "no", "admin", or "special".
    """
    return reddit.submission(submission_id).mod.distinguish(how=how, sticky=sticky)

def submission_mod_flair(submission_id : str, flair_template_id : str | None = None, text : str = '') -> None:
    """
    Set the flair on a submission.
    """
    return reddit.submission(submission_id).mod.flair(flair_template_id=flair_template_id, text=text)

def submission_mod_ignore_reports(submission_id : str) -> None:
    """
    Ignore reports on a submission.
    """
    return reddit.submission(submission_id).mod.ignore_reports()

def submission_mod_lock(submission_id : str) -> None:
    """
    Lock a submission by ID.
    """
    return reddit.submission(submission_id).mod.lock()

def submission_mod_nsfw(submission_id : str) -> None:
    """
    Mark a submission as NSFW.
    """
    return reddit.submission(submission_id).mod.nsfw()

def submission_mod_remove(submission_id : str, mod_note : str = '', spam: bool = False, reason_id: str | None = None) -> None:
    """
    Remove a submission by ID.
    """
    return reddit.submission(submission_id).mod.remove(mod_note=mod_note, spam=spam, reason_id=reason_id)

def submission_reply(submission_id : str, body : str) -> str:
    """
    Reply to a submission with a reply.
    """
    return reddit.submission(submission_id).reply(body)

def submission_mod_send_removal_message(submission_id : str, message: str) -> None:
    """
    Send a removal message to the author of a submission.
    """
    return reddit.submission(submission_id).mod.send_removal_message(message=message)

def submission_mod_sfw(submission_id : str) -> None:
    """
    Mark a submission as SFW.
    """
    return reddit.submission(submission_id).mod.sfw()

def submission_mod_spoiler(submission_id : str) -> None:
    """
    Mark a submission as a spoiler.
    """
    return reddit.submission(submission_id).mod.spoiler()

def submission_mod_sticky(submission_id : str, bottom: bool = True, state: bool = True) -> None:
    """
    Sticky a submission by ID.
    """
    return reddit.submission(submission_id).mod.sticky(bottom=bottom, state=state)

def submission_mod_suggested_sort(submission_id : str, sort : str = 'blank') -> None:
    """
    Set the suggested sort on a submission.
    """
    return reddit.submission(submission_id).mod.suggested_sort(sort=sort)

def submission_mod_undistinguish(submission_id : str) -> None:
    """
    Undistinguish a submission by ID.
    """
    return reddit.submission(submission_id).mod.undistinguish()

def submission_mod_unignore_reports(submission_id : str) -> None:
    """
    Unignore reports on a submission.
    """
    return reddit.submission(submission_id).mod.unignore_reports()

def submission_mod_unlock(submission_id : str) -> None:
    """
    Unlock a submission by ID.
    """
    return reddit.submission(submission_id).mod.unlock()

def submission_mod_unspoiler(submission_id : str) -> None:
    """
    Unmark a submission as a spoiler.
    """
    return reddit.submission(submission_id).mod.unspoiler()

def submission_mod_update_crowd_control_level(submission_id : str, level : int) -> None:
    """
    Update the crowd control level on a submission.
    """
    return reddit.submission(submission_id).mod.update_crowd_control_level(level=level)

def submission_report(submission_id : str, reason : str) -> None:
    """
    Report a submission by ID.
    """
    return reddit.submission(submission_id).report(reason)