using Swappit.Models.ViewModels;

namespace Swappit.Models;

public class DetalleIntercambio
{
    private readonly IntercambioViewModel _intercambio;
    private readonly List<CambioIntercambioViewModel> _cambios;
    private readonly List<CambioIntercambioViewModel> _pendientes;
    private readonly bool _puedeCambiar;
    private readonly string _otroNombre;

    private DetalleIntercambio(IntercambioViewModel intercambio, List<CambioIntercambioViewModel> cambios,
        List<CambioIntercambioViewModel> pendientes, bool puedeCambiar)
    {
        _intercambio = intercambio;
        _cambios = cambios;
        _pendientes = pendientes;
        _puedeCambiar = puedeCambiar;
        _otroNombre = intercambio.OtroNombreVisible;
    }

    public static string Titulo(IntercambioViewModel? intercambio)
    {
        return intercambio != null ? $"Intercambio con @{intercambio.OtroUsuario}" : "Intercambio";
    }

    public static DetalleIntercambioViewModel? Armar(int idIntercambio, int idUsuario)
    {
        IntercambioViewModel? intercambio = IntercambiosBD.GetIntercambio(idIntercambio, idUsuario);
        if (intercambio == null)
        {
            return null;
        }

        List<ArticuloCardViewModel> articulos = IntercambiosBD.GetArticulosDeIntercambio(idIntercambio, idUsuario);
        List<ArticuloCardViewModel> mios = new List<ArticuloCardViewModel>();
        List<ArticuloCardViewModel> suyos = new List<ArticuloCardViewModel>();
        foreach (ArticuloCardViewModel a in articulos)
        {
            if (a.IdUsuarios == idUsuario)
            {
                mios.Add(a);
            }
            else
            {
                suyos.Add(a);
            }
        }

        List<CambioIntercambioViewModel> cambios = IntercambiosBD.GetCambiosIntercambio(idIntercambio, idUsuario);
        List<CambioIntercambioViewModel> pendientes = new List<CambioIntercambioViewModel>();
        int ultimoCambio = 0;
        bool tengoPorResponder = false;
        foreach (CambioIntercambioViewModel c in cambios)
        {
            if (c.EsPendiente)
            {
                pendientes.Add(c);
                if (c.IdUsuario != idUsuario)
                {
                    tengoPorResponder = true;
                }
            }
            if (c.Id > ultimoCambio)
            {
                ultimoCambio = c.Id;
            }
        }

        bool puedeCambiar = GestionIntercambios.EstaEnCurso(intercambio.Estado);
        ContextoCambio contexto = new ContextoCambio(idUsuario, intercambio, articulos, pendientes);
        int lugarMio = puedeCambiar ? contexto.Lugar(idUsuario) : 0;
        int lugarSuyo = puedeCambiar ? contexto.Lugar(intercambio.OtroIdUsuario) : 0;
        List<ArticuloCardViewModel> paraAgregar = lugarMio > 0
            ? ArticulosBD.GetArticulosCatalogo(idUsuario: idUsuario, fueraDeIntercambio: idIntercambio)
            : new List<ArticuloCardViewModel>();
        List<ArticuloCardViewModel> paraPedir = lugarSuyo > 0
            ? ArticulosBD.GetArticulosCatalogo(idUsuario: intercambio.OtroIdUsuario, fueraDeIntercambio: idIntercambio)
            : new List<ArticuloCardViewModel>();

        string estado = intercambio.Estado;
        bool comprometido = estado == EstadosIntercambios.Pendiente && IntercambiosBD.IntercambioConArticuloComprometido(idIntercambio);
        int pendientesQueSeRechazan = intercambio.PorResponder ? IntercambiosBD.ContarPendientesDeArticulos(idIntercambio) : 0;

        DetalleIntercambio armado = new DetalleIntercambio(intercambio, cambios, pendientes, puedeCambiar);
        bool puedoSacar = mios.Count - armado.SacarPendientesMios() >= 2;

        DetalleIntercambioViewModel detalle = new DetalleIntercambioViewModel
        {
            Intercambio = intercambio,
            FotoOtro = UsuariosBD.GetFotoUsuario(intercambio.OtroIdUsuario),
            NombresMios = Nombres(mios),
            NombresSuyos = Nombres(suyos),
            TuMios = mios.Count > 1 ? "tus" : "tu",
            PorResponder = intercambio.PorResponder,
            ArticuloComprometido = comprometido,
            ConfirmarAceptar = !comprometido && pendientesQueSeRechazan > 0,
            AceptarDeshabilitado = comprometido || tengoPorResponder,
            AvisoRechazos = pendientesQueSeRechazan == 1
                ? "Hay otra propuesta pendiente que incluye estos artículos: si aceptás, se va a rechazar automáticamente."
                : $"Hay otras {pendientesQueSeRechazan} propuestas pendientes que incluyen estos artículos: si aceptás, se van a rechazar todas automáticamente.",
            AvisoNotificados = pendientesQueSeRechazan == 1
                ? "A quien la hizo le va a llegar una notificación."
                : "A quienes las hicieron les va a llegar una notificación.",
            PuedeCambiar = puedeCambiar,
            TengoPorResponder = tengoPorResponder,
            HayPendientes = pendientes.Count > 0,
            UltimoCambio = ultimoCambio,
            ConCambios = puedeCambiar || cambios.Count > 0,
            PanelMio = armado.Panel(intercambio.PorResponder ? (mios.Count > 1 ? "Por tus" : "Por tu") : "Vos das", mios, "tuyo", true,
                puedeCambiar && lugarMio > 0 && paraAgregar.Count > 0, puedoSacar),
            PanelSuyo = armado.Panel(intercambio.PorResponder ? "Te ofrece" : "Recibís", suyos, $"de @{intercambio.OtroUsuario}", false,
                puedeCambiar && lugarSuyo > 0 && paraPedir.Count > 0, false),
            PropuestoPor = intercambio.EsRecibido ? $"Propuesto por @{intercambio.OtroUsuario}" : "Propuesto por vos",
            TextoRechazo = intercambio.EsRecibido ? "Rechazaste esta propuesta." : $"{intercambio.OtroNombre} rechazó tu propuesta.",
            EsPendiente = estado == EstadosIntercambios.Pendiente,
            EsAceptado = estado == EstadosIntercambios.Aceptado,
            Rechazado = estado == EstadosIntercambios.Rechazado,
            Cancelado = estado == EstadosIntercambios.Cancelado,
            Realizado = estado == EstadosIntercambios.Realizado,
            AceptadoOMas = estado == EstadosIntercambios.Aceptado || estado == EstadosIntercambios.Realizado,
            PuedeCancelar = puedeCambiar,
            CambiosPorResponder = armado.CambiosPorResponder(),
            Historial = armado.Historial(),
            MostrarAgregar = puedeCambiar && lugarMio > 0 && paraAgregar.Count > 0,
            MostrarPedir = puedeCambiar && lugarSuyo > 0 && paraPedir.Count > 0,
            LugarMio = lugarMio,
            LeyendaAgregar = lugarMio == 1 ? "Podés sumar 1 más" : $"Podés sumar hasta {lugarMio} más",
            ParaAgregar = paraAgregar,
            ParaPedir = paraPedir
        };
        int cantidadPorResponder = detalle.CambiosPorResponder.Count;
        detalle.TituloCaja = $"{intercambio.OtroNombre} te pide {(cantidadPorResponder == 1 ? "un cambio" : $"{cantidadPorResponder} cambios")}";
        return detalle;
    }

