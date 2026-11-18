using Swappit.Models.ViewModels;

namespace Swappit.Models;

public static class GestionIntercambios
{
    public static bool EstaEnCurso(string estado)
    {
        return estado == EstadosIntercambios.Pendiente || estado == EstadosIntercambios.Aceptado;
    }

    public static ResumenEnCurso ContarEnCurso(int idUsuario)
    {
        ResumenEnCurso resumen = new ResumenEnCurso();
        foreach (CantidadPorEstado c in IntercambiosBD.ContarIntercambiosPorEstado(idUsuario))
        {
            if (EstaEnCurso(c.Estado))
            {
                resumen.Cantidad += c.Cantidad;
                resumen.PorResponder += c.PorResponder;
            }
        }
        return resumen;
    }

    // ---------- Mis intercambios ----------

    public static string? EstadoValido(List<EstadosIntercambios> estados, string? estado)
    {
        foreach (EstadosIntercambios e in estados)
        {
            if (e.Nombre == estado)
            {
                return estado;
            }
        }
        return null;
    }

    public static List<FiltroEstadoViewModel> FiltrosPorEstado(int idUsuario, List<EstadosIntercambios> estados, string? estadoElegido, out int total)
    {
        Dictionary<string, int> cantidadPorEstado = new Dictionary<string, int>();
        total = 0;
        foreach (CantidadPorEstado c in IntercambiosBD.ContarIntercambiosPorEstado(idUsuario))
        {
            cantidadPorEstado[c.Estado] = c.Cantidad;
            total += c.Cantidad;
        }

        List<FiltroEstadoViewModel> filtros = new List<FiltroEstadoViewModel>();
        filtros.Add(new FiltroEstadoViewModel { Texto = "Todos", Cantidad = total, Elegido = estadoElegido == null });
        foreach (EstadosIntercambios e in estados)
        {
            filtros.Add(new FiltroEstadoViewModel
            {
                Nombre = e.Nombre,
                Texto = $"{e.Nombre}s",
                Cantidad = cantidadPorEstado.GetValueOrDefault(e.Nombre ?? ""),
                Elegido = e.Nombre == estadoElegido
            });
        }
        return filtros;
    }

    // ---------- Proponer ----------

    public static Resultado Proponer(int idUsuario, int idArticuloPedido, int[]? idsArticulosOfrecidos)
    {
        Articulos? pedido = ArticulosBD.GetArticuloById(idArticuloPedido);
        if (pedido == null)
        {
            return new Resultado { NoExiste = true };
        }

        List<int> idsOfrecidos = Listas.IdsValidos(idsArticulosOfrecidos);
        string? error = ValidarPropuesta(idUsuario, pedido, idsOfrecidos);
        if (error != null)
        {
            return Resultado.ConError(error);
        }

        Resultado resultado = new Resultado();
        resultado.Id = IntercambiosBD.ProponerIntercambio(idUsuario, idsOfrecidos, pedido.IdUsuarios, idArticuloPedido, resultado.Notificaciones);
        if (resultado.Id == null)
        {
            resultado.Error = "Ya tenés una propuesta en curso por este artículo.";
        }
        else
        {
            resultado.Mensaje = "¡Listo! Enviaste tu propuesta. Cuando la respondan, la vas a ver acá.";
        }
        return resultado;
    }

