#HackerBooksLite
Práctica para el módulo de iOS Avanzado en la cual he usado Realm como base de datos.

##Bugs
* La sección de favoritos no puedo mostrarla por una limitación de Realm que si elimino un libro del Tag "Favoritos" lo borra en la base de datos y por lo tanto de los demás tags
* Al borrar una nota da un error por las celdas del collectionView a pesar de recargar la collectionView, al igual que al añadir la sección "Último libro leído" la primera vez que se lee un libro, tambien da el mismo error pero, al reiniciar la app, en el primer caso se ha borrado la nota correctamente y ya no aparece, y en el segundo aparece la sección "Último libro leído" correctamente y se actualiza sin problemas al leer un libro.
* La pantalla para mostrar la nota en el mapa no usa el MKAnnotation porque Realm no admite MKAnnotation y tendría que hacerlo instalando un pod mediante CocoaPods pero no funciona bien con Xcode 8.