    private static string Nombres(List<ArticuloCardViewModel> articulos)
    {
        List<string> nombres = new List<string>();
        foreach (ArticuloCardViewModel a in articulos)
        {
            nombres.Add(a.Nombre);
        }
        return Listas.UnirNombres(nombres);
    }

    private int SacarPendientesMios()
    {
        int cantidad = 0;
        foreach (CambioIntercambioViewModel c in _pendientes)
        {
            if (c.Tipo == TipoCambios.Sacar && c.IdDuenoArticulo != _intercambio.OtroIdUsuario)
            {
                cantidad++;
            }
        }
        return cantidad;
    }

    private bool LoHiceYo(CambioIntercambioViewModel cambio)
    {
        return cambio.IdUsuario != _intercambio.OtroIdUsuario;
    }

    private CambioIntercambioViewModel? PendienteDe(int idArticulo)
    {
        foreach (CambioIntercambioViewModel c in _pendientes)
        {
            if (c.IdArticulo == idArticulo)
            {
                return c;
            }
        }
        return null;
    }

    private CambioIntercambioViewModel? SumadoDe(int idArticulo)
    {
        foreach (CambioIntercambioViewModel c in _cambios)
        {
            if (c.IdArticulo == idArticulo && c.Estado == EstadosIntercambios.Aceptado
                && (c.Tipo == TipoCambios.Agregar || c.Tipo == TipoCambios.Pedir))
            {
                return c;
            }
        }
        return null;
    }

