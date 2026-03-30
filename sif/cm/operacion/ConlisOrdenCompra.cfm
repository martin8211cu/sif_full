<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Asignar(EOidorden,EOnumero,Observaciones,SNcodigo,SNnumero,SNnombre) {
	if (window.opener != null) {
		window.opener.document.form1.EOidorden.value = EOidorden;
		window.opener.document.form1.EOnumero.value = EOnumero;
		window.opener.document.form1.Observaciones.value = Observaciones;
		window.opener.document.form1.EDRreferencia.value = Observaciones;
		window.opener.document.form1.SNcodigo.value = SNcodigo;
		window.opener.document.getElementById("socio").innerHTML = SNnumero + " - " + SNnombre;
		window.close();
	}
}
</script>

<cfif isdefined("Url.EOidorden") and not isdefined("Form.EOidorden")>
	<cfparam name="Form.EOidorden" default="#Url.EOidorden#">
</cfif>
<cfif isdefined("Url.SNnumeroF") and not isdefined("Form.SNnumeroF")>
	<cfparam name="Form.SNnumeroF" default="#Url.SNnumeroF#">
</cfif>
<cfif isdefined("Url.SNcodigoF") and not isdefined("Form.SNcodigoF")>
	<cfparam name="Form.SNcodigoF" default="#Url.SNcodigoF#">
</cfif>
<cfif isdefined("Url.fecha") and not isdefined("Form.fecha")>
	<cfparam name="Form.fecha" default="#Url.fecha#">
</cfif>
<cfif isdefined("Url.Observaciones") and not isdefined("Form.Observaciones")>
	<cfparam name="Form.Observaciones" default="#Url.Observaciones#">
</cfif>
<cfif isdefined("Url.Devoluciones") and not isdefined("Form.Devoluciones")>
	<cfparam name="Form.Devoluciones" default="#Url.Devoluciones#">
</cfif>
<cfif isdefined("Url.CMTgeneratracking")>
	<cfparam name="Form.CMTgeneratracking" default="1">
</cfif>

<cfset filtroorden = "">
<cfset filtrosocio = "">
<cfset filtrotipo = "">
<cfset navegacion = "">
<cfif isdefined("Form.EOidorden") and Len(Trim(Form.EOidorden)) NEQ 0>
	<cfset filtro = filtro & " and EOidorden = " & Form.EOidorden >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EOidorden=" & Form.EOidorden>
</cfif>
<cfif isdefined("Form.Observaciones") and Len(Trim(Form.Observaciones)) NEQ 0>
 	<cfset filtroorden = filtroorden & " and upper(Observaciones) like '%" & #UCase(Form.Observaciones)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Observaciones=" & Form.Observaciones>
</cfif>

<cfif isdefined("Form.CMTOcodigo") and Len(Trim(Form.CMTOcodigo)) NEQ 0>
 	<cfset filtroorden = filtroorden & " and a.CMTOcodigo ='" & form.CMTOcodigo &"'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CMTOcodigo=" & Form.CMTOcodigo>
</cfif>

<cfif isdefined("Form.SNnumeroF") and Len(Trim(Form.SNnumeroF)) NEQ 0>
 	<cfset filtrosocio = filtrosocio & " and SNnumero like '%" & #UCase(Form.SNnumeroF)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNnumeroF=" & Form.SNnumeroF>
</cfif>

<cfif isdefined("Form.SNcodigoF") and Len(Trim(Form.SNcodigoF)) NEQ 0>
 	<cfset filtrosocio = filtrosocio & " and a.SNcodigo=" & Form.SNcodigoF>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNcodigoF=" & Form.SNcodigoF>
</cfif>

<cfif isdefined("Form.EOnumero") and Len(Trim(Form.EOnumero)) NEQ 0>
 	<cfset filtrotipo = filtrotipo & " and EOnumero =" & form.EOnumero>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EOnumero=" & Form.EOnumero>
