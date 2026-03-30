<!--- Consultas para pintar los datos del Reporte --->
<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsIntegracion" datasource="#session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		and Pcodigo = 520
</cfquery>

<cfquery name="rsCompradores" datasource="#session.DSN#">
	select 	a.CMCid, a.CMCcodigo, a.CMCnombre, 
			b.DEtelefono1, b.DEtelefono2, b.DEemail,
			c.Mnombre, a.CMCmontomax, a.CMCjefe
	from CMCompradores a
		left outer join DatosEmpleado b
			on a.Ecodigo = b.Ecodigo
			and a.DEid = b.DEid 	 
		inner join Monedas c
			on a.Ecodigo = c.Ecodigo
			and a.Mcodigo = c.Mcodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		<cfif isdefined("form.CMCcodigo") and len(trim(form.CMCcodigo)) >
			and upper(CMCcodigo) like  upper('%#form.CMCcodigo#%')
		</cfif>
		<cfif isdefined("form.CMCnombre") and len(trim(form.CMCnombre)) >
			and upper(CMCnombre) like  upper('%#form.CMCnombre#%')
		</cfif>

</cfquery>

<cfsavecontent variable="encabezado1">
	<cfoutput>
		<tr><td class="tituloAlterno" colspan="8" align="center">#rsEmpresa.Edescripcion#</td></tr>
		<tr><td colspan="8" nowrap>&nbsp;</td></tr>
		<tr><td colspan="8" align="center"><strong>Consulta de Datos por Comprador</strong></td></tr>
		<tr><td colspan="8" align="center"><strong>Fecha de la Consulta:&nbsp;</strong>#LSDateFormat(Now(),'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(Now(),'medium')#</td></tr>
		<tr><td colspan="8" nowrap><hr></td></tr>
	</cfoutput>
</cfsavecontent>

<cfsavecontent variable="encabezado2">
	<cfoutput>
		<tr>
			<td width="25%" nowrap class="listaCorte"><strong>C&oacute;digo - Comprador</strong></td>
			<td width="9%" nowrap class="listaCorte"><strong>Tel&eacute;fono</strong></td>
			<td width="9%" nowrap class="listaCorte"><strong>Fax</strong></td>
			<td width="10%" nowrap class="listaCorte"><strong>E-mail</strong></td>
			<td width="20%" nowrap class="listaCorte"><strong>Jefe</strong></td>
			<td width="10%"  nowrap class="listaCorte"><strong>Moneda</strong></td>
			<td width="10%"  nowrap align="right" class="listaCorte"><strong>Monto M&aacute;ximo</strong></td>
		</tr>
	</cfoutput>
</cfsavecontent>

<link href="StyleReporte.css" rel="stylesheet" type="text/css">
<cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="3" align="center">
    <cfif rsCompradores.RecordCount EQ 0>
    #encabezado1#
    </cfif>
    <cfif rsCompradores.RecordCount GT 0>
      <cfloop query="rsCompradores">
        <cfif currentRow mod 40 EQ 1>
          <cfif currentRow NEQ 1>
            <tr class="pageEnd">
              <td colspan="8">&nbsp;</td>
            </tr>
          </cfif>
        #encabezado1# #encabezado2#
        </cfif>
        <cfif len(trim(rsCompradores.CMCjefe)) GT 0>
          <cfinclude template="../../Utiles/sifConcat.cfm">
          <cfquery name="rsJefe" datasource="ASP">
	        select b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as Jefe from Usuario a, DatosPersonales b where a.Usucodigo = #rsCompradores.CMCjefe# and a.datos_personales = b.datos_personales
          </cfquery>
        </cfif>
        <tr style	= "cursor:hand;" 
			class	= "<cfif rsCompradores.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>" 
			onClick	= "javascript: doConlis(#rsCompradores.CMCid#);"
			onmouseover = "style.backgroundColor='##E4E8F3';" 
			onmouseout	= "style.backgroundColor='<cfif rsCompradores.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" >
          <td nowrap>#rsCompradores.CMCcodigo#-#rsCompradores.CMCnombre#</td>
          <cfif rsIntegracion.Pvalor EQ 'N'>
            <cfset rh = sec.getUsuarioByRef (rsCompradores.CMCid, session.EcodigoSDC, 'CMCompradores') >
            <!--- <cfdump var="#rh#">  --->
            <td nowrap>#rh.Pcasa#</td>
            <td nowrap>#rh.Pfax#</td>
            <td nowrap>#rh.Pemail1#</td>
            <cfelse>
            <td nowrap>#rsCompradores.DEtelefono1#</td>
            <td nowrap>#rsCompradores.DEtelefono2#</td>
            <td nowrap>#rsCompradores.DEemail#</td>
          </cfif>
          <td nowrap><cfif len(trim(rsCompradores.CMCjefe)) GT 0>
              #rsJefe.Jefe#
          </cfif></td>
          <td nowrap>#rsCompradores.Mnombre#</td>
          <td nowrap align="right">#LSCurrencyFormat(rsCompradores.CMCmontomax,'none')#</td>
        </tr>
      </cfloop>
      <tr>
        <td colspan="8" nowrap>&nbsp;</td>
      </tr>
      <tr>
        <td colspan="8" nowrap align="center" class="listaCorte"><strong>--- Fin de la Consulta ---</strong></td>
      </tr>
      <cfelse>
      <tr>
        <td colspan="8" nowrap>&nbsp;</td>
      </tr>
      <tr>
        <td colspan="8" nowrap align="center" class="listaCorte"><strong>--- La Consulta no Gener&oacute; Resultados ---</strong></td>
      </tr>
    </cfif>
    <tr>
      <td colspan="8" nowrap>&nbsp;</td>
    </tr>
  </table>
</cfoutput>

<script language='javascript' type='text/JavaScript' >
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis(CMCid) {
		var params = "";
		popUpWindow("/cfmx/sif/cm/consultas/DatosComprador-vista.cfm?CMCid="+CMCid,10,10,1000,550);
	}
</script>

