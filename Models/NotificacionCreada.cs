namespace Swappit.Models;

// Notificación que se acaba de insertar en la tabla Notificaciones (ver BD.CrearNotificacion).
// BD la devuelve recién después del Commit, para que el controller mande el mail solo si quedó guardada.
public record NotificacionCreada(int IdUsuario, int IdIntercambio, string Tipo);
