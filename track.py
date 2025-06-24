from dataclasses import dataclass
from datetime import timedelta, datetime
from wand.image import Image as BlobImage
from PIL.Image import Image


@dataclass
class Track:
    id: int
    no_on_album: int
    title: str
    album: str
    duration: timedelta
    genres: list
    is_single: bool
    is_live: bool
    artists: str | list
    relase_date: datetime
    language: str
    cover: BlobImage | Image
