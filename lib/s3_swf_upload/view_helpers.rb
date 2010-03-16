module S3SwfUpload
  module ViewHelpers
    def s3_swf_upload_tag(options = {})
      height     = options[:height] || 35
      width      = options[:width]  || 300
      success    = options[:success]  || ''
      failed     = options[:failed]  || ''
      selected   = options[:selected]  || ''
      canceled   = options[:canceled] || ''
      prefix     = options[:prefix] || ''
      upload     = options[:upload] || 'Upload' 
      initial_message    = options[:initial_message] || 'Select file to upload...'
      do_checks = options[:do_checks] || "0"

      if do_checks != "1" && do_checks != "0"
        raise "Ooops, do_checks has to be either '0' or '1' (a string)"
      end

      prefix = prefix + "/" unless prefix == ""

      @include_s3_upload ||= false 
      @count ||= 1
      
      out = ""

      if !@include_s3_upload
        out << javascript_include_tag('s3_upload')
        @include_s3_upload = true
      end

      out << %(<a name="uploadform#{@count}"></a>
            <script type="text/javascript">
            var s3_swf#{@count} = s3_swf_init('s3_swf#{@count}', {
              width:  #{width},
              height: #{height},
              initialMessage: '#{initial_message}',
              prefix: '#{prefix}',
              onSuccess: function(filename, filesize, contenttype){
                #{success}
              },
              onFailed: function(status){
                #{failed}
              },
              onFileSelected: function(filename, size, contenttype){
                #{selected}
              },
              onCancel:  function(status){
                #{canceled}
              }
            });
        </script>

        <div id="s3_swf#{@count}">
          Please <a href="http://www.adobe.com/go/getflashplayer">Update</a> your Flash Player to Flash v9.0.1 or higher...
        </div>
      )
      
      @count += 1
      out
    end

  end
end

ActionView::Base.send(:include, S3SwfUpload::ViewHelpers)
