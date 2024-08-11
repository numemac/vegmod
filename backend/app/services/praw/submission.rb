require 'pycall'

class Praw::Submission

  def initialize(submission)
    @praw = PyCall.import_module('vegmod.pycall')
    @submission = submission
    @id = submission.external_id
  end

  def delete
    Reddit::PrawLog.create!(action: "delete", context: @submission)
    @praw.submission_delete(@id)
  end

  def edit(body)
    Reddit::PrawLog.create!(action: "edit", context: @submission)
    @praw.submission_edit(@id, body)
  end

  def approve
    Reddit::PrawLog.create!(action: "approve", context: @submission)
    @praw.submission_mod_approve(@id)
  end

  def note(label, note)
    Reddit::PrawLog.create!(action: "note", context: @submission)
    @praw.submission_mod_create_note(@id, label, note)
  end

  def distinguish(how, sticky)
    Reddit::PrawLog.create!(action: "distinguish", context: @submission)
    @praw.submission_mod_distinquish(@id, how, sticky)
  end

  def flair(flair_template_id, text)
    Reddit::PrawLog.create!(action: "flair", context: @submission)
    @praw.submission_mod_flair(@id, flair_template_id, text)
  end

  def ignore_reports
    Reddit::PrawLog.create!(action: "ignore_reports", context: @submission)
    @praw.submission_mod_ignore_reports(@id)
  end

  def lock
    Reddit::PrawLog.create!(action: "lock", context: @submission)
    @praw.submission_mod_lock(@id)
  end

  def nsfw
    Reddit::PrawLog.create!(action: "nsfw", context: @submission)
    @praw.submission_mod_nsfw(@id)
  end

  def remove(mod_note, spam, reason_id)
    Reddit::PrawLog.create!(action: "remove", context: @submission)
    @praw.submission_mod_remove(@id, mod_note&.truncate(100), spam, reason_id)
  end

  def reply(body)
    Reddit::PrawLog.create!(action: "reply", context: @submission)
    @praw.submission_reply(@id, body)
  end

  def send_removal_message(message)
    Reddit::PrawLog.create!(action: "send_removal_message", context: @submission)
    @praw.submission_mod_send_removal_message(@id, message)
  end

  def sfw
    Reddit::PrawLog.create!(action: "sfw", context: @submission)
    @praw.submission_mod_sfw(@id)
  end

  def spoiler
    Reddit::PrawLog.create!(action: "spoiler", context: @submission)
    @praw.submission_mod_spoiler(@id)
  end

  def sticky(bottom, state)
    Reddit::PrawLog.create!(action: "sticky", context: @submission)
    @praw.submission_mod_sticky(@id, bottom, state)
  end

  def suggested_sort(sort)
    Reddit::PrawLog.create!(action: "suggested_sort", context: @submission)
    @praw.submission_mod_suggested_sort(@id, sort)
  end

  def undistinguish
    Reddit::PrawLog.create!(action: "undistinguish", context: @submission)
    @praw.submission_mod_undistinguish(@id)
  end

  def unignore_reports
    Reddit::PrawLog.create!(action: "unignore_reports", context: @submission)
    @praw.submission_mod_unignore_reports(@id)
  end

  def unlock
    Reddit::PrawLog.create!(action: "unlock", context: @submission)
    @praw.submission_mod_unlock(@id)
  end

  def unspoiler
    Reddit::PrawLog.create!(action: "unspoiler", context: @submission)
    @praw.submission_mod_unspoiler(@id)
  end

  def update_crowd_control_level(level)
    Reddit::PrawLog.create!(action: "update_crowd_control_level", context: @submission)
    @praw.submission_mod_update_crowd_control_level(@id, level)
  end

  def report(reason)
    Reddit::PrawLog.create!(action: "report", context: @submission)
    @praw.submission_report(@id, reason)
  end

end