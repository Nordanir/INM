from ast import In
from importlib import metadata
from re import M
from sqlalchemy import (
    BLOB,
    Boolean,
    Column,
    Date,
    Integer,
    Interval,
    MetaData,
    SmallInteger,
    Text,
    Table,
    create_engine,
)


engine = create_engine("postgresql://postgres:admin@192.168.56.1:5432/inm")
meta_data = MetaData()
meta_data.reflect(bind=engine)
artist = meta_data.tables["Artist"]

albums = Table(
    "Album",
    meta_data,
    Column("id", SmallInteger, primary_key=True),
    Column("title", Text),
    Column("number_of_tracks", SmallInteger),
    Column("cover", BLOB),
)

albums_of_artist = Table(
    "Albums_of",
    meta_data,
    Column("artist_id", Integer, primary_key=True),
    Column("album_id", Integer, primary_key=True),
)

artists = Table(
    "Artist",
    meta_data,
    Column("id", Integer, primary_key=True),
    Column("number_of_albums"),
    Column("is_active", Boolean),
    Column(
        "cover",
        BLOB,
    ),
)
genre = Table(
    "Genre",
    meta_data,
    Column("genre_id", SmallInteger, primary_key=True),
    Column("gname", Text),
)
genre_of = Table(
    "Genre-of",
    meta_data,
    Column("genre_id", SmallInteger, primary_key=True),
    Column("entity_id", Integer, primary_key=True),
)
playlist = Table(
    "Playlist",
    meta_data,
    Column("id", Integer, primary_key=True),
    Column("number_of_tracks", SmallInteger),
    Column("creation_date", Date),
    Column("cover", BLOB),
)
track = Table(
    "Track",
    meta_data,
    Column("id", Integer, primary_key=True),
    Column("place_on_the_album", Integer),
    Column("title", Text),
    Column("album_id", Integer, primary_key=True),
    Column("duration", Interval),
    Column("is_a_single", Boolean),
    Column("is_an_album", Boolean),
    Column("cover", BLOB),
)
track_of_playlist = Table(
    "Tracks_of_playlist",
    meta_data,
    Column("playlist_id", Integer, primary_key=True),
    Column("track_id", Integer, primary_key=True),
)