    private bool HayCambiosDe(List<ArticuloCardViewModel> articulos)
    {
        foreach (CambioIntercambioViewModel c in _cambios)
        {
            foreach (ArticuloCardViewModel a in articulos)
            {
                if (a.IdArticulos == c.IdArticulo)
                {
                    return true;
                }
            }
        }
        return false;
    }

    private PanelIntercambioViewModel Panel(string etiqueta, List<ArticuloCardViewModel> articulos, string deQuien, bool esMio,
        bool botonAgregar, bool puedoSacar)
    {
        List<CambioIntercambioViewModel> pedidos = new List<CambioIntercambioViewModel>();
        foreach (CambioIntercambioViewModel c in _pendientes)
        {
            if (c.Tipo == TipoCambios.Pedir && (c.IdDuenoArticulo != _intercambio.OtroIdUsuario) == esMio)
            {
                pedidos.Add(c);
            }
        }
        bool conCambios = _puedeCambiar || pedidos.Count > 0 || HayCambiosDe(articulos);

        PanelIntercambioViewModel panel = new PanelIntercambioViewModel
        {
            Etiqueta = etiqueta,
            DeQuien = deQuien,
            EsMio = esMio,
            Simple = articulos.Count == 1 && !conCambios,
            Unico = articulos.Count == 1 ? articulos[0] : null,
            CantidadTexto = articulos.Count == 1 ? "1 artículo" : $"{articulos.Count} artículos",
            BotonAgregar = botonAgregar,
            ModalAgregar = esMio ? "#modal-agregar" : "#modal-pedir",
            TextoAgregar = esMio ? "Agregar de tus artículos" : $"Pedirle un artículo a {_otroNombre}"
        };

        foreach (ArticuloCardViewModel a in articulos)
        {
            FilaPanelViewModel fila = new FilaPanelViewModel
            {
                IdArticulo = a.IdArticulos,
                Nombre = a.Nombre,
                Imagen = a.Imagen,
                Estado = a.Estado,
                Pendiente = PendienteDe(a.IdArticulos) != null
            };
            Completar(fila, esMio, puedoSacar);
            panel.Filas.Add(fila);
        }
        foreach (CambioIntercambioViewModel pedido in pedidos)
        {
            FilaPanelViewModel fila = new FilaPanelViewModel
            {
                IdArticulo = pedido.IdArticulo,
                Nombre = pedido.ArticuloNombre,
                Imagen = pedido.ArticuloImagen,
                Estado = pedido.ArticuloEstado,
                Pendiente = true
            };
            Completar(fila, esMio, puedoSacar);
            panel.Filas.Add(fila);
        }
        return panel;
    }

    private void Completar(FilaPanelViewModel fila, bool esMio, bool puedoSacar)
    {
        CambioIntercambioViewModel? pendiente = PendienteDe(fila.IdArticulo);
        if (pendiente != null)
        {
            bool loHiceYo = LoHiceYo(pendiente);
            fila.Que = pendiente.Tipo == TipoCambios.Pedir
                ? (loHiceYo ? "Lo pediste" : $"{_otroNombre} te lo pidió")
                : (loHiceYo ? "Pediste sacarlo" : $"{_otroNombre} quiere sacarlo");
            fila.Etiqueta = loHiceYo ? $"Esperando a {_otroNombre}" : "Te toca responder";
            fila.EtiquetaCss = loHiceYo ? "tono-celeste" : "tono-rosa";
        }
        else
        {
            CambioIntercambioViewModel? sumado = SumadoDe(fila.IdArticulo);
            if (sumado != null)
            {
                bool loHiceYo = LoHiceYo(sumado);
                string quien = sumado.Tipo == TipoCambios.Agregar
                    ? (loHiceYo ? "Lo agregaste vos" : $"Lo agregó {_otroNombre}")
                    : (loHiceYo ? "Lo pediste vos" : $"Lo pidió {_otroNombre}");
                fila.Etiqueta = $"{quien} · {(sumado.FechaRespuesta ?? sumado.Fecha).ToString("dd/MM")}";
                fila.EtiquetaCss = "tono-crema";
            }
        }

        if (!_puedeCambiar)
        {
            return;
        }
        if (pendiente != null && LoHiceYo(pendiente))
        {
            fila.IdCambioCancelable = pendiente.Id;
            fila.TextoCancelar = pendiente.Tipo == TipoCambios.Sacar ? "Deshacer" : "Cancelar pedido";
        }
        else if (pendiente == null && esMio && puedoSacar)
        {
            fila.PuedeSacar = true;
        }
    }

