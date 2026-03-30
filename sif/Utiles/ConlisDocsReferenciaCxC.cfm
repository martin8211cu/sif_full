<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 24 de febrero del 2006
	Motivo: Se agregó un focus, cuado asigna los datos a los campos para q no se perdiera en la navegacion.
 --->

<!--- Recibe conexion, form, name, desc y id --->
<cfif isdefined("form.form") and not isdefined("url.form")>
	<cfparam name="url.form" default="#form.form#">
</cfif> 

<cfif isdefined("form.name") and not isdefined("url.name")>
	<cfparam name="url.name" default="#form.name#">
</cfif>

<cfif isdefined("form.SNcodigo") and not isdefined("url.SNcodigo")>
	<cfparam name="url.SNcodigo" default="#form.SNcodigo#">
</cfif>

<cfif isdefined("form.CCTcodigo") and not isdefined("url.CCTcodigo")>
	<cfparam name="url.CCTcodigo" default="#form.CCTcodigo#">
</cfif>
<cfif isdefined("form.CCTcodigoConlis") and not isdefined("url.CCTcodigoConlis")>
	<cfparam name="url.CCTcodigoConlis" default="#form.CCTcodigoConlis#">
</cfif>

<cfif isdefined("form.Ddocumento") and not isdefined("url.Ddocumento")>
	<cfparam name="url.Ddocumento" default="#form.Ddocumento#">
</cfif>

<cfif isdefined("Form.Dfecha") and not isdefined("url.Dfecha")>
	<cfparam name="url.Dfecha" default="#Form.Dfecha#">
</cfif>

<cfif isdefined("Url.form") and not isdefined("Form.form")>
	<cfparam name="Form.form" default="#Url.form#">
</cfif> 

<cfif isdefined("Url.name") and not isdefined("Form.name")>
	<cfparam name="Form.name" default="#Url.name#">
</cfif> 

<cfif isdefined("Url.SNcodigo") and not isdefined("Form.SNcodigo")>
	<cfparam name="Form.SNcodigo" default="#Url.SNcodigo#">
</cfif>
<cfif isdefined("Url.CCTcodigo") and not isdefined("Form.CCTcodigo")>
	<cfparam name="Form.CCTcodigo" default="#Url.CCTcodigo#">
</cfif>
<cfif isdefined("Url.CCTcodigoConlis") and not isdefined("Form.CCTcodigoConlis")>
	<cfparam name="Form.CCTcodigoConlis" default="#Url.CCTcodigoConlis#">
</cfif>
<cfif isdefined("Url.Ddocumento") and not isdefined("Form.Ddocumento")>
	<cfparam name="Form.Ddocumento" default="#Url.Ddocumento#">
</cfif>


<cfif isdefined("Url.Dfecha") and not isdefined("Form.Dfecha")>
	<cfparam name="Form.Dfecha" default="#Url.Dfecha#">
</cfif>

<script language="JavaScript" type="text/javascript">
function Asignar(name, cod) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#url.form#.#url.name#.value = name;
		window.opener.document.#url.form#.#url.CCTcodigoConlis#.value = cod;
		window.opener.document.#url.form#.#url.name#.focus();
		if (window.opener.func#url.name#) {window.opener.func#url.name#()}
		</cfoutput>
		window.close();
	}
}
</script>
<script language="JavaScript" src="../../js/calendar.js"></script>


<cfif isdefined('Form.SNcodigo') and LEN(Form.SNcodigo)>
	<cfquery name="rsNombreSocio" datasource="#Session.DSN#">
		select SNnombre
		from SNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
	</cfquery>
</cfif>
<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select CCTcodigo, CCTdescripcion 
	from CCTransacciones 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	and CCTtipo = 'D' 
	order by CCTcodigo 
