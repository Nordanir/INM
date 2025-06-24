from dataclasses import dataclass
from wand.image import Image as BlobImage
from PIL.Image import Image


@dataclass
class Artist:
    id: int
    number_of_albums: int
    is_active: bool
    cover: BlobImage | Image
