<cf_dbfunction name="now" returnvariable="hoy">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfset navegacion = "">
<!---filtro--->
<cfset filtro = "a.Ecodigo=#session.Ecodigo#">

<cfif isdefined('form.CFidIni') and len(trim(form.CFidIni))>
	<cfset navegacion = navegacion & "&CFidIni=#form.CFidIni#">
	<cfset filtro = filtro & " and CFid >= #form.CFidIni#">
</cfif>	

<cfif isdefined('form.CFidFin') and len(trim(form.CFidFin))>
		<cfset filtro = filtro & " and CFid <= #form.CFidFin#">
</cfif>	

<cfif isdefined('form.filtro_DEidentificacion') and len(trim(form.filtro_DEidentificacion))>
	<cfset filtro = filtro & " and upper(DEidentificacion) like '%#Ucase(Form.filtro_DEidentificacion)#%'">
</cfif>

<cfif isdefined('form.filtro_DEnombre') and len(trim(form.filtro_DEnombre))>
	<cfset filtro = filtro & " and upper(b.DEapellido1 #_Cat# ' ' #_Cat# b.DEapellido2 #_Cat# ' ' #_Cat# b.DEnombre) like '%#Ucase(Form.filtro_DEnombre)#%'">   
</cfif>

<cfif isdefined('form.filtro_Estado') and len(trim(form.filtro_Estado)) and #form.filtro_Estado# neq -1>
	<cfset filtro = filtro & " and (case when #hoy# between a.ECFdesde and a.ECFhasta then 1 else 2 end) = #form.filtro_Estado#">
</cfif>	

<!--- Lista de Empleados --->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr> 
		<td width="30%" valign="top">
		<cfset Filtrar_Por_Array = ListToArray("b.DEidentificacion| b.DEapellido1 #_Cat#' ' #_Cat# b.DEapellido2 #_Cat#' '#_Cat# b.DEnombre |case when (#hoy# between a.ECFdesde and a.ECFhasta) then 1 else 2 end","|")>
			
		<cfquery name="Lista" datasource="#session.dsn#">
			select 
				a.CFid,
				a.DEid,
				b.DEidentificacion,
				b.DEapellido1 #_Cat# ' ' #_Cat# b.DEapellido2 #_Cat# ' ' #_Cat# b.DEnombre as DEnombre,
				case when (#hoy# between a.ECFdesde and a.ECFhasta) then 'Activo' else 'Inactivo' end as Estado,
				(select c.CFdescripcion from CFuncional c where a.CFid = c.CFid) as CFdescripcion
			from EmpleadoCFuncional a
			inner join DatosEmpleado b on
				a.DEid = b.DEid
		where #preservesinglequotes(filtro)#
		order by CFdescripcion,DEapellido1
	</cfquery>

	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#Lista#"
			desplegar="DEidentificacion,DEnombre,Estado"
			etiquetas="Identificaci&oacute;n,Nombre,Estado"
			formatos="S,S,S,S,S"
			align="left,left,left"
			ajustar="N,N,N"
			checkboxes="N"
			keys="DEid,CFid"
			MaxRows="20"
			MaxRowsQuery="500"
			filtrar_automatico="true"
			mostrar_filtro="true"
			filtrar_por_array="#Filtrar_Por_Array#"
			cortes="CFdescripcion"
			navegacion="#navegacion#"
			irA="datoeEmpleado-form.cfm"
			rsEstado="#qryEstadosEmpleado#"
			showEmptyListMsg="true"
			incluyeform="false" />
		</td>
	</tr>
</table>

<cfoutput>
<script language="javascript1.2" type="text/javascript">
	function funcFiltrar() {
		<cfif isDefined("form.CFidIni") and len(trim(form.CFidIni)) and isDefined("form.CFidFin") and len(trim(form.CFidFin))>
			document.lista.action = "datosEmpleado.cfm?CFidIni=#form.CFidIni#&CFidFin=#form.CFidFin#";
		<cfelse>
			document.lista.action = "datosEmpleado.cfm";
		</cfif>
		document.lista.submit();
	}
</script>
</cfoutput>