from dataclasses import dataclass
from uuid import UUID as uuid
from track import Track
from PIL.Image import Image


@dataclass
class Album:
    id: uuid
    title: str
    duration: int
    tracks: Track | list[Track]
    genres: str | list
    number_of_tracks: int
    artists: str | list
    language: str
    cover_url: str | Image
