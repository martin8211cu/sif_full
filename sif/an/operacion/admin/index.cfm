<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Administración de Anexos" 
returnvariable="LB_Titulo" xmlfile="index.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Anexo" 	default="Anexo" 
returnvariable="LB_Anexo" xmlfile="index.xml"/>


<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start titulo="#LB_Titulo#">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<cfquery datasource="#session.dsn#" name="lista">
			select coalesce(g.GAnombre, 'Sin agrupar') as GAnombre, g.GAid,
				a.AnexoId, coalesce (a.AnexoDes, 'Sin nombre') as AnexoDes
			from Anexo a
				left join AnexoGrupo g
					on g.GAid = a.GAid
				join AnexoPermisoDef pd
					on (pd.GAid = a.GAid or pd.AnexoId = a.AnexoId)
					and pd.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					and pd.APedit = 1
				join AnexoEm ae
					on ae.AnexoId = a.AnexoId
					and ae.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			<cfif isdefined ('form.filtro_AnexoDes') and len(trim(form.filtro_AnexoDes)) gt 0>
				and lower(AnexoDes) like lower('%#form.filtro_AnexoDes#%')
			</cfif>
			order by g.GAnombre, a.AnexoDes
		</cfquery> 
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="AnexoDes"
			etiquetas="#LB_Anexo#"
			formatos="V"
			align="left"
			irA="anexo.cfm"
			keys="AnexoId"
			cortes="GAnombre"
			showEmptyListMsg="true"
			mostrar_filtro="true"
			funcion=""
			fparams=""
			
		/>
		
		<form name="formBotones">
		<cf_botones values="Nuevo" names="Nuevo" ></form>
		<script language="javascript" type="text/javascript" defer>
			function mostrar(AnexoId){
				location.href='anexo.cfm?AnexoId=' +  escape (AnexoId);
			}
			function funcNuevo(){
				location.href='anexo.cfm';
				return false;
			}
		</script>
	<cf_web_portlet_end>
	<cf_templatefooter>
