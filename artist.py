from dataclasses import dataclass
from uuid import UUID as uuid
from PIL.Image import Image


@dataclass
class Artist:
    id: uuid
    number_of_albums: int
    is_active: bool
    cover_url: str | Image
