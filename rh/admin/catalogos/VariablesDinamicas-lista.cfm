<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
			<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnGetEVariablesDinamicas" returnvariable="rsListadoEVD">
				<cfinvokeargument name="Ecodigo" value="#session.ecodigo#">
				<cfif isdefined('form.RHEVDcodigo') and len(trim(form.RHEVDcodigo))>
					<cfinvokeargument name="RHEVDcodigo" 	  value="#form.RHEVDcodigo#">
				</cfif>
				<cfif isdefined('form.RHEVDdescripcion') and len(trim(form.RHEVDdescripcion))>
					<cfinvokeargument name="RHEVDdescripcion"  value="#form.RHEVDdescripcion#">
				</cfif>
			</cfinvoke>
			<cfquery name="rsRHEVDtipo" datasource="#session.dsn#">
					select -1 as value, '-Todos-' DESCRIPTION	from dual
						union all
					select 1 as value , 'Finiquito' DESCRIPTION 	from dual
						union all
					select 2 as value, 'Liquidación' DESCRIPTION 	from dual
						union all
					select 3 as value, 'PTU' DESCRIPTION 	from dual
			</cfquery>
			<cfinvoke 
				component		= "sif.Componentes.pListas" 
				method			= "pListaQuery" 
				query			= "#rsListadoEVD#" 
				conexion		= "#session.dsn#"
				desplegar		= "RHEVDcodigo,RHEVDdescripcion,RHEVDtipoDescripcion"
				etiquetas		= "Código,Descripción,Tipo"
				formatos		= "S,S,S"
				mostrar_filtro	= "true"
				align			= "left,left,left"
				checkboxes		= "N"
				botones			= "Nuevo"
				irA				= "VariablesDinamicas.cfm"
				rsRHEVDtipoDescripcion		= "#rsRHEVDtipo#"
				keys			= "RHEVDid"
			>
			</cfinvoke>
		</td>
	</tr>
</tr>
