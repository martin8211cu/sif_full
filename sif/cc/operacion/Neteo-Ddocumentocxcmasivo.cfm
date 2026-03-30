<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 23 de agosto del 2005
	Motivo: Correccion del titulo de la forma, cuando entraba por CxP dejaba el titulo "Cuentas por Cobrar".
			Esto porque solo existen un proceso de neteo de documentos y este se encuentra dentro de la carpeta 
			de CxC. Creando un archivo dentro de CxP y haciendo la llamada del proceso, hace la corrección. Además 
			cambios en la seguridad de CxP.
			Se cambia la direccion de ubicacion de las distintas llamadas a fuentes condicionado a el modulo en q me encuentro. 
			Utilizando la variable de session modulo.
 --->
<!--- Proceso que se da en el btnAgregar --->
<cffunction 
	access="private" 
	displayname="ActualizarSaldo" 
	hint="Actualiza el Saldo del Documento"
	name="ActualizarSaldo"
	output="True"
	returntype="string">
	<cfargument
		hint="ID Documento"
		name="Documento"
		required="True"
		type="numeric">
	<cfquery datasource="#session.dsn#">
		update DocumentoNeteo
		set Dmonto =
		coalesce(	
				(select sum(a.Dmonto * case when b.CCTtipo = 'D' then 1 else -1 end)
				from DocumentoNeteoDCxC a, CCTransacciones b 
				where a.idDocumentoNeteo = DocumentoNeteo.idDocumentoNeteo
					and b.CCTcodigo = a.CCTcodigo 
					and b.Ecodigo = a.Ecodigo), 0.00)
		+
		coalesce(	
				(select sum(a.Dmonto * case when b.CPTtipo = 'D' then 1 else -1 end)
				from DocumentoNeteoDCxP a, EDocumentosCP d, CPTransacciones b 
				where a.idDocumentoNeteo = DocumentoNeteo.idDocumentoNeteo
					and d.IDdocumento = a.idDocumento 
					and b.Ecodigo = d.Ecodigo
					and b.CPTcodigo = d.CPTcodigo), 0.00)
		where idDocumentoNeteo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Documento#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
	</cfquery>
</cffunction>
<cffunction 
	access="private" 
	displayname="IncluirFacturas" 
	hint="Incluir Facturas Menores A Monto en el Documento correspondientes con la Moneda"
	name="IncluirFacturas"
	output="True"
	returntype="string">
	<cfargument
		hint="ID Documento"
		name="Documento"
		required="True"
		type="numeric">
	<cfargument
		hint="Transaccion"
		name="CCTcodigo"
		required="True"
		type="string">
	<cfargument
		hint="Documento"
		name="Ddocumento"
		required="True"
		type="string">
	<cfquery datasource="#session.dsn#">
		insert into DocumentoNeteoDCxC
			(idDocumentoNeteo, Ecodigo, CCTcodigo, Ddocumento, Dmonto, BMUsucodigo)
		select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Documento#">
			,a.Ecodigo, a.CCTcodigo, a.Ddocumento, a.Dsaldo,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		from Documentos a
			inner join CCTransacciones c
			on c.CCTcodigo = a.CCTcodigo
			and c.Ecodigo = a.Ecodigo
		where a.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and rtrim(a.CCTcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CCTcodigo)#">
			and rtrim(a.Ddocumento) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Ddocumento)#">
	</cfquery>
</cffunction>
<!--- Define Navegacion y Filtro --->
<cfscript>
	navegacion = "";
	filtro = "";
	if (isdefined("url.Mcodigo") and len(trim(url.Mcodigo))) {
		form.Mcodigo = url.Mcodigo;
	}
	if (isdefined("url.idDocumentoNeteo") and len(trim(url.idDocumentoNeteo))) {
		form.idDocumentoNeteo = url.idDocumentoNeteo;
	}
	if (isdefined("url.Socio") and len(trim(url.Socio))) {
		form.Socio = url.Socio;
	}
	if (isdefined("url.Transaccion") and len(trim(url.Transaccion))) {
		form.Transaccion = url.Transaccion;
	}
	if (isdefined("url.Saldo") and len(trim(url.Saldo))) {
		form.Saldo = url.Saldo;
	}
	if (isdefined("form.Socio") and len(trim(form.Socio))) {
		filtro = filtro & " and a.SNcodigo = " & form.Socio;
		navegacion = navegacion & "&Socio=" & form.Socio;
	}
	if (isdefined("form.Transaccion") and len(trim(form.Transaccion))) {
		filtro = filtro & " and a.CCTcodigo = '" & form.Transaccion & "'";
		navegacion = navegacion & "&Transaccion=" & form.Transaccion;
	}
	if (isdefined("form.Saldo") and len(trim(form.Saldo)) and form.Saldo GT 0.00) {
		filtro = filtro & " and a.Dsaldo <= " & Replace(form.Saldo,',','','all');
		navegacion = navegacion & "&Saldo=" & form.Saldo;
	}
	if (isdefined("form.btnAgregar") and isdefined("form.chk")) {
		llaves = ListToArray(form.chk);
		for (index=1; index lte ArrayLen(llaves); index = index + 1) {
			llave = ListToArray(llaves[index],'|');
			CCTcodigo = llave[1];
			Ddocumento = llave[2];
			IncluirFacturas(form.idDocumentoNeteo, CCTcodigo, Ddocumento);
			ActualizarSaldo(form.idDocumentoNeteo);
		}
	}
