<!--- Recibe conexion, form, name y desc --->


<cfif isdefined("Url.EOidorden") and not isdefined("Form.EOidorden")>
	<cfparam name="Form.EOidorden" default="#Url.EOidorden#">
</cfif>
<cfif isdefined("Url.SNnumero") and not isdefined("Form.SNnumero")>
	<cfparam name="Form.SNnumero" default="#Url.SNnumero#">
</cfif>
<cfif isdefined("Url.fecha") and not isdefined("Form.fecha")>
	<cfparam name="Form.fecha" default="#Url.fecha#">
</cfif>

<cfif isdefined("Url.Observaciones") and not isdefined("Form.Observaciones")>
	<cfparam name="Form.Observaciones" default="#Url.Observaciones#">
</cfif>

<cf_navegacion name="EOidordenName"  default=""  session>
<cf_navegacion name="EOnumeroName"  default=""  session>
<cf_navegacion name="ObservacionesName" default="" session>

<cfif isdefined("Url.EOidordenName")>
	<cfparam name="LvarEOidorden" default="#Url.EOidordenName#">
<cfelse>
	<cfparam name="LvarEOidorden" default="EOidorden">
</cfif>

<cfif isdefined("Url.EOnumeroName")>
	<cfparam name="LvarEOnumero" default="#Url.EOnumeroName#">	
<cfelse>
	<cfparam name="LvarEOnumero" default="EOnumero">
</cfif>

<cfif isdefined("Url.ObservacionesName")>
	<cfparam name="LvarObservaciones" default="#Url.ObservacionesName#"> 
<cfelse>
	<cfparam name="LvarObservaciones" default="Observaciones"> 
</cfif>



<cfoutput>
	<script language="JavaScript" type="text/javascript">
	function Asignar(EOidorden,EOnumero,Observaciones) {
		if (window.opener != null) {
			window.opener.document.form1.#LvarEOidorden#.value = EOidorden;
			window.opener.document.form1.#LvarEOnumero#.value = EOnumero;
			window.opener.document.form1.#LvarObservaciones#.value = Observaciones;
			window.close();
		}
	}
	</script>
</cfoutput>

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

<cfif isdefined("Form.SNnumero") and Len(Trim(Form.SNnumero)) NEQ 0>
 	<cfset filtrosocio = filtrosocio & " and SNnumero like '%" & #UCase(Form.SNnumero)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNnumero=" & Form.SNnumero>
</cfif>

<cfif isdefined("Form.EOnumero") and Len(Trim(Form.EOnumero)) NEQ 0>
 	<cfset filtrotipo = filtrotipo & " and EOnumero =" & form.EOnumero>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EOnumero=" & Form.EOnumero>
</cfif>


<cfif isdefined("Form.fecha") and Len(Trim(Form.fecha)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fecha=" & Form.fecha>
</cfif>

<html>
<head>
<title>Lista de Ordenes de Compra Parcialmente Surtidas</title>
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
		
	where a.EOestado in (10, 55)
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("Form.fecha") and Len(Trim(Form.fecha)) NEQ 0>
		and a.EOfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha)#">
	</cfif>

	  <!--- and EOidorden in (  select distinct EOidorden 
						  from DOrdenCM
						  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and DOcantidad > DOcantsurtida ) --->
	  
	#preservesinglequotes(filtroorden)#
	order by a.CMTOcodigo, a.EOnumero, a.SNcodigo, a.EOfecha
</cfquery>

<cfquery name="rsTipos" datasource="#session.DSN#">
	select distinct a.CMTOcodigo, c.CMTOdescripcion
	from EOrdenCM a

	inner join CMTipoOrden c
	on a.Ecodigo=c.Ecodigo
	   and a.CMTOcodigo=c.CMTOcodigo
		
	where a.EOestado in (10, 55)
	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by a.CMTOcodigo
</cfquery>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<form style="margin:0;" name="filtroOrden" method="post" action="ConlisOrdenCompraV2.cfm">
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
						<input name="SNnumero" type="text" id="desc" size="10" maxlength="80" value="<cfif isdefined("Form.SNnumero")>#Form.SNnumero#</cfif>" onFocus="javascript:this.select();">
					</td>

					<td align="center">
						<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
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
				<cfinvokeargument name="irA" value="ConlisOrdenCompraV2.cfm"/> 
				<cfinvokeargument name="formname" value="listaOC"/> 
				<cfinvokeargument name="maxrows" value="15"/> 
				
				<cfinvokeargument name="funcion" value="Asignar"/>
				<cfinvokeargument name="fparams" value="EOidorden,EOnumero,Observaciones"/>
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