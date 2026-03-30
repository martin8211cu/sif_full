<!--- Este filtro está preparado para filtrar pot mas campos de los que están pintados, los campos pintados inicialmente son Placa, Categoría Clase y 
Centro Funcional, pero se pueden simplemente agreagar o quitar cualquiera de los indicados en la siguiente lista y el filtro funcionaria con cualquiera 
de ellos.--->
<!---	Filtro preparado para filtrar por: Aplaca, Aserie, Activo, Categoria, Clase, Periodo, Mes, Oficina, CentroF, TAfalta, TAmontoloc--->
<cfscript>
//Procesa los datos del filtro cuando vienen en url
if (isdefined("url.FAplaca") and len(trim(url.FAplaca))) FAplaca = url.FAplaca;
if (isdefined("url.FAserie") and len(trim(url.FAserie))) FAserie = url.FAserie;
if (isdefined("url.FActivo") and len(trim(url.FActivo))) FActivo = url.FActivo;
if (isdefined("url.FCategoria") and len(trim(url.FCategoria))) FCategoria = url.FCategoria;
if (isdefined("url.FClase") and len(trim(url.FClase))) FClase = url.FClase;
if (isdefined("url.FPeriodo") and len(trim(url.FPeriodo))) FPeriodo = url.FPeriodo;
if (isdefined("url.FMes") and len(trim(url.FMes))) FMes = url.FMes;
if (isdefined("url.FOficina") and len(trim(url.FOficina))) FOficina = url.FOficina;
if (isdefined("url.FDepartamento") and len(trim(url.FDepartamento))) FDepartamento = url.FDepartamento;
if (isdefined("url.FCentroF") and len(trim(url.FCentroF))) FCentroF = url.FCentroF;
if (isdefined("url.FTAfalta") and len(trim(url.FTAfalta))) FTAfalta = url.FTAfalta;
if (isdefined("url.FTAmontoloc") and len(trim(url.FTAmontoloc))) FTAmontoloc = url.FTAmontoloc;
//Procesa los datos del filtro cuando vienen en form
if (isdefined("form.FAplaca") and len(trim(form.FAplaca))) FAplaca = form.FAplaca;
if (isdefined("form.FAserie") and len(trim(form.FAserie))) FAserie = form.FAserie;
if (isdefined("form.FActivo") and len(trim(form.FActivo))) FActivo = form.FActivo;
if (isdefined("form.FCategoria") and len(trim(form.FCategoria))) FCategoria = form.FCategoria;
if (isdefined("form.FClase") and len(trim(form.FClase))) FClase = form.FClase;
if (isdefined("form.FPeriodo") and len(trim(form.FPeriodo))) FPeriodo = form.FPeriodo;
if (isdefined("form.FMes") and len(trim(form.FMes))) FMes = form.FMes;
if (isdefined("form.FOficina") and len(trim(form.FOficina))) FOficina = form.FOficina;
if (isdefined("form.FDepartamento") and len(trim(form.FDepartamento))) FDepartamento = form.FDepartamento;
if (isdefined("form.FCentroF") and len(trim(form.FCentroF))) FCentroF = form.FCentroF;
if (isdefined("form.FTAfalta") and len(trim(form.FTAfalta))) FTAfalta = form.FTAfalta;
if (isdefined("form.FTAmontoloc") and len(trim(form.FTAmontoloc))) FTAmontoloc = form.FTAmontoloc;
//Procesa los datos para crear el filtro y la navegacion
if (isdefined("FAplaca") and len(trim(FAplaca))) { filtro = filtro & " and c.Aplaca like '%#FAplaca#%'"; navegacion = navegacion & "&FAplaca=#FAplaca#";}
if (isdefined("FAserie") and len(trim(FAserie))) { filtro = filtro & " and c.Aserie like '%#FAserie#%'"; navegacion = navegacion & "&FAserie=#FAserie#";}
if (isdefined("FActivo") and len(trim(FActivo))) { filtro = filtro & " and c.Adescripcion like '%#FActivo#%'"; navegacion = navegacion & "&FActivo=#FActivo#";}
if (isdefined("FCategoria") and len(trim(FCategoria))) { filtro = filtro & " and c.ACcodigo = #FCategoria#"; navegacion = navegacion & "&FCategoria=#FCategoria#";}
if (isdefined("FClase") and len(trim(FClase))) { filtro = filtro & " and c.ACid = #FClase#"; navegacion = navegacion & "&FClase=#FClase#";}
if (isdefined("FPeriodo") and len(trim(FPeriodo))) { filtro = filtro & " and a.TAperiodo = #FPeriodo#"; navegacion = navegacion & "&FPeriodo=#FPeriodo#";}
if (isdefined("FMes") and len(trim(FMes))) { filtro = filtro & " and a.TAmes = #FMes#"; navegacion = navegacion & "&FMes=#FMes#";}
if (isdefined("FOficina") and len(trim(FOficina))) { filtro = filtro & " and f.Ocodigo = #FOficina#"; navegacion = navegacion & "&FOficina=#FOficina#";}
if (isdefined("FDepartamento") and len(trim(FDepartamento))) { filtro = filtro & " and f.Dcodigo = #FDepartamento#"; navegacion = navegacion & "&FDepartamento=#FDepartamento#";}
if (isdefined("FCentroF") and len(trim(FCentroF))) { filtro = filtro & " and a.CFid = #FCentroF#"; navegacion = navegacion & "&FCentroF=#FCentroF#";}
if (isdefined("FTAfalta") and len(trim(FTAfalta))) { filtro = filtro & " and a.TAfalta >= #LSDateFormat(FTAfalta,'yyyymmdd')#"; navegacion = navegacion & "&FTAfalta=#FTAfalta#";}
if (isdefined("FTAmontoloc") and len(trim(FTAmontoloc))) { filtro = filtro & " and a.TAmontoloc >= #FTAmontoloc#"; navegacion = navegacion & "&FTAmontoloc=#FTAmontoloc#";}
</cfscript>

