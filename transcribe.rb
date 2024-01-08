require "csv"

def transcribe
  #  shell out to whisper: whisper_timestamped jobs.mp4 --vad True --output_dir ~/code/video-shrinker/output
end

def strip_script_from_csv(csv_file)
  full_script = []

  CSV.foreach(csv_file) do |row|
    full_script << row[0].strip
  end

  File.write("output/full_script.txt", full_script.join(" "))
end

strip_script_from_csv("output/jobs.mp4.csv")
