# HackingBook

Práctica de iOS Fundamentos KeepCoding

## Respuestas

Ten en cuenta que dicho método devuelve un id que puede contener tanto un NSArray de NSDictionaries como un NSDictionary . Mira en la ayuda en método isKindOfClass: y como usarlo para saber qué te han devuelto exactamente. ¿Qué otros métodos similareshay? ¿En qué se distingue isMemberOfClass: ?

>Tambien hay isKindOfClass la diferencia es que isMemberOfClass verifica que la clase sea la misam mientras que isKindOfClass veridica si es la misma o cualqueir clase que hereda de la misma.

El ser o no favorito se indicará mediante una propiedad booleana de AGTBook( isFavorite ) y esto se debe de guardar en el sistema de ficheros y recuperar de alguna forma. Es decir, esa información debe de persistir de alguna manera cuando se cierra la App y cuando se abre.¿Cómo harías eso? ¿Se te ocurre más de una forma de hacerlo? Explica la decisión de diseño que hayas tomado.

>Lo guardaria en NSDefaultUser para poder recueperarlo como objetos directamente. Se puede guardar en los eventos de inicio y cierre de la app, pero creo que es mejor persistir los cambios cuando se realice ese mirmo momento si no son muy comunes , de otra forma cuando se pone la app en segundo plano ya que esta puede ser cerrada por el SO. 

Cuando cambia el valor de la propiedad isFavorite de un AGTBook, la tabla deberá reflejar ese hecho. ¿Cómo lo harías? Es decir, ¿cómo enviarías información de un AGTBook a un AGTLibraryTableViewController? ¿Se te ocurre más de una forma de hacerlo? ¿Cual te parece mejor? Explica tu elección.

> Se puede hacer por notificaciones o por delegado, lo realice por notidicaciones y no por delegado ya que ya se tiene un delegado de la tabla hacia el view controller del controlador de la vista del libro.

Nota: para que la tabla se actualice, usa el método reloadData de UITableView . Esto hace que la tabla vuelva a pedir datos a su dataSource. ¿Es esto una aberración desde el punto de rendimiento (volver a cargar datos que en su mayoría ya estaban correctos)? Explica por qué no es así. ¿Hay una forma alternativa? ¿Cuando crees que vale la pena usarlo?

> Por que se modifica la seccion de favoritos es necesario actualizar la tabla, se podria hacer solo la actualizacion de la secion 0 que vendria a ser de favoritos.

Cuando el usuario cambia en la tabla el libro seleccionado, el AGTSimplePDFViewController debe de actualizarse. ¿Cómo lo harías?

## Respuestas


Estaba realizando los cambios para la carga por debajo de los todos los archivos json, imagenes, pdf. por lo que la primera vez no aparece nada me falto crear los eventos que actualicen las eventos cuando terminen de descargar y modificar las vistas para avisar que se esta descargando.