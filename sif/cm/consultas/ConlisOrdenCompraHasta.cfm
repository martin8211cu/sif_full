<!--- Recibe conexion, form, name y desc --->
<!----<cfset index = "">----->
<cfif isdefined("Form.idx") and Len(Trim(Form.idx))>
	<cfset index = Form.idx>
<cfelseif isdefined("Url.idx") and Len(Trim(Url.idx)) and not isdefined("Form.index")>
	<cfset index = Url.idx>
</cfif>

<script language="JavaScript" type="text/javascript">
function Asignar<cfoutput>#index#</cfoutput>(EOidorden,EOnumero,Observaciones) {
	if (window.opener != null) {		
		window.opener.document.form1.EOidorden<cfoutput>#index#</cfoutput>.value = EOidorden;
		window.opener.document.form1.EOnumero<cfoutput>#index#</cfoutput>.value = EOnumero;
		window.opener.document.form1.Observaciones<cfoutput>#index#</cfoutput>.value = Observaciones;
		window.close();
	}
}
</script>

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
<cfif isdefined("index") and Len(Trim(index)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "index=" & index>
</cfif>

<html>
<head>
<title>Lista de Ordenes de Compra </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<cfinclude template="../../Utiles/sifConcat.cfm">

<cfif isdefined("form.Ecodigo") and form.Ecodigo neq "">
	<cfset url.Ecodigo = form.Ecodigo>
</cfif>
<cfif isdefined("form.Estado") and form.Estado neq "">
	<cfset url.Estado = form.Estado>
</cfif>
<cfparam name="url.Ecodigo" 	default="#session.Ecodigo#">
<cfparam name="url.Estado" 		default="1">
<cfparam name="url.CMCid" default="">

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
		
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
	<cfif isdefined("url.Estado")>
		<cfif url.Estado EQ 0>
			and a.EOestado in (10, 55)
		<cfelse>
			and a.EOestado = 10
		</cfif>
	</cfif>
    <cfif isdefined("url.CMCid") and url.CMCid neq "">
    	and a.CMCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CMCid#">
    </cfif>
	
	<cfif isdefined("Form.fecha") and Len(Trim(Form.fecha)) NEQ 0>
		and a.EOfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha)#">
	</cfif>

	  and EOidorden in (  select distinct EOidorden 
                                      from DOrdenCM
                                      where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
                                      and DOcantidad > DOcantsurtida )
	  
	#preservesinglequotes(filtroorden)#
	order by a.CMTOcodigo, a.EOnumero, a.SNcodigo, a.EOfecha
</cfquery>

<cfquery name="rsTipos" datasource="#session.DSN#">
	select distinct a.CMTOcodigo, c.CMTOdescripcion
	from EOrdenCM a

	inner join CMTipoOrden c
	on a.Ecodigo=c.Ecodigo
	   and a.CMTOcodigo=c.CMTOcodigo
		
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
	<cfif isdefined("url.Estado")>
		<cfif url.Estado EQ 0>
			and a.EOestado in (10, 55)
		<cfelse>
			and a.EOestado = 10
		</cfif>
	</cfif>
	order by a.CMTOcodigo
</cfquery>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<form style="margin:0;" name="filtroOrden" method="post" action="ConlisOrdenCompraHasta.cfm">
			<cfif Len(Trim(index))>
				<input type="hidden" name="idx" value="#index#">
			</cfif>
			  	
			<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr>
					<td align="right" nowrap><strong>Tipo Orden:</strong></td>
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

					<td align="right" nowrap><strong>N&uacute;mero Orden:</strong></td>
					<td> 
						<input name="EOnumero" type="text" id="desc" size="10" maxlength="80" value="<cfif isdefined("Form.EOnumero")>#Form.EOnumero#</cfif>" onFocus="javascript:this.select();">
					</td>

					<td align="right"><strong>Observaci&oacute;n:</strong></td>
					<td> 
						<input name="Observaciones" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.Observaciones")>#Form.Observaciones#</cfif>" onFocus="javascript:this.select();">
					</td>
				</tr>

				<tr>
					<td align="right"><strong>Fecha:</strong></td>
					<td>
						<cfset _fecha = ''>
						<cfif isdefined("Form.fecha") and Len(Trim(Form.fecha)) NEQ 0>
							<cfset _fecha = Form.fecha >
						</cfif>
						<cf_sifcalendario form="filtroOrden" value="#_fecha#">
					</td>

					<td align="right" nowrap><strong>Socio de Negocio:</strong></td>
					<td> 
						<input name="SNnumero" type="text" id="desc" size="10" maxlength="80" value="<cfif isdefined("Form.SNnumero")>#Form.SNnumero#</cfif>" onFocus="javascript:this.select();">
					</td>

					<td align="center">
						<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
                        <input name="Ecodigo" type="hidden" value="<cfoutput>#url.Ecodigo#</cfoutput>">
                        <input name="Estado" type="hidden" value="<cfoutput>#url.Estado#</cfoutput>">
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
				<cfinvokeargument name="irA" value="ConlisOrdenCompraHasta.cfm"/> 
				<cfinvokeargument name="formname" value="listaOC"/> 
				<cfinvokeargument name="maxrows" value="15"/> 				
				<cfinvokeargument name="funcion" value="Asignar#index#"/>
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