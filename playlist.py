from dataclasses import dataclass
from PIL.Image import Image
from track import Track
from datetime import datetime
from uuid import UUID as uuid


@dataclass
class Playlist:
    id: uuid
    number_of_songs: int
    title: str
    creation_date: datetime
    tracks: list[Track]
    cover: str | Image