</cfif>

<cfif isdefined("Form.CMTgeneratracking")> 	
	<cfset filtrotipo = filtrotipo & " and CMTgeneratracking = 1">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CMTgeneratracking= 1">
<cfelse>
	<cfset filtrotipo = filtrotipo & " and CMTgeneratracking = 0">	
</cfif>

<cfif isdefined("Form.fecha") and Len(Trim(Form.fecha)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fecha=" & Form.fecha>
</cfif>

<cfif isdefined("Form.Devoluciones") and Len(Trim(Form.Devoluciones)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Devoluciones=" & Form.Devoluciones>
</cfif>

<html>
<head>
<title>Lista de Ordenes de Compra</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsLista" datasource="#session.DSN#">
	select a.EOidorden, a.CMTOcodigo#_Cat#'-'#_Cat#c.CMTOdescripcion as CMTOcodigo, a.CMTOcodigo as tipoOrden, c.CMTOdescripcion, a.EOnumero, a.EOfecha, a.SNcodigo, a.Observaciones, b.SNnumero, b.SNnombre
	from EOrdenCM a

	inner join SNegocios b
	on a.SNcodigo=b.SNcodigo
	  and a.Ecodigo=b.Ecodigo
		#preservesinglequotes(filtrosocio)#
	
	inner join CMTipoOrden c
	on a.Ecodigo=c.Ecodigo
	   and a.CMTOcodigo=c.CMTOcodigo
	   #preservesinglequotes(filtrotipo)#	
		
	where a.EOestado = 10
	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	<cfif isdefined("Form.fecha") and Len(Trim(Form.fecha)) NEQ 0>
		and a.EOfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha)#">
	</cfif>
	
	and EOidorden in (  
		select distinct EOidorden
		from DOrdenCM
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and DOcantsurtida
		<cfif isdefined("Form.Devoluciones") and Len(Trim(Form.Devoluciones)) NEQ 0>
			 > 0
		<cfelse>
			< DOcantidad 
		</cfif>
		and DOlinea not in 
		(
			select DOlinea from DDocumentosRecepcion a inner join EDocumentosRecepcion b 
			inner join TipoDocumentoR c on b.TDRcodigo = c.TDRcodigo and b.Ecodigo = c.Ecodigo and c.TDRtipo = 
			<cfif isdefined("Form.Devoluciones") and Len(Trim(Form.Devoluciones)) NEQ 0>
				'D'
			<cfelse>
				'R'
			</cfif>
			on a.EDRid = b.EDRid and a.Ecodigo = b.Ecodigo and b.EDRestado < 10
			where a.Ecodigo = DOrdenCM.Ecodigo and a.DOlinea = DOrdenCM.DOlinea
		)
	)
	
	#preservesinglequotes(filtroorden)#
	order by a.CMTOcodigo, a.EOnumero, a.SNcodigo, a.EOfecha
</cfquery>

<cfquery name="rsTipos" datasource="#session.DSN#">
	select distinct a.CMTOcodigo, c.CMTOdescripcion
	from EOrdenCM a

	inner join CMTipoOrden c
	on a.Ecodigo=c.Ecodigo
	   and a.CMTOcodigo=c.CMTOcodigo
		
	where a.EOestado = 10
	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by a.CMTOcodigo
</cfquery>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<form style="margin:0;" name="filtroOrden" method="post" action="ConlisOrdenCompra.cfm">
			<cfif isdefined("Form.Devoluciones") and Len(Trim(Form.Devoluciones)) NEQ 0>
				<cfoutput>
					<input type="hidden" name="Devoluciones" value="#Form.Devoluciones#">
				</cfoutput>
			</cfif>
			<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr>
					<td align="right" nowrap><strong>Tipo Orden</strong></td>
					<td> 
						<cfoutput>
						<select name="CMTOcodigo">
							<option value="">Todos</option>
							<cfloop query="rsTipos">
								<option value="#rsTipos.CMTOcodigo#" <cfif isdefined("form.CMTOcodigo") and form.CMTOcodigo eq rsTipos.CMTOcodigo>selected</cfif> >#rsTipos.CMTOdescripcion#</option> 
							</cfloop>
						</select>
						</cfoutput>
					</td>

					<td align="right" nowrap><strong>N&uacute;mero Orden</strong></td>
					<td> 
						<input name="EOnumero" type="text" id="desc" size="10" maxlength="80" value="<cfif isdefined("Form.EOnumero")>#Form.EOnumero#</cfif>" onFocus="javascript:this.select();">
					</td>

					<td align="right"><strong>Orden</strong></td>
					<td> 
						<input name="Observaciones" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.Observaciones")>#Form.Observaciones#</cfif>" onFocus="javascript:this.select();">
					</td>
				</tr>

				<tr>
					<td align="right"><strong>Fecha</strong></td>
					<td>
						<cfset _fecha = ''>
						<cfif isdefined("Form.fecha") and Len(Trim(Form.fecha)) NEQ 0>
							<cfset _fecha = Form.fecha >
						</cfif>
						<cf_sifcalendario form="filtroOrden" value="#_fecha#">
					</td>

					<td align="right" nowrap><strong>N&uacute;mero Socio</strong></td>
					<td> 			
								
						<cfif isdefined("Form.SNcodigoF")>
							<cf_sifsociosnegocios2 form="filtroOrden"  idquery="#Form.SNcodigoF#" sntiposocio="P" sncodigo="SNcodigoF" snnumero="SNnumeroF" frame="frame1"> 
						<cfelse>	
							<cf_sifsociosnegocios2 form="filtroOrden"  sntiposocio="P"  sncodigo="SNcodigoF" snnumero="SNnumeroF" frame="frame1">
						</cfif>							
						<!----	
						<input name="SNnumero" type="text" id="desc" size="10" maxlength="80" value="<cfif isdefined("Form.SNnumero")>#Form.SNnumero#</cfif>" onFocus="javascript:this.select();">
						---->
					</td>
					<td colspan="2">
						<table>
							<tr>										
								<td>
									<input type="checkbox" name="CMTgeneratracking" <cfif isdefined ("form.CMTgeneratracking")>checked</cfif>>&nbsp;<strong><label for="CMTgeneratracking">Genera Tracking</label></strong>
								</td>
								<td width="5">&nbsp;</td>
								<td align="center">
									<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" >
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			</form>
		</td>
	</tr>	
	<tr>
		<td>
			<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet"> 
				<cfinvokeargument name="query" value="#rsLista#"/> 
				<cfinvokeargument name="desplegar" value=" EOnumero, Observaciones, EOfecha, SNnumero,SNnombre"/> 
				<cfinvokeargument name="etiquetas" value="N&uacute;mero de Orden, Orden, Fecha, N&uacute;mero Socio, Nombre Socio"/> 
				<cfinvokeargument name="formatos" value="S,S,D,S,S"/> 
				<cfinvokeargument name="align" value="left,left,left,left,left"/> 
				<cfinvokeargument name="ajustar" value="N"/> 
				<cfinvokeargument name="checkboxes" value="N"/> 
				<cfinvokeargument name="irA" value="ConlisOrdenCompra.cfm"/> 
				<cfinvokeargument name="formname" value="listaOC"/> 
				<cfinvokeargument name="maxrows" value="15"/> 
				
				<cfinvokeargument name="funcion" value="Asignar"/>
				<cfinvokeargument name="fparams" value="EOidorden,EOnumero,Observaciones,SNcodigo,SNnumero,SNnombre"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showEmptyListMsg" value="yes"/>
				<cfinvokeargument name="Cortes" value="CMTOcodigo"/>
			</cfinvoke> 
		</td>
	</tr>
</table>
</cfoutput>

</body>
</html>