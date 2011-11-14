class Song
  attr_reader :name, :artist, :genre, :subgenre, :tags
  
  def initialize(name, artist, genre, subgenre, tags)
    @name, @artist, @genre, @subgenre  = name, artist, genre, subgenre
    @tags = tags
  end
  
  def matches_tag?(tag)
    tag.end_with?("!") ^ @tags.include?(tag.chomp "!")
  end
  
  def matches?(criteria)
    criteria.all? do |type, value|
      case type
        when :name then name == value
        when :artist then artist == value
        when :filter then value.(self)
        when :tags then Array(value).all? { |tag| matches_tag? tag }
      end
    end
  end
end

class CollectionParser
  def initialize(songs_string)
    @songs = songs_string.lines.map { |song| song.split(".").map(&:strip) }
  end
  
  def songs(artist_tags)
    @songs.map do |name, artist, genres_string, tags_string|
      genre, subgenre = genres_string.split(",").map(&:strip)
      tags = artist_tags.fetch(artist, [])
      tags += [genre, subgenre].compact.map(&:downcase)
      tags += tags_string.split(",").map(&:strip) unless tags_string.nil?
      
      Song.new(name, artist, genre, subgenre, tags)
    end
  end
end

class Collection
  def initialize(songs_string, artist_tags)
    @collection = CollectionParser.new(songs_string).songs(artist_tags)
  end
  
  def find(criteria)
    @collection.select { |song| song.matches?(criteria) }
  end
end