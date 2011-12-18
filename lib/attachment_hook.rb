require 'account_controller'
require 'ftools'

module AttachScreenshotPlugin
  class Hooks < Redmine::Hook::ViewListener
    
    # Hook called from Issue.save_issue_with_child_records
    def controller_issues_edit_before_save (context ={})
      issue = context[:issue]
      journal = context[:journal]  # nil if this was invoked from controller_issues_new_after_save (below)
      params = context[:params]
      
      unsaved = 0
      screenshots = params[:screenshots]
      if screenshots && screenshots.is_a?(Hash)
        screenshot_count = 0
        screenshots.each_pair do |key, screenshot|
          screenshot_count += 1
          key = key.gsub("thumb", "screenshot")
          path = "/tmp/" + key
          file = File.open(path, "rb")

          unless file && File.size(path) > 0
            unsaved += 1
            next
          end

          def file.content_type
            "image/png"
          end
          def file.size
            File.size(path())
          end
          def file.original_filename
            File.basename(path())
          end
          
          a = Attachment.create(:container => issue,
                                :file => file,
                                :description => screenshot['description'].to_s.strip,
                                :author => User.current)
          file.close()
          File.delete(path)
          key = key.gsub("screenshot", "thumb")
          path = "/tmp/" + key
          begin
            File.delete(path)
          rescue
          end
          if a.new_record?
            unsaved += 1
          else
            if journal
              journal.details << JournalDetail.new(:property => 'attachment',
                                                   :prop_key => a.id,
                                                   :value => a.filename)
              journal[:notes] = journal[:notes].gsub("!" + key + "!", "!" + url_for (:controller => 'attachments', :id=> a, :filename => a.filename, :action => "show" ) +"!")
            else
              issue[:description] = issue[:description].gsub("!" + key + "!", "!" + url_for (:controller => 'attachments', :id=> a, :filename => a.filename, :action => "show" ) +"!")
              issue.save()
            end
          end
        end
        if unsaved > 0
          flash[:warning] = l(:warning_attachments_not_saved, unsaved)
        end
      end
    end
    
    # Hook called from IssuesController.create
    def controller_issues_new_after_save (context ={})
      controller_issues_edit_before_save(context)
    end
    
  end
end
