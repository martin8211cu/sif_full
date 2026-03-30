	<cfquery name="rsLista" datasource="#Session.dsn#">
		select 1
		from MEPersona a, MERelacionFamiliar b, MEParentesco c
		where a.MEpersona = b.MEpersona2
		and a.activo = 1
		and b.MEpersona1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.MEpersona#">
		and b.MEPid = c.MEPid
	</cfquery>
	
	<cfset STA = "<span class='style3'>">
	<cfset STC = "</span>">
	
	
	<style type="text/css">
	<!--
	.style2 {
	font-size: 14px;
	font-weight: bold;
	font-style: italic;
	}
	.style3 {
	font-size: 14px;
	font-weight: bold;
	font-style: italic;
	}
	-->
	</style>
	
	<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pLista"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="MEPersona a, MERelacionFamiliar b, MEParentesco c"/>
			<cfinvokeargument name="columnas" value="MEPersona2 = a.MEpersona, Nombre = Pnombre + ' ' + Papellido1 + ' ' + Papellido2, Parentesco = MEPnombre, tipo = 2"/>
			<cfinvokeargument name="desplegar" value="Nombre, Parentesco"/>
			<cfinvokeargument name="etiquetas" value="#STA#Nombre#STC#, #STA#Parentesco#STC#"/>
			<cfinvokeargument name="formatos" value="S, S"/>
			<cfinvokeargument name="filtro" value="a.MEpersona = b.MEpersona2
													and b.MEpersona1 = #session.MEpersona#
													and a.activo = 1
													and b.MEPid = c.MEPid
													order by Nombre, Parentesco"/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value="S"/>
			<cfinvokeargument name="irA" value="registro.cfm"/>
			<cfinvokeargument name="keys" value="MEPersona2, tipo">
	</cfinvoke>
	
	<cfif rsLista.RecordCount lte 0>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr bgcolor="#CCCCCC">
		<td>&nbsp;</td>
		<td align="center"><span class="style2">No tiene ningún famliar registrado. Para registrar un familiar seleccione una de las opciones en la sección inferior.</span></td>
		<td>&nbsp;</td>
	  </tr>
	</table>
	</cfif>
	
	<table width="100%"  border="0" cellpadding="0" cellspacing="0" bgcolor="#EEEEEE">
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>Para agregar familiares que comparten su domicilio presione este bot&oacute;n. </td>
        <td><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="100" height="22">
          <param name="BGCOLOR" value="">
          <param name="movie" value="images/mismo.swf">
          <param name="quality" value="high">
          <embed src="images/mismo.swf" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100" height="22" ></embed>
        </object></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>Para agregar familiares que tienen un domicilio diferente del suyo presione este bot&oacute;n.</td>
        <td><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="100" height="22">
          <param name="BGCOLOR" value="">
          <param name="movie" value="images/diferente.swf">
          <param name="quality" value="high">
          <embed src="images/diferente.swf" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100" height="22" ></embed>
        </object></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <cfif rsLista.RecordCount gt 0>
	  <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>Para modificar un familiar, haga click sobre los datos del familiar que desea modificar, de la lista, y espere un instante para que realice los cambios que desee en otra pantalla.</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
	  </cfif>
    </table>
	<p>&nbsp;</p>
	<p>&nbsp;</p>	