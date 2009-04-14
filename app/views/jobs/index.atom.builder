atom_feed do |feed|
  feed.title("Diffmon")
  feed.updated(@jobs.first.last_modified)

  for job in @jobs
    feed.entry(job) do |entry|
      entry.title(job.url)
      entry.content(job.diff || job.content)
    end
  end
end
