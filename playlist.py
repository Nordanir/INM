from dataclasses import dataclass
from wand.image import Image as BlobImage
from PIL.Image import Image
from track import Track
from datetime import datetime


@dataclass
class Playlist:
    number_of_songs: int
    creation_date: datetime
    tracks: list[Track]
    cover: BlobImage | Image
