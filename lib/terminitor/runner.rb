module Terminitor
  module Runner

    # opens doc in system designated editor
    def open_in_editor(path, editor=nil)
      editor = editor || ENV['TERM_EDITOR'] || ENV['EDITOR']
      say "please set $EDITOR or $TERM_EDITOR in your .bash_profile." unless editor
      system("#{editor || 'open'} #{path}")
    end

    # returns path to file
    def resolve_path(project)
      unless project.empty?
        path = config_path(project, :yaml) # Give old yml path
        return path if File.exists?(path)
        path = config_path(project, :term) # Give new term path.
        return path if File.exists?(path)
        nil
      else
        path = File.join(options[:root],"Termfile")
        return path if File.exists?(path)
        nil
      end
    end

    # returns first line of file
    def grab_comment_for_file(file)
      first_line = File.readlines(file).first
      first_line =~ /^\s*?#/ ? ("-" + first_line.gsub("#","")) : "\n"
    end

    # Return file in config_path
    def config_path(file, type = :yaml)
      return File.join(options[:root],"Termfile") if file.empty?
      dir = File.join(ENV['HOME'],'.terminitor')
      if type == :yaml
        File.join(dir, "#{file.sub(/\.yml$/, '')}.yml")
      else
        File.join(dir, "#{file.sub(/\.term$/, '')}.term")
      end
    end


  end
end