</cfquery>
<cf_dbfunction name="concat" args="rtrim(b.CCTcodigo+'-'+rtrim(a.Ddocumento)+'-'+c.Mnombre)" delimiters= "+"  returnvariable="Descripcion">
<cfquery name="conlis" datasource="#Session.DSN#">
	select a.CCTcodigo as CCTcodigoConlis, a.Ddocumento, a.Mcodigo,  a.Ccuenta, a.Dtipocambio, a.Dfecha, a.Dvencimiento, 
		   a.Dtotal, a.Dsaldo, #PreserveSingleQuotes(Descripcion)# as Descripcion, c.Mnombre
	from Documentos a, CCTransacciones b, Monedas c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
	  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo#"> 
	  and b.CCTtipo = 'D'
	  and coalesce(b.CCTpago, 0) != 1
	  and a.Ecodigo = b.Ecodigo
	  and a.CCTcodigo = b.CCTcodigo 
	  and a.Ecodigo = c.Ecodigo
	  and a.Mcodigo = c.Mcodigo
 	<cfif isdefined("Form.CCTcodigo") and (Len(Trim(Form.CCTcodigo)) NEQ 0) and (Form.CCTcodigo NEQ "-1")>
		and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
	</cfif>

	<cfif isdefined("Form.Ddocumento") and (Len(Trim(Form.Ddocumento)) NEQ 0)>
	  and upper(a.Ddocumento) like '%#Ucase(Form.Ddocumento)#%'
	</cfif>
	order by Dvencimiento asc
</cfquery>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_conlis" default="1">
<cfset MaxRows_conlis=16>
<cfset StartRow_conlis=Min((PageNum_conlis-1)*MaxRows_conlis+1,Max(conlis.RecordCount,1))>
<cfset EndRow_conlis=Min(StartRow_conlis+MaxRows_conlis-1,conlis.RecordCount)>
<cfset TotalPages_conlis=Ceiling(conlis.RecordCount/MaxRows_conlis)>
<cfset QueryString_conlis=Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_conlis,"PageNum_conlis=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_conlis=ListDeleteAt(QueryString_conlis,tempPos,"&")>
</cfif>

<cfif isdefined("Form.btnFiltrar")>
	<cfset QueryString_conlis = "&form=#Form.form#&SNcodigo=#Form.SNcodigo#&CCTcodigo=#Form.CCTcodigo#&Ddocumento=#Form.Ddocumento#">
</cfif>

<script language="JavaScript" type="text/javascript">
	function Limpiar(f) {
		f.CCTcodigo.selectedIndex = 0;
		f.Ddocumento.value = "";
	}
</script>

<html>
<head>
<title>Lista de documentos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<style type="text/css">
	.encabezado {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 3px;
		padding-bottom: 3px;
	}
</style>