    private List<CambioPorResponderViewModel> CambiosPorResponder()
    {
        List<CambioIntercambioViewModel> porResponder = new List<CambioIntercambioViewModel>();
        foreach (CambioIntercambioViewModel c in _cambios)
        {
            if (c.EsPendiente && c.IdUsuario == _intercambio.OtroIdUsuario)
            {
                porResponder.Add(c);
            }
        }
        porResponder.Sort((a, b) => a.Fecha != b.Fecha ? a.Fecha.CompareTo(b.Fecha) : a.Id.CompareTo(b.Id));

        List<CambioPorResponderViewModel> cambios = new List<CambioPorResponderViewModel>();
        foreach (CambioIntercambioViewModel c in porResponder)
        {
            bool pedir = c.Tipo == TipoCambios.Pedir;
            cambios.Add(new CambioPorResponderViewModel
            {
                Id = c.Id,
                Imagen = c.ArticuloImagen,
                Articulo = c.ArticuloNombre,
                TextoAntes = pedir ? $"{_intercambio.OtroNombre} te pidió tu " : $"{_intercambio.OtroNombre} quiere sacar su ",
                TextoDespues = pedir ? "." : " del intercambio.",
                Ayuda = pedir ? "Si aceptás, se suma a lo que das." : "Si aceptás, ya no lo recibís.",
                BotonAceptar = pedir ? "Sí, sumarlo" : "Sí, sacarlo"
            });
        }
        return cambios;
    }

    private List<EventoCambioViewModel> Historial()
    {
        string otro = _intercambio.OtroNombre ?? _intercambio.OtroUsuario ?? "La otra persona";
        List<EventoCambioViewModel> eventos = new List<EventoCambioViewModel>();
        foreach (CambioIntercambioViewModel c in _cambios)
        {
            bool autorMio = LoHiceYo(c);
            string articulo = c.ArticuloNombre;
            string creado;
            if (c.Tipo == TipoCambios.Agregar)
            {
                creado = autorMio ? $"agregaste {articulo}" : $"agregó {articulo}";
            }
            else if (c.Tipo == TipoCambios.Pedir)
            {
                creado = autorMio ? $"pediste {articulo}" : $"pidió tu {articulo}";
            }
            else
            {
                creado = autorMio ? $"pediste sacar {articulo}" : $"pidió sacar {articulo}";
            }
            if (c.Estado == EstadosIntercambios.Pendiente && !c.Vigente)
            {
                creado += " · sin respuesta";
            }
            eventos.Add(new EventoCambioViewModel { Fecha = c.Fecha, Orden = c.Id * 2, Quien = autorMio ? "Vos" : otro, Texto = creado });

            if (c.FechaRespuesta.HasValue && c.Tipo != TipoCambios.Agregar)
            {
                string accion = c.Tipo == TipoCambios.Sacar ? "sacar" : "sumar";
                string respuesta;
                if (c.Estado == EstadosIntercambios.Aceptado)
                {
                    respuesta = !autorMio ? $"aceptaste {accion} {articulo}" : $"aceptó {accion} {articulo}";
                }
                else if (c.Estado == EstadosIntercambios.Rechazado)
                {
                    respuesta = !autorMio ? $"rechazaste {accion} {articulo}" : $"no aceptó {accion} {articulo}";
                }
                else if (c.Tipo == TipoCambios.Sacar)
                {
                    respuesta = autorMio ? $"deshiciste el pedido para sacar {articulo}" : $"deshizo el pedido para sacar {articulo}";
                }
                else
                {
                    respuesta = autorMio ? $"cancelaste el pedido de {articulo}" : $"canceló el pedido de {articulo}";
                }
                bool respondioYo = c.Estado == EstadosIntercambios.Cancelado ? autorMio : !autorMio;
                eventos.Add(new EventoCambioViewModel
                {
                    Fecha = c.FechaRespuesta.Value,
                    Orden = c.Id * 2 + 1,
                    Quien = respondioYo ? "Vos" : otro,
                    Texto = respuesta
                });
            }
        }
        eventos.Sort((a, b) => a.Fecha != b.Fecha ? b.Fecha.CompareTo(a.Fecha) : b.Orden.CompareTo(a.Orden));
        return eventos;
    }
}
