<cf_templateheader title="Proyectos con Financiamiento">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Proyectos con Financiamiento'>
		<cf_navegacion name="CPPFid" default=""> 
		<cf_dbfunction name="OP_concat" returnvariable="CAT">
		<cfif form.CPPFid EQ "" and not isdefined("form.btnNuevo") and not isdefined("url.btnNuevo")>
			<strong>Periodo de Presupuesto:&nbsp;</strong>
			<cfif isdefined("url.CPPid")><cfset form.CPPid = url.CPPid></cfif>
			<cf_cboCPPid onchange="location.href='ProyectosFinanciamiento.cfm?CPPFid=#form.CPPFid#&CPPid='+ this.value;" session="true">
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pLista"
				returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="CPproyectosFinanciados a"/>
				<cf_dbfunction name="to_char" args="(select count(1) from CPproyectosFinanciadosCFs where CPPFid=a.CPPFid 	and CPPid=#session.CPPid#)" returnvariable="LvarCFs">
				<cf_dbfunction name="to_char" args="(select count(1) from CPproyectosFinanciados where CPPFid_padre=a.CPPFid)" returnvariable="LvarSPRs">
				<cfinvokeargument name="columnas" value="CPPFid, CPPFcodigo, CPPFdescripcion, 
						case when CPPFporCF = 1 then 'SI' #cat# '=' #cat# #LvarCFs# end as CPPFporCF,
						case when CPPFconSubproyectos = 1 then 'SI'  #cat# '=' #cat# #LvarSPRs# end as CPPFconSubproyectos,
						(select count(1) from CPproyectosFinanciadosCtas where CPPFid=a.CPPFid	and CPPid=#session.CPPid#) as Ctas
						"/>
				<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# and CPPFid_padre is null"/>
				<cfinvokeargument name="desplegar" value="CPPFcodigo, CPPFdescripcion,Ctas,CPPFconSubproyectos,CPPFporCF"/>
				<cfinvokeargument name="etiquetas" value="Codigo, Descripci&oacute;n,Máscaras,Con Subprys.,Por CF"/>
				<cfinvokeargument name="formatos" value="S,S,S,S,S,S,S"/>
				<cfinvokeargument name="align" value="left,left,center,center,center,center,center"/>
				<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N"/>
				<cfinvokeargument name="irA" value="ProyectosFinanciamiento.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="CPPFid"/>
				<cfinvokeargument name="PageIndex" value="1"/>
				<cfinvokeargument name="MaxRows" value="0"/>
				<cfinvokeargument name="Botones" value="Nuevo,Verificar_Cuentas"/>
			 </cfinvoke>
		<cfelse>
			<cfinclude template="ProyectosFinanciamiento_form.cfm">
		</cfif>
		<script language="javascript">
			function funcVerificar_Cuentas()
			{
				location.href="ProyectosFinanciamiento_sql.cfm?btnVerificar";
				return false;
			}
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>

			