<cfform action="ConlisDocsReferenciaCxC.cfm" name="conlis">
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr><td colspan="4" class="tituloAlterno">Documentos&nbsp;de&nbsp;<cfoutput>#rsNombreSocio.SNnombre#</cfoutput></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr> 
			<td align="center" class="encabezado">Transacci&oacute;n</td>
			<td align="center" class="encabezado">Documento</td>
			<td class="encabezado">&nbsp;</td>
			<td class="encabezado">&nbsp;</td>
		</tr>
		<tr> 
			<td align="center"> 
				<select name="CCTcodigo" id="CCTcodigo">
					<option value="-1" <cfif isdefined("Form.CCTcodigo") AND Form.CCTcodigo EQ "-1">selected</cfif>>(Todos)</option>
					<cfoutput query="rsTransacciones"> 
						<option value="#CCTcodigo#" 
						  	<cfif isdefined("Form.CCTcodigo") AND rsTransacciones.CCTcodigo EQ Form.CCTcodigo>selected</cfif>>
							#CCTcodigo#
						</option>
					</cfoutput> 
				</select>
			</td>
			<td align="center">
				<input name="Ddocumento" type="text" id="Ddocumento" size="30" alt="El Documento" 
				value="<cfif isdefined("Form.Ddocumento")><cfoutput>#Form.Ddocumento#</cfoutput></cfif>">
			</td>
			<td>
				<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
				<input name="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onClick="javascript:Limpiar(this.form);">
			</td>
			
			<td align="center">
			</td>
		</tr>
		<tr align="center"> 
			<td colspan="4"> <cfoutput>
				<input name="SNcodigo" type="hidden" id="SNcodigo" value="<cfif isdefined("Form.SNcodigo")>#Form.SNcodigo#</cfif>">
				<input name="name" type="hidden" id="name" value="<cfif isdefined("Form.name")>#Form.name#</cfif>">
				<input name="CCTcodigoConlis" type="hidden" id="CCTcodigoConlis" value="<cfif isdefined("Form.CCTcodigoConlis")>#Form.CCTcodigoConlis#</cfif>">
				<input name="form" type="hidden" id="form" value="<cfif isdefined("Form.form")>#Form.form#</cfif>"></cfoutput>
			</td>
		</tr>
		<tr> 
			<td colspan="4"> 
				<cfif conlis.recordCount GT 0>
					<table cellpadding="0" cellspacing="0" border="0" width="100%">
						<tr> 
							<td class="encabReporte" style="padding:3px; " align="center">Transacci&oacute;n</td>
							<td class="encabReporte">Documento</td>
							<td class="encabReporte">Fecha</td>
							<td class="encabReporte" align="center">Fecha de Vencimiento</td>
							<td class="encabReporte" align="right">Moneda</td>
							<td class="encabReporte" align="right">Monto</td>
							<td class="encabReporte" align="right"> Saldo </td>
						</tr>
						
						<cfoutput query="conlis" startRow="#StartRow_conlis#" maxRows="#MaxRows_conlis#"> 
							<tr <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>
								onClick="javascript:Asignar('#JSStringFormat(TRIM(conlis.Ddocumento))#','#JSStringFormat(TRIM(conlis.CCTcodigoConlis))#');"
								onMouseOver="javascript: style.color = 'red'" 
								onMouseOut="javascript: style.color = 'black'"
								style="cursor: pointer;"> 
								<td align="center" <cfif conlis.CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> nowrap> 
								#conlis.CCTcodigoConlis#
							</td>
							<td nowrap>#conlis.Ddocumento#</td>
							<td nowrap>#LSDateFormat(conlis.DFecha,'dd/mm/yyyy')#</td>
								<td align="center">#LSDateFormat(conlis.Dvencimiento,'dd/mm/yyyy')#</td>
								<td align="right">#conlis.Mnombre#</td>
								<td align="right">#LSCurrencyFormat(conlis.Dtotal,'none')#</td>
								<td align="right">#LSCurrencyFormat(conlis.Dsaldo,'none')#</td>
							</tr>
						</cfoutput> 
					</table>
					<br>
					<table border="0" width="50%" align="center">
						<cfoutput>  
							<tr> 
								<td width="23%" align="center"> 
									<cfif PageNum_conlis GT 1>
										<a href="#CurrentPage#?PageNum_conlis=1#QueryString_conlis#">
											<img src="../imagenes/First.gif" border=0>
										</a> 
									</cfif>
								</td>
								<td width="31%" align="center"> 
									<cfif PageNum_conlis GT 1>
										<a href="#CurrentPage#?PageNum_conlis=#Max(DecrementValue(PageNum_conlis),1)##QueryString_conlis#">
											<img src="../imagenes/Previous.gif" border=0>
										</a> 
									</cfif>
								</td>
								<td width="23%" align="center"> 
									<cfif PageNum_conlis LT TotalPages_conlis>
										<a href="#CurrentPage#?PageNum_conlis=#Min(IncrementValue(PageNum_conlis),TotalPages_conlis)##QueryString_conlis#">
											<img src="../imagenes/Next.gif" border=0>
										</a> 
									</cfif>
								</td>
								<td width="23%" align="center"> 
									<cfif PageNum_conlis LT TotalPages_conlis>
										<a href="#CurrentPage#?PageNum_conlis=#TotalPages_conlis##QueryString_conlis#">
											<img src="../imagenes/Last.gif" border=0>
										</a> 
									</cfif>
								</td>
							</tr>
						</cfoutput> 
					</table>
				<cfelse>
					<br/>
						<p align="center">NO SE ENCONTRARON REGISTROS QUE CUMPLAN CON EL CRITERIO 
						DE B&Uacute;SQUEDA</p>
					<br/>
					<div align="center"> 
						<input type="button" name="btnCerrar" value="Cerrar Ventana" onClick="javascript:window.close();">
					</div>
				</cfif>
			</td>
		</tr>
	</table>
</cfform>
</body>
</html>

