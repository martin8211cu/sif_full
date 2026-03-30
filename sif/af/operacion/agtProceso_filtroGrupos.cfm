<!---AGTPdescripcion, AGTPperiodo, AGTPmes, Categoria, Clase, Oficina, CentroF, AGTPfalta, AGTPestado--->
<cfscript>
//Procesa los datos del filtro cuando vienen en url
if (isdefined("url.FAGTPdescripcion") and len(trim(url.FAGTPdescripcion))) FAGTPdescripcion = url.FAGTPdescripcion;
if (isdefined("url.FAGTPperiodo") and len(trim(url.FAGTPperiodo))) FAGTPperiodo = url.FAGTPperiodo; 
if (isdefined("url.FAGTPmes") and len(trim(url.FAGTPmes))) FAGTPmes = url.FAGTPmes;
if (isdefined("url.FCategoria") and len(trim(url.FCategoria))) FCategoria = url.FCategoria;
if (isdefined("url.FClase") and len(trim(url.FClase))) FClase = url.FClase;
if (isdefined("url.FOficina") and len(trim(url.FOficina))) FOficina = url.FOficina;
if (isdefined("url.FCentroF") and len(trim(url.FCentroF))) FCentroF = url.FCentroF;
if (isdefined("url.FAGTPfalta") and len(trim(url.FAGTPfalta))) FAGTPfalta = url.FAGTPfalta;
if (isdefined("url.FAGTPestado") and len(trim(url.FAGTPestado))) FAGTPestado = url.FAGTPestado;
//Procesa los datos del filtro cuando vienen en form
if (isdefined("form.FAGTPdescripcion") and len(trim(form.FAGTPdescripcion))) FAGTPdescripcion = form.FAGTPdescripcion;
if (isdefined("form.FAGTPperiodo") and len(trim(form.FAGTPperiodo))) FAGTPperiodo = form.FAGTPperiodo; 
if (isdefined("form.FAGTPmes") and len(trim(form.FAGTPmes))) FAGTPmes = form.FAGTPmes;
if (isdefined("form.FCategoria") and len(trim(form.FCategoria))) FCategoria = form.FCategoria;
if (isdefined("form.FClase") and len(trim(form.FClase))) FClase = form.FClase;
if (isdefined("form.FOficina") and len(trim(form.FOficina))) FOficina = form.FOficina;
if (isdefined("form.FCentroF") and len(trim(form.FCentroF))) FCentroF = form.FCentroF;
if (isdefined("form.FAGTPfalta") and len(trim(form.FAGTPfalta))) FAGTPfalta = form.FAGTPfalta;
if (isdefined("form.FAGTPestado") and len(trim(form.FAGTPestado))) FAGTPestado = form.FAGTPestado;
//Procesa los datos para crear el filtro y la navegacion
if (isdefined("FAGTPdescripcion") and len(trim(FAGTPdescripcion))) { filtro = filtro & " and upper(a.AGTPdescripcion) like '%#Ucase(FAGTPdescripcion)#%'"; navegacion = navegacion & "&FAGTPdescripcion=#FAGTPdescripcion#";}
if (isdefined("FAGTPperiodo") and len(trim(FAGTPperiodo))) { filtro = filtro & " and a.AGTPperiodo = #FAGTPperiodo#"; navegacion = navegacion & "&FAGTPperiodo=#FAGTPperiodo#";}
if (isdefined("FAGTPmes") and len(trim(FAGTPmes))) { filtro = filtro & " and a.AGTPmes = #FAGTPmes#"; navegacion = navegacion & "&FAGTPmes=#FAGTPmes#";}
if (isdefined("FCategoria") and len(trim(FCategoria))) { filtro = filtro & " and a.FACcodigo = #FCategoria#"; navegacion = navegacion & "&FCategoria=#FCategoria#";}
if (isdefined("FClase") and len(trim(FClase))) { filtro = filtro & " and a.FACid = #FClase#"; navegacion = navegacion & "&FClase=#FClase#";}
if (isdefined("FOficina") and len(trim(FOficina))) { filtro = filtro & " and a.FOcodigo = #FOficina#"; navegacion = navegacion & "&FOficina=#FOficina#";}
if (isdefined("FCentroF") and len(trim(FCentroF))) { filtro = filtro & " and a.FCFid = #FCentroF#"; navegacion = navegacion & "&FCentroF=#FCentroF#";}
if (isdefined("FAGTPfalta") and len(trim(FAGTPfalta))) { filtro = filtro & " and a.AGTPfalta >= '#LSDateFormat(FAGTPfalta,'yyyymmdd')#'"; navegacion = navegacion & "&FAGTPfalta=#FAGTPfalta#";}
if (isdefined("FAGTPestado") and len(trim(FAGTPestado))) { filtro = filtro & " and a.AGTPestadp = #FAGTPestado#"; navegacion = navegacion & "&FAGTPestado=#FAGTPestado#";}
</cfscript>

