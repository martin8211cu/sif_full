<cfparam name="modo" default="ALTA">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
<cf_web_portlet_start border="true" titulo="Registro de Movimientos" skin="#Session.Preferences.Skin#">
	<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
	<cfquery name="rsSelectMovimientos" datasource="#session.dsn#">
		select pet.PETid, p.Pcodigo #_Cat# ' - ' #_Cat# p.Pdescripcion as DesPeaje, 
			pt.PTcodigo, pet.PETfecha 
		from PETransacciones pet 
			inner join Peaje p 
				on p.Pid=pet.Pid 
			inner join PTurnos pt 
				on pt.PTid = pet.PTid 
		where pet.BMUsucodigo = #session.usucodigo# and pet.Ecodigo = #session.Ecodigo# and pet.PETestado = 1
		<cfif isdefined('form.filtro_DesPeaje') and len(trim(form.filtro_DesPeaje))>
		and (lower(p.Pcodigo) like <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_DesPeaje)#%">
			or lower(p.Pdescripcion) like <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_DesPeaje)#%">)
		</cfif>
		<cfif isdefined('form.filtro_PTcodigo') and len(trim(form.filtro_PTcodigo))>
		and lower(pt.PTcodigo) like <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="%#Lcase(form.filtro_PTcodigo)#%">
		</cfif>
		<cfif isdefined('form.filtro_PETfecha') and len(trim(form.filtro_PETfecha))>
			<cfif isdefined('form.filtro_FECHASMAYORES')>
				and pet.PETfecha > <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.filtro_PETfecha)#">
			<cfelse> 
				and pet.PETfecha = <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.filtro_PETfecha)#">
			</cfif>
		</cfif>
		order by p.Pcodigo DESC,  pet.PETfecha DESC, pt.PTcodigo
	</cfquery>
	<table width="100%" border="1">
		<tr><td>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#rsSelectMovimientos#" 
				conexion="#session.dsn#"
				desplegar="DesPeaje, PTcodigo, PETfecha"
				etiquetas="Descripción Reg. Movimiento , Cód. Turno, Fecha"
				formatos="S,S,D"
				mostrar_filtro="true"
				align="left,left,left"
				checkboxes="S"
				botones="Eliminar,Nuevo"
				ira="registroMovimientos.cfm"
				keys="PETid">
			</cfinvoke>
		</td></tr>
	</table>
<cf_web_portlet_end>
<cf_templatefooter>
<cfoutput>
<script language="javascript1.2" type="text/javascript">
	
	function algunoMarcado(){
		f = document.lista;
		if (f.chk != null) {
			if (f.chk.value) {
				if (f.chk.checked) {
					return true;
				}
			} else {
				for (var i=0; i<f.chk.length; i++) {
					if (f.chk[i].checked) {
						return true;
					}
				}
			}
		} 
		alert("Debe marcar al menos un elemento de la lista para realizar esta accion!");
		return false;
	}

	function funcEliminar(){
		if (algunoMarcado()){
			if(confirm("Desea eliminar los datos marcados?"))
				return true;
			else
				return false;
		}
		else
			return false; 
		return false;
	}
</script>
</cfoutput>