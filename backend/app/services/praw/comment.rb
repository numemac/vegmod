require 'pycall'

class Praw::Comment

  def initialize(comment)
    @praw = PyCall.import_module('vegmod.pycall')
    @comment = comment
    @id = comment.external_id
  end

  def delete
    Reddit::PrawLog.create!(action: "delete", context: @comment)
    @praw.comment_delete(@id)
  end

  def edit(body)
    Reddit::PrawLog.create!(action: "edit", context: @comment)
    @praw.comment_edit(@id, body)
  end

  def approve
    Reddit::PrawLog.create!(action: "approve", context: @comment)
    @praw.comment_mod_approve(@id)
  end

  def note(note)
    Reddit::PrawLog.create!(action: "note", context: @comment)
    @praw.comment_mod_note(@id, note)
  end

  def distinguish(how, sticky)
    Reddit::PrawLog.create!(action: "distinguish", context: @comment)
    @praw.comment_mod_distinquish(@id, how, sticky)
  end

  def ignore_reports
    Reddit::PrawLog.create!(action: "ignore_reports", context: @comment)
    @praw.comment_mod_ignore_reports(@id)
  end

  def lock
    Reddit::PrawLog.create!(action: "lock", context: @comment)
    @praw.comment_mod_lock(@id)
  end

  def remove(mod_note, spam, reason_id)
    Reddit::PrawLog.create!(action: "remove", context: @comment)
    @praw.comment_mod_remove(@id, mod_note, spam, reason_id)
  end

  def send_removal_message(message)
    Reddit::PrawLog.create!(action: "send_removal_message", context: @comment)
    @praw.comment_mod_send_removal_message(@id, message)
  end

  def undistinguish
    Reddit::PrawLog.create!(action: "undistinguish", context: @comment)
    @praw.comment_mod_undistinguish(@id)
  end

  def unignore_reports
    Reddit::PrawLog.create!(action: "unignore_reports", context: @comment)
    @praw.comment_mod_unignore_reports(@id)
  end

  def unlock
    Reddit::PrawLog.create!(action: "unlock", context: @comment)
    @praw.comment_mod_unlock(@id)
  end

  def report(reason)
    Reddit::PrawLog.create!(action: "report", context: @comment)
    @praw.comment_report(@id, reason)
  end

  def reply(body)
    Reddit::PrawLog.create!(action: "reply", context: @comment)
    @praw.comment_reply(@id, body)
  end

end