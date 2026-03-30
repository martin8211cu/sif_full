<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Grupos de Empresas" 
returnvariable="LB_Titulo" xmlfile="gruposEmpresas.xml"/>

<cf_templateheader title="#LB_titulo#">
	<cf_web_portlet_start titulo="#LB_titulo#">
	
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<!--- --->
		<cfinclude template="gruposEmpresas-filtro.cfm">
		<!---  NAVEGACION--->

		<cfset navegacion = "">
		
		<cfif isdefined("Form.Codigo_F") and Len(Trim(Form.Codigo_F)) NEQ 0>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Codigo_F=" & Form.Codigo_F>
		</cfif>
		
		<cfif isdefined("Form.Descripcion_F") and Len(Trim(Form.Descripcion_F)) NEQ 0>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Descripcion_F=" & Form.Descripcion_F>
		</cfif>
		<!--- --->
		
		<cfquery name="lista" datasource="#session.DSN#">
			select a.GEid, a.GEcodigo, a.GEnombre,
					(select Count(b.GEid)
					from AnexoGEmpresaDet b
					where b.GEid = a.GEid)
					as empresasCount
			from AnexoGEmpresa a
			where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			
			<!--- filtro por codigo --->
			<cfif isdefined('form.Codigo_F') and form.Codigo_F NEQ ''>
				and ltrim(rtrim(upper(GEcodigo))) like '%#trim(ucase(form.Codigo_F))#%'
			</cfif>	
			
			<!--- filtro por Descripcion --->
			<cfif isdefined('form.Descripcion_F') and form.Descripcion_F NEQ ''>
				and ltrim(rtrim(upper(GEnombre))) like '%#trim(ucase(form.Descripcion_F))#%'
			</cfif>
			
			order by GEcodigo, GEnombre
		</cfquery>
	
		<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#lista#"/>
					<cfinvokeargument name="desplegar" value="GEcodigo, GEnombre,empresasCount"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo,Nombre,Cantidad de Empresas"/>
					<cfinvokeargument name="formatos" value="V, V,I"/>
					<cfinvokeargument name="align" value="left, left,center"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="gruposEmpresas-form.cfm"/>
					<cfinvokeargument name="keys" value="GEid"/>
					<cfinvokeargument name="showemptylistmsg" value="true"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="maxrows" value="17"/>
					
				</cfinvoke>
		
		<script type="text/javascript" defer>
		<!--
			function mostrar(AnexoId){
				location.href='gruposEmpresas-form.cfm?GrupoEmpId=' +  escape (GEid);
			}
			function funcNuevo(){
				location.href='gruposEmpresas-form.cfm';
				return false;
			}
		//-->
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>