    private static string? ValidarPropuesta(int idUsuario, Articulos pedido, List<int> idsOfrecidos)
    {
        if (pedido.IdUsuarios == idUsuario)
        {
            return "No podés proponer un intercambio por un artículo tuyo.";
        }
        if (idsOfrecidos.Count == 0)
        {
            return "Elegí al menos uno de tus artículos para ofrecer a cambio.";
        }
        if (idsOfrecidos.Count > Intercambios.MaxArticulosOfrecidos)
        {
            return $"Podés ofrecer hasta {Intercambios.MaxArticulosOfrecidos} artículos en una propuesta.";
        }
        if (!SonDelUsuario(idsOfrecidos, idUsuario))
        {
            return "Solo podés ofrecer artículos tuyos.";
        }
        PlanViewModel? plan = PlanesBD.GetPlanDeUsuario(idUsuario);
        if (plan == null)
        {
            return "No pudimos revisar tu plan. Probá de nuevo en un rato.";
        }
        if (plan.MaxIntercambios != null && Suscripciones.AlcanzoLimite(IntercambiosBD.ContarIntercambiosActivos(idUsuario), plan.MaxIntercambios))
        {
            return $"Con el plan {plan.Nombre} podés tener hasta {plan.MaxIntercambios} intercambios activos propuestos por vos. Cuando uno se resuelva, podés hacer otro, o cambiá de plan para tener más.";
        }
        if (IntercambiosBD.ArticuloComprometido(pedido.IdArticulos))
        {
            return "Este artículo ya tiene un intercambio aceptado.";
        }
        if (AlgunoComprometido(idsOfrecidos))
        {
            return idsOfrecidos.Count == 1
                ? "El artículo que elegiste ya tiene un intercambio aceptado. Elegí otro."
                : "Uno de los artículos que elegiste ya tiene un intercambio aceptado. Sacalo y probá de nuevo.";
        }
        return null;
    }

    private static bool SonDelUsuario(List<int> idsArticulos, int idUsuario)
    {
        foreach (int idArticulo in idsArticulos)
        {
            if (ArticulosBD.GetArticuloById(idArticulo)?.IdUsuarios != idUsuario)
            {
                return false;
            }
        }
        return true;
    }

    private static bool AlgunoComprometido(List<int> idsArticulos)
    {
        foreach (int idArticulo in idsArticulos)
        {
            if (IntercambiosBD.ArticuloComprometido(idArticulo))
            {
                return true;
            }
        }
        return false;
    }

    // ---------- Estado del intercambio ----------

    public static Resultado Aceptar(int idIntercambio, int idUsuario, int ultimoCambio)
    {
        IntercambioViewModel? intercambio = IntercambiosBD.GetIntercambio(idIntercambio, idUsuario);
        if (intercambio != null)
        {
            if (IntercambiosBD.ContarCambiosPendientes(idIntercambio, idUsuario, soloDelOtro: true) > 0)
            {
                return Resultado.ConError($"Respondé los cambios de {intercambio.OtroNombre} antes de aceptar.");
            }
            if (IntercambiosBD.GetUltimoCambio(idIntercambio) > ultimoCambio)
            {
                return Resultado.ConError($"{intercambio.OtroNombre} cambió el intercambio mientras lo mirabas. Revisalo y aceptá de nuevo.");
            }
        }

        string mensaje = "Aceptaste el intercambio. Ahora coordinen dónde y cuándo hacerlo.";
        int pendientes = IntercambiosBD.ContarPendientesDeArticulos(idIntercambio);
        if (pendientes > 0)
        {
            mensaje += pendientes == 1
                ? " Se rechazó automáticamente otra propuesta que incluía estos artículos."
                : $" Se rechazaron automáticamente otras {pendientes} propuestas que incluían estos artículos.";
        }
        return CambiarEstado(idIntercambio, idUsuario, EstadosIntercambios.Pendiente, EstadosIntercambios.Aceptado, soloQuienRecibe: true,
            TipoNotificaciones.PropuestaAceptada, mensaje, ultimoCambio);
    }

    public static Resultado Rechazar(int idIntercambio, int idUsuario)
    {
        return CambiarEstado(idIntercambio, idUsuario, EstadosIntercambios.Pendiente, EstadosIntercambios.Rechazado, soloQuienRecibe: true,
            TipoNotificaciones.PropuestaRechazada, "Rechazaste la propuesta.");
    }

    public static Resultado MarcarRealizado(int idIntercambio, int idUsuario)
    {
        if (IntercambiosBD.ContarCambiosPendientes(idIntercambio, idUsuario) > 0)
        {
            return Resultado.ConError("Hay cambios sin responder. Respondelos o cancelalos antes de marcarlo como realizado.");
        }
        return CambiarEstado(idIntercambio, idUsuario, EstadosIntercambios.Aceptado, EstadosIntercambios.Realizado, soloQuienRecibe: false,
            tipoNotificacion: null, "¡Intercambio realizado!");
    }

