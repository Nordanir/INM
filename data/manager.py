from sqlalchemy import create_engine

from track import Track


engine = create_engine("postgresql://postres:admin@192.168.56.1:5432/imn")


def add_track(track: Track): ...
