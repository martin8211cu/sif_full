<cfinclude template="../../Utiles/sifConcat.cfm">

<cfquery name="rsTag" datasource="#session.dsn#">
    select distinct
		a.QPTidTag
		from QPMovCuenta a
		inner join QPCausa b
			on a.QPCid = b.QPCid
		inner join QPassTag t
			on t.QPTidTag=a.QPTidTag
		where a.QPMCFInclusion is not null
		and a.QPMCFProcesa is not null
		and a.QPMCFAfectacion is not null
</cfquery>

<cfset LvarTag  = Valuelist(rsTag.QPTidTag, ",")>
<cf_conlis
    Campos="QPTidTag, QPTPAN, QPTNumSerie"
    Desplegables="N,S,S"
    Modificables="N,S,N"
    Size="0,20,20"
    tabindex="1"
    valuesarray="#valuesArray#" 
    Title="Lista de Tags"
    Tabla=" QPassTag a
            inner join Oficinas b
                on b.Ecodigo = a.Ecodigo
               and b.Ocodigo = a.Ocodigo
            inner join QPassEstado c
            	on c.QPidEstado = a.QPidEstado"
    Columnas=" a.QPTidTag,
               a.QPTPAN, 
               a.QPTNumSerie,
               b.Oficodigo #_Cat# ' ' #_Cat# b.Odescripcion as sucursal"
    Filtro=" a.Ecodigo = #session.Ecodigo#
    		 and c.QPEdisponibleVenta = 1
             and a.QPTEstadoActivacion in (3,4)
			 and a.QPTidTag in(#LvarTag#)"
    Desplegar="QPTPAN, QPTNumSerie, sucursal"
    Etiquetas="Tag, Serie, Sucursal"
    filtrar_por="QPTPAN, QPTNumSerie, b.Oficodigo #_Cat# ' ' #_Cat# b.Odescripcion"
    Formatos="S,S,S"
    Align="left,left,left,left"
    form="form1"
    Asignar="QPTidTag, QPTPAN, QPTNumSerie"
    Asignarformatos="S,S,S"
    width="800"
    traerDatoOnBlur="true"
/>