<!--- FILTROS DE LA LISTA --->
<cfset params = ''>
<cfif isdefined('form.Filtro_AGTPdescripcion')>
	<cfset params = params & 'Filtro_AGTPdescripcion=#form.Filtro_AGTPdescripcion#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPestadoDesc')>
	<cfset params = params & '&Filtro_AGTPestadoDesc=#form.Filtro_AGTPestadoDesc#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPfalta')>
	<cfset params = params & '&Filtro_AGTPfalta=#form.Filtro_AGTPfalta#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPmesDesc')>
	<cfset params = params & '&Filtro_AGTPmesDesc=#form.Filtro_AGTPmesDesc#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPperiodo')>
	<cfset params = params & '&Filtro_AGTPperiodo=#form.Filtro_AGTPperiodo#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPdescripcion')>
	<cfset params = params & '&HFiltro_AGTPdescripcion=#form.HFiltro_AGTPdescripcion#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPestadoDesc')>
	<cfset params = params & '&HFiltro_AGTPestadoDesc=#form.HFiltro_AGTPestadoDesc#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPfalta')>
	<cfset params = params & '&HFiltro_AGTPfalta=#form.HFiltro_AGTPfalta#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPmesDesc')>
	<cfset params = params & '&HFiltro_AGTPmesDesc=#form.HFiltro_AGTPmesDesc#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPperiodo')>
	<cfset params = params & '&HFiltro_AGTPperiodo=#form.HFiltro_AGTPperiodo#'>
</cfif>

<cfif isdefined('form.params')>
	<cfset params = form.params>
</cfif>
<!--- FILTROS DE LA LISTSA --->


<!---Consultas para pintar el formulario--->
<!---Categorias--->
<cfquery name="rsCategorias" datasource="#Session.DSN#">
	select ACcodigo, ACdescripcion, ACmascara
	from ACategoria 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!---Clases se llenan automáticamente cuando cambia la categoria--->
<cfquery name="rsClases" datasource="#Session.DSN#">
	select a.ACcodigo, a.ACid, a.ACdescripcion, a.ACdepreciable, a.ACrevalua
	from AClasificacion a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!---Pinta el Formulario del filtro--->
