from dataclasses import dataclass
from datetime import datetime
from uuid import UUID as uuid
from PIL.Image import Image


@dataclass
class Track:
    id: uuid
    no_on_album: int
    title: str
    album: str
    duration: int
    genres: list
    is_single: bool
    is_live: bool
    artists: str | list
    relase_date: datetime
    language: str
    cover_url: str | Image