    public static Resultado Cancelar(int idIntercambio, int idUsuario)
    {
        Resultado resultado = new Resultado();
        if (IntercambiosBD.CancelarIntercambio(idIntercambio, idUsuario, resultado.Notificaciones))
        {
            resultado.Mensaje = "Cancelaste el intercambio. Le avisamos a la otra persona.";
        }
        else
        {
            resultado.Error = "No se pudo cancelar el intercambio. Puede que ya haya cambiado de estado.";
        }
        return resultado;
    }

    private static Resultado CambiarEstado(int idIntercambio, int idUsuario, string estadoActual, string estadoNuevo, bool soloQuienRecibe,
        string? tipoNotificacion, string mensaje, int? ultimoCambioVisto = null)
    {
        Resultado resultado = new Resultado();
        if (IntercambiosBD.CambiarEstadoIntercambio(idIntercambio, idUsuario, estadoActual, estadoNuevo, soloQuienRecibe, tipoNotificacion,
            resultado.Notificaciones, ultimoCambioVisto))
        {
            resultado.Mensaje = mensaje;
        }
        else
        {
            resultado.Error = "No se pudo actualizar el intercambio. Puede que ya haya cambiado de estado.";
        }
        return resultado;
    }

    // ---------- Cambios de un intercambio ----------

    public static Resultado AgregarArticulos(int idIntercambio, int idUsuario, int[]? idsArticulos)
    {
        List<int> ids = Listas.IdsValidos(idsArticulos);
        List<string> nombres = new List<string>();
        return HacerCambio(idIntercambio, idUsuario, c =>
        {
            if (ids.Count == 0)
            {
                return "Elegí al menos uno de tus artículos para agregar.";
            }
            if (c.Confirmados(c.IdUsuario) + c.PendientesDe(c.IdUsuario, TipoCambios.Pedir) + ids.Count > Intercambios.MaxArticulosOfrecidos)
            {
                return $"Cada lado puede tener hasta {Intercambios.MaxArticulosOfrecidos} artículos.";
            }
            nombres.Clear();
            foreach (int idArticulo in ids)
            {
                Articulos? elegido = ArticulosBD.GetArticuloById(idArticulo);
                if (elegido == null || elegido.IdUsuarios != c.IdUsuario)
                {
                    return "Solo podés agregar artículos tuyos.";
                }
                nombres.Add(elegido.Nombre ?? "");
            }
            foreach (int idArticulo in ids)
            {
                if (c.EnJuego(idArticulo))
                {
                    return "Ese artículo ya está en el intercambio o tiene un cambio pendiente.";
                }
            }
            if (AlgunoComprometido(ids))
            {
                return "Uno de los artículos ya tiene un intercambio aceptado. Elegí otro.";
            }
            return null;
        }, (c, creadas) => IntercambiosBD.AgregarArticulos(idIntercambio, c.IdUsuario, ids, creadas) > 0
            ? $"Sumaste {Listas.UnirNombres(nombres)}. A {c.Intercambio.OtroNombre} le llegó un aviso."
            : null);
    }

    public static Resultado PedirArticulo(int idIntercambio, int idUsuario, int idArticulo)
    {
        Articulos? articulo = null;
        return HacerCambio(idIntercambio, idUsuario, c =>
        {
            articulo = ArticulosBD.GetArticuloById(idArticulo);
            if (articulo == null || articulo.IdUsuarios != c.Intercambio.OtroIdUsuario)
            {
                return $"Solo podés pedir artículos de {c.Intercambio.OtroNombre}.";
            }
            if (c.EnJuego(idArticulo))
            {
                return "Ese artículo ya está en el intercambio o tiene un cambio pendiente.";
            }
            if (c.Confirmados(articulo.IdUsuarios) + c.PendientesDe(articulo.IdUsuarios, TipoCambios.Pedir) >= Intercambios.MaxArticulosOfrecidos)
            {
                return $"Cada lado puede tener hasta {Intercambios.MaxArticulosOfrecidos} artículos.";
            }
            if (IntercambiosBD.ArticuloComprometido(idArticulo))
            {
                return "Ese artículo ya tiene un intercambio aceptado. Elegí otro.";
            }
            return null;
        }, (c, creadas) => IntercambiosBD.PedirArticulo(idIntercambio, c.IdUsuario, idArticulo, creadas)
            ? $"Le pediste {articulo!.Nombre} a {c.Intercambio.OtroNombre}. Se suma cuando lo acepte."
            : null);
    }

