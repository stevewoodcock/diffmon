atom_feed do |feed|
  feed.title("Diffmon")
  feed.updated(@urls.first.last_modified)

  for url in @urls
    feed.entry(url) do |entry|
      entry.title(url.url)
      entry.content(url.diff)
    end
  end
end
      
