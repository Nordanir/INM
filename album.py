from dataclasses import dataclass
from datetime import timedelta
from track import Track
from wand.image import Image as BlobImage
from PIL.Image import Image


@dataclass
class Album:
    id: int
    title: str
    duration: timedelta
    tracks: Track | list[Track]
    genres: str | list
    number_of_tracks: int
    artists: str | list
    language: str
    cover: BlobImage | Image
