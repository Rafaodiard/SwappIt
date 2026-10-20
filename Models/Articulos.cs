using System;

namespace Swappit.Models
{
    public class Articulos
    {
        public int Id { get; set; }
        public string Titulo { get; set; } = string.Empty;
        public string Descripcion { get; set; } = string.Empty;
        public string ImagenUrl { get; set; } = string.Empty;
        public DateTime FechaPublicacion { get; set; } = DateTime.Now;

        // Relaciones
        public int? CategoriaId { get; set; }
        public Categorias? Categoria { get; set; }

        public int? ProvinciaId { get; set; }
        public Provincias? Provincia { get; set; }

        public int? UsuarioId { get; set; }
        public Usuarios? Usuario { get; set; }
    }
}