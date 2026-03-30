<cfinclude template="../../Utiles/sifConcat.cfm">
<cf_conlis
    Campos="QPTidTag, QPTPAN, QPcteDocumento, QPcteNombre"
    Desplegables="N,S,S,S"
    Modificables="N,S,S,S"
    Size="0,20,20, 30"
    tabindex="1"
    valuesarray="#valuesArray#" 
    Title="Lista de Tags"
    Tabla=" QPassTag a
            inner join QPassEstado e
            	on e.QPidEstado = a.QPidEstado

			inner join QPventaTags v
				on v.QPTidTag = a.QPTidTag

			inner join QPcliente c
				on c.QPcteid = v.QPcteid"
    Columnas=" a.QPTidTag,
               a.QPTPAN, 
               c.QPcteDocumento,
               c.QPcteNombre"
    Filtro=" a.Ecodigo = #session.Ecodigo# and a.QPTEstadoActivacion in (4, 2) and v.QPvtaEstado = 1"
    Desplegar="QPTPAN, QPcteDocumento, QPcteNombre"
    Etiquetas="Tag, Identificación del Cliente, Nombre"
    filtrar_por="QPTPAN, QPcteDocumento, QPcteNombre"
    Formatos="S,S,S"
    Align="left,left,left"
    form="form1"
    Asignar="QPTidTag, QPTPAN, QPcteDocumento, QPcteNombre"
    Asignarformatos="S,S,S"
    width="800"
    traerDatoOnBlur="true"
/>