    public static Resultado SacarArticulo(int idIntercambio, int idUsuario, int idArticulo)
    {
        ArticuloCardViewModel? articulo = null;
        return HacerCambio(idIntercambio, idUsuario, c =>
        {
            articulo = c.Articulo(idArticulo);
            if (articulo == null || articulo.IdUsuarios != c.IdUsuario)
            {
                return "Solo podés sacar artículos tuyos que estén en el intercambio.";
            }
            if (c.PendienteDeArticulo(idArticulo) != null)
            {
                return "Ese artículo ya está en el intercambio o tiene un cambio pendiente.";
            }
            if (c.Confirmados(c.IdUsuario) - c.PendientesDe(c.IdUsuario, TipoCambios.Sacar) < 2)
            {
                return "No podés sacar tu único artículo del intercambio.";
            }
            return null;
        }, (c, creadas) => IntercambiosBD.PedirSacarArticulo(idIntercambio, c.IdUsuario, idArticulo, creadas)
            ? $"Le pediste a {c.Intercambio.OtroNombre} sacar {articulo!.Nombre}. Se saca cuando lo acepte."
            : null);
    }

    public static Resultado ResponderCambio(int idIntercambio, int idUsuario, int idCambio, bool aceptar)
    {
        return HacerCambio(idIntercambio, idUsuario, c =>
        {
            CambioIntercambioViewModel? cambio = c.Pendiente(idCambio);
            if (cambio == null || cambio.IdUsuario == c.IdUsuario)
            {
                return "Ese cambio ya no está pendiente.";
            }
            if (aceptar && cambio.Tipo == TipoCambios.Pedir && IntercambiosBD.ArticuloComprometido(cambio.IdArticulo))
            {
                return $"{cambio.ArticuloNombre} ya tiene otro intercambio aceptado, así que no se puede sumar. Tocá No para cerrar el pedido.";
            }
            return null;
        }, (c, creadas) => IntercambiosBD.ResponderCambio(idCambio, c.IdUsuario, aceptar, creadas)
            ? (aceptar ? "Aceptaste el cambio." : $"Rechazaste el cambio. Le avisamos a {c.Intercambio.OtroNombre}.")
            : null);
    }

    public static Resultado CancelarCambio(int idIntercambio, int idUsuario, int idCambio)
    {
        return HacerCambio(idIntercambio, idUsuario, c => c.Pendiente(idCambio)?.IdUsuario == c.IdUsuario ? null : "Ese pedido ya no está pendiente.",
            (c, creadas) => IntercambiosBD.CancelarCambio(idCambio, c.IdUsuario) ? "Cancelaste el pedido." : null);
    }

    private static Resultado HacerCambio(int idIntercambio, int idUsuario, Func<ContextoCambio, string?> validar,
        Func<ContextoCambio, List<NotificacionCreada>, string?> hacer)
    {
        IntercambioViewModel? intercambio = IntercambiosBD.GetIntercambio(idIntercambio, idUsuario);
        if (intercambio == null)
        {
            return new Resultado { NoExiste = true };
        }
        if (!EstaEnCurso(intercambio.Estado))
        {
            return Resultado.ConError("Este intercambio ya terminó: no se puede cambiar.");
        }

        ContextoCambio contexto = new ContextoCambio(idUsuario, intercambio,
            IntercambiosBD.GetArticulosDeIntercambio(idIntercambio, idUsuario),
            IntercambiosBD.GetCambiosIntercambio(idIntercambio, idUsuario, soloPendientes: true));
        string? error = validar(contexto);
        if (error != null)
        {
            return Resultado.ConError(error);
        }

        Resultado resultado = new Resultado();
        resultado.Mensaje = hacer(contexto, resultado.Notificaciones);
        if (resultado.Mensaje == null)
        {
            resultado.Error = "No se pudo hacer el cambio. Puede que el intercambio haya cambiado: revisalo y probá de nuevo.";
        }
        return resultado;
    }
}
