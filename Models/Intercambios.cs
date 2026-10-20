using System;

namespace Swappit.Models
{
    public class Intercambios
    {
        public int Id { get; set; }
        public DateTime FechaCreacion { get; set; } = DateTime.Now;
        public string Estado { get; set; } = "Pendiente"; // Pendiente, Aceptado, Rechazado
        public string? Mensaje { get; set; }

        // Artículos involucrados
        public int ArticuloOfrecidoId { get; set; }
        public Articulos? ArticuloOfrecido { get; set; }

        public int ArticuloSolicitadoId { get; set; }
        public Articulos? ArticuloSolicitado { get; set; }
    }
}