<!---Consultas para pintar el formulario--->
<!---Periodos--->
<cfquery name="rsPrePeriodo" datasource="#Session.DSN#">
	select Pvalor as periodo
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	and Pcodigo = 30
</cfquery>
<cfset rsPeriodo = QueryNew("Pvalor")>
<cfset temp = QueryAddRow(rsPeriodo,3)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo,1)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo+1,2)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",rsPrePeriodo.periodo+2,3)>
<!---Meses--->
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>
<!---Categorias--->
<cfquery name="rsCategorias" datasource="#Session.DSN#">
	select ACcodigo, ACdescripcion, ACmascara
	from ACategoria 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!---Oficinas--->
<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion from Oficinas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Ocodigo                      
</cfquery>
<!---Clases se llenan automáticamente cuando cambia la categoria--->
<cfquery name="rsClases" datasource="#Session.DSN#">
	select a.ACcodigo, a.ACid, a.ACdescripcion, a.ACdepreciable, a.ACrevalua
	from AClasificacion a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!---Estados--->
<cfset rsEstados = QueryNew("Codigo,Descripcion")>
<cfset temp = QueryAddRow(rsEstados,3)>
<cfset temp = QuerySetCell(rsEstados,"Codigo",0,1)>
<cfset temp = QuerySetCell(rsEstados,"Codigo",1,2)>
<cfset temp = QuerySetCell(rsEstados,"Codigo",2,3)>
<cfset temp = QuerySetCell(rsEstados,"Descripcion","En Proceso",1)>
<cfset temp = QuerySetCell(rsEstados,"Descripcion","Por Generar",2)>
<cfset temp = QuerySetCell(rsEstados,"Descripcion","Por Aplicar",3)>
<!---Pinta el Formulario del filtro--->
<cfoutput>
<form action="#CurrentPage#" method="post" name="filtroagtproceso" style="margin:0" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin:0" class="AreaFiltro">
  <tr>
    <td>
			<table border="0" cellspacing="0" cellpadding="0" style="margin:0" width="100%">
				<tr>
					<td><strong>Descripci&oacute;n : </strong></td>
					<td>&nbsp;&nbsp;&nbsp;</td>
					
					<td><strong>Periodo : </strong></td>
					<td>&nbsp;&nbsp;&nbsp;</td>
					
					<td><strong>Mes : </strong></td>
					<td>&nbsp;&nbsp;&nbsp;</td>
					
					<td><strong>Fecha : </strong></td>
					<td>&nbsp;&nbsp;&nbsp;</td>
					
					<td><strong>Estado : </strong></td>
					<td>&nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>
					<td>
						<input name="FAGTPdescripcion" type="text" size="30" maxlength="80" tabindex="1"
						<cfif (isdefined("FAGTPdescripcion") and len(trim(FAGTPdescripcion)))>value="#FAGTPdescripcion#"</cfif>></td>
					<td>&nbsp;&nbsp;&nbsp;</td>

					
					<td>
						<select name="FAGTPperiodo" tabindex="1">
							<option value="">Todos</option>
							<cfloop query="rsPeriodo">
								<option value="#Pvalor#" <cfif (isdefined("FAGTPperiodo") and len(trim(FAGTPperiodo)) and FAGTPperiodo eq Pvalor)>selected</cfif>>#Pvalor#</option>
							</cfloop>
						</select>
					</td>
					<td>&nbsp;&nbsp;&nbsp;</td>

					
					<td><select name="FAGTPmes"><option value="">Todos</option><cfloop query="rsMeses"><option value="#Pvalor#" <cfif (isdefined("FAGTPmes") and len(trim(FAGTPmes)) and FAGTPmes eq Pvalor)>selected</cfif>>#Pdescripcion#</option></cfloop></select></td>
					<td>&nbsp;&nbsp;&nbsp;</td>

					
					<td><cfif (isdefined("FAGTPfalta") and len(trim(FAGTPfalta)))><cf_sifcalendario name="FAGTPfalta" form="filtroagtproceso" value="#FAGTPfalta#"><cfelse><cf_sifcalendario name="FAGTPfalta" form="filtroagtproceso"></cfif></td>
					<td>&nbsp;&nbsp;&nbsp;</td>

					
					<td><select name="FAGTPestado"><option value="">Todos</option><cfloop query="rsEstados"><option value="#codigo#" <cfif (isdefined("FAGTPestado") and len(trim(FAGTPestado)) and FAGTPestado eq codigo)>selected</cfif>>#descripcion#</option></cfloop></select></td>
					<td>&nbsp;&nbsp;&nbsp;</td>

				</tr>
			</table>
		</td>
		<td valign="middle"><cf_botones values="Filtrar"></td>
	</tr>
</table>
</form>
</cfoutput>
<!---Funciones en Javascript del formulario de filtro--->
<script language="javascript" type="text/javascript">
	<!--//
	function _forminit(){
		var form = document.filtroagtproceso;
		form.FAGTPdescripcion.focus();
	}
	_forminit();
//-->
</script>