<cfoutput>
<!---Incluye Javascript con funciones para manejo de montos--->
<script language="javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<form action="#CurrentPage#" method="post" name="filtroagtproceso" style="margin:0" value="" onSubmit="javascript:_formclose();">
<input type="hidden" name="AGTPid" value="#AGTPid#" tabindex="-1">
<input name="params" type="hidden" value="#params#" tabindex="-1">
<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tituloListas" style="margin:0">
  <tr>
    <td>
			<table border="0" cellspacing="0" cellpadding="0" style="margin:0">
				<tr>
					<td nowrap><strong>Placa :&nbsp; </strong></td>
					<td nowrap><strong>Categor&iacute;a :&nbsp; </strong></td>
					<td nowrap><strong>Clase :&nbsp; </strong></td>
					<td nowrap><strong>Centro Funcional :&nbsp; </strong></td>
				</tr>
				<tr>
					<td><input type="text" name="FAplaca" size="15" maxlength="20" tabindex="1" style="text-transform:uppercase" <cfif (isdefined("FAplaca") and len(trim(FAplaca)))>value="#FAplaca#"</cfif>></td>
					<td><select name="FCategoria" onChange="javascript:AgregarCombo(this);" tabindex="1"><option value="">Todos</option><cfloop query="rsCategorias"><option value="#Trim(ACcodigo)#" <cfif (isdefined("FCategoria") and len(trim(FCategoria)) and FCategoria eq ACcodigo)>selected</cfif>>#ACdescripcion#</option></cfloop></select></td>
					<td><select name="FClase" tabindex="1"><!--- Las opciones se defininen dinámicamente cuando cambia la categoría ---></select></td>
					<td>
					<cfset ValuesArray = ArrayNew(1)>
					<cfif (isdefined("FCentroF") and len(trim(FCentroF)))>
						<cfquery name="rsQryCentroF" datasource="#session.dsn#">
							select CFid as FCentroF, CFcodigo, CFdescripcion
							from CFuncional
							where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCentroF#">
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						</cfquery>
						<cfset ArrayAppend(ValuesArray,rsQryCentroF.FCentroF)>
						<cfset ArrayAppend(ValuesArray,rsQryCentroF.CFcodigo)>
						<cfset ArrayAppend(ValuesArray,rsQryCentroF.CFdescripcion)>
					</cfif>
					<cf_conlis 
							form="filtroagtproceso" 
							campos="FCentroF,FCFcodigo,FCFdescripcion" 
							ValuesArray = "#ValuesArray#"
							desplegables="N,S,S"
							modificables="N,S,S"
							size="0,10,30"
							title="Lista de Centros Funcionales"
							tabla="CFuncional"
							columnas="CFid as FCentroF, CFcodigo as FCFcodigo, CFdescripcion as FCFdescripcion"
							filtro="Ecodigo = #session.Ecodigo# order by CFpath, CFcodigo, CFnivel"
							desplegar="FCFcodigo,FCFdescripcion"
							filtrar_por="CFcodigo,CFdescripcion"
							etiquetas="Código, Descripción"
							formatos="S,S"
							align="left,left"
							asignar="FCentroF,FCFcodigo,FCFdescripcion"
							asignarformatos="I,S,S"
							maxrowsquery="250"
							funcion="setDescripcion" 
							tabindex="1">
					</td>
				</tr>
		</table>
		</td>
		<td valign="middle"><cf_botones values="Filtrar" tabindex="1"></td>
	</tr>
</table>
</form>
</cfoutput>
<!---Funciones en Javascript del formulario de filtro--->
<script language="javascript" type="text/javascript">
	<!--//
	function AgregarCombo(codigo) {
		var combo = document.filtroagtproceso.FClase;
		var cont = 0;
		codigo = codigo.value;
		combo.length=0;
		combo.length=cont+1;
		combo.options[cont].value='';
		combo.options[cont].text='Todos';
		cont++;
		<cfoutput query="rsClases">
			if ('#Trim(ACcodigo)#'==codigo) 
			{
				combo.length=cont+1;
				combo.options[cont].value='#rsClases.ACid#';
				combo.options[cont].text='#rsClases.ACdescripcion#';
				<cfif (isdefined("FClase") and len(trim(FClase)) and FClase eq rsClases.ACid)>
					combo.options[cont].selected=true;
				</cfif>
				cont++;
			};
		</cfoutput>
	}
	function _forminit(){
		var form = document.filtroagtproceso;
		AgregarCombo(form.FCategoria);
		form.FAplaca.focus();
	}
	_forminit();
	function _formclose(){
	}
//-->
</script>