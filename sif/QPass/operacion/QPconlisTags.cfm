<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsOficinasUsuario" datasource="#session.dsn#">
	select distinct Ocodigo as Ocodigo
    from QPassUsuarioOficina f
    where f.Usucodigo = #session.Usucodigo#
      and f.Ecodigo = #session.Ecodigo#
</cfquery>
<cfif rsOficinasUsuario.recordcount eq 0>
	<table width="100%" style="vertical-align:middle" border="0">
    	<tr>
	        <td>&nbsp;</td>
        </tr>
        <tr>
	        <td>&nbsp;</td>
        </tr>
        <tr>
	        <td>&nbsp;</td>
        </tr>
    	<tr>
        	<td align="center"><cfoutput>***Usuario (#session.Usulogin#) no tiene Sucursales Definidas*** </cfoutput></td>
        </tr>
    </table>
	
    <cfabort>
</cfif>
<cfset LvarOficinasUsuario  = Valuelist(rsOficinasUsuario.Ocodigo, ",")>
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
               b.Oficodigo #_Cat# ' ' #_Cat# b.Odescripcion as sucursal  "
    Filtro=" a.Ecodigo = #session.Ecodigo#
    		 and c.QPEdisponibleVenta = 1
             and a.QPTEstadoActivacion in (1,2,9)
             and a.Ocodigo in (#LvarOficinasUsuario#)"
    Desplegar="QPTPAN, sucursal"
    Etiquetas="Tag, Sucursal"
    filtrar_por="QPTPAN, b.Oficodigo #_Cat# ' ' #_Cat# b.Odescripcion"
    Formatos="S,S"
    Align="left,left,left"
    form="form1"
    Asignar="QPTidTag, QPTPAN, QPTNumSerie"
    Asignarformatos="S,S,S"
    width="800"
    Funcion="funcPromotor"
    traerDatoOnBlur="true"
    funcionValorEnBlanco="funcPromotor"
/>