</cfscript>
<!---Consultas--->
<cfquery name="rsTransaccionesCxC" datasource="#session.dsn#">
	select CCTcodigo, CCTdescripcion
	from CCTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
</cfquery>
<!---Pintado del Conlis--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<cf_templatecss>
<body>
<cf_web_portlet_start titulo="Agregar Documentos Masivamente en Proceso de Neteo de Documentos">
<br>
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
<tr>
<td align="center">
<cfoutput>
<form action="../../cc/operacion/Neteo-Ddocumentocxcmasivo.cfm" name="form1" method="get" onSubmit="javascript: if (fnfinal) fnfinal();">
<input type="hidden" name="Mcodigo" value="#form.Mcodigo#"  tabindex="-1">
<input type="hidden" name="idDocumentoNeteo" value="#form.idDocumentoNeteo#"  tabindex="-1">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
	<tr>
		<td rowspan="3">&nbsp;</td>
		<td colspan="4" align="justify"><strong>En esta sección defina las condiciones para traer un conjunto de documentos iniciales, de los cuales 
			podrá seleccionar cuales quiere agregar masivamente al documento de Neteo:</strong>
			<hr>
		</td>
		<td rowspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><strong>Socio&nbsp;:&nbsp;</strong></td>
		<td><strong>Transacción:&nbsp;</strong></td>
		<td><strong>Saldo&nbsp;:&nbsp;</strong></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
	<td>
	<input 	type="checkbox" name="chkAllItems" value="1"  style="border:none; background-color:inherit;" onclick="javascript: funcFiltroChkAlllista(this);"	> 
	</td>
		<td>
			<cfif (isdefined("form.Socio"))>
				<cfquery name="rsSocio" datasource="#session.dsn#">
					select SNidentificacion, SNcodigo, SNnombre
					from SNegocios
					where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Socio#">
				</cfquery>
				<cf_sifsociosnegocios SNcodigo="Socio" query="#rsSocio#" size="40" tabindex="1">
			<cfelse>
				<cf_sifsociosnegocios SNcodigo="Socio" size="40" tabindex="1">
			</cfif>
		</td>
		<td>
			<select name="Transaccion" tabindex="1">
				<option value=""> -- Todas -- </option>
				<cfloop query="rsTransaccionesCxC">
					<option value="#rsTransaccionesCxC.CCTcodigo#" <cfif (isdefined("form.Transaccion")) and form.Transaccion eq rsTransaccionesCxC.CCTcodigo>selected</cfif>>#rsTransaccionesCxC.CCTdescripcion#</option>
				</cfloop>
			</select>	
		</td>
		<td>
			<cfif (isdefined("form.Saldo")) and len(trim(form.Saldo)) and form.Saldo GT 0.00>
				<cf_monto name="Saldo" value="#Replace(form.Saldo,',','','all')#"  tabindex="1">
			<cfelse>
				<cf_monto name="Saldo" tabindex="1">
			</cfif>
		</td>
		<td>
			<cf_botones values="Filtrar" tabindex="1">
		</td>
	</tr>
</table>
</form>
</cfoutput>
<cfquery name="rs" datasource="#session.dsn#">
	select a.Mcodigo, 
			rtrim(a.Ddocumento) as Ddocumento, 
			rtrim(a.CCTcodigo) as CCTcodigo, 
			b.CCTdescripcion, 
			a.Dsaldo, 
			c.SNnombre
	from Documentos a
		inner join CCTransacciones b
			on a.CCTcodigo = b.CCTcodigo
			and a.Ecodigo = b.Ecodigo
		inner join SNegocios c
			on c.SNcodigo = a.SNcodigo
			and c.Ecodigo = a.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		#PreserveSingleQuotes(filtro)#
		and Dsaldo > 0
		and Ddocumento not in(
				select Ddocumento 
				from DocumentoNeteoDCxC b inner join DocumentoNeteo c
					on b.idDocumentoNeteo = c.idDocumentoNeteo
					and b.Ecodigo = c.Ecodigo
					and c.Aplicado = 0
				where b.Ecodigo = a.Ecodigo
					and b.Ddocumento = a.Ddocumento
					and b.CCTcodigo = a.CCTcodigo
			)
	order by c.SNcodigo, b.CCTcodigo
</cfquery>
<cfinvoke 
	component="sif.Componentes.pListas"
	method="pListaQuery"	
	returnvariable="pLista"
	query="#rs#"
	cortes="SNnombre,CCTdescripcion"
	desplegar="Ddocumento,Dsaldo"
	etiquetas="Documento,Saldo"
	formatos="S,M"
	align="left,right"
	funcion="funcion"
	fparams="Ddocumento, Dsaldo"
	maxrows="25"
	showemptylistmsg="true"
	emptylistmsg="*** No se encontró ningún documento ***"
	irA="../../cc/operacion/Neteo-Ddocumentocxcmasivo.cfm?Mcodigo=#form.Mcodigo#&idDocumentoNeteo=#form.idDocumentoNeteo##navegacion#"
	checkboxes="S"

	keys="CCTcodigo,Ddocumento"
	showLink="false"
	botones="Agregar,Cerrar"
/>
<script language="javascript" type="text/javascript">
<!--//
	function funcAgregar(){
		return confirm("¿Desea agregar los documentos seleccionados a su Documento de Neteo?");
	}
	function funcCerrar(){
		window.opener.document.formcxc.submit();
		window.close();
	}
//-->
</script>
<br>
<cf_web_portlet_end>
</td>
</tr>
</table>
</body>
</html>