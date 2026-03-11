import csv

class Pelicula:
    def __init__(self, title, genres, poster_path):
        self.title = title
        self.genres = genres
        self.poster_path = poster_path

    def __str__(self):
        return f"Título: {self.title}\nGéneros: {self.genres}\nPoster: {self.poster_path}\n"


def cargar_peliculas(n):
    peliculas = []

    with open("scripts\movies.csv", newline='', encoding='latin-1') as archivo:
        lector = csv.DictReader(archivo, delimiter=';')

        for i, fila in enumerate(lector):
            if i >= n:
                break

            pelicula = Pelicula(
                fila["title"],
                fila["genres"],
                "https://image.tmdb.org/t/p/w300_and_h450_face"+fila["poster_path"]
            )

            peliculas.append(pelicula)

    return peliculas


def main():
    n = int(input("¿Cuántas películas quieres cargar? "))

    peliculas = cargar_peliculas(n)

    print("\nPelículas cargadas:\n")
    for p in peliculas:
        print(p)


if __name__ == "__main__":
    main()