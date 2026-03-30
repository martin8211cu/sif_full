<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Grupos de Oficinas" 
returnvariable="LB_Titulo" xmlfile="gruposOficinas.xml"/>

<cf_templateheader title="#LB_Titulo#">
		<cf_web_portlet_start titulo="#LB_Titulo#">
		
			<cfinclude template="/home/menu/pNavegacion.cfm">
			<!--- --->
			<cfinclude template="gruposOficinas-filtro.cfm">
			<!---  NAVEGACION--->
	
			<cfset navegacion = "">
			
			<cfif isdefined("form.Codigo_F") and Len(Trim(form.Codigo_F)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Codigo_F=" & Form.Codigo_F>
			</cfif>
			
			<cfif isdefined("form.Descripcion_F") and Len(Trim(form.Descripcion_F)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Descripcion_F=" & Form.Descripcion_F>
			</cfif>
			<!--- --->
			
			<cfquery name="lista" datasource="#session.DSN#">
				select a.GOid, a.GOcodigo, a.GOnombre,
						(select Count(b.GOid)
						from AnexoGOficinaDet b
						where b.GOid = a.GOid)
						as oficinasCount
				from AnexoGOficina a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				
				<!--- filtro por codigo --->
				<cfif isdefined('form.Codigo_F') and form.Codigo_F NEQ ''>
					and ltrim(rtrim(upper(GOcodigo))) like '%#trim(ucase(form.Codigo_F))#%'
				</cfif>	
				
				<!--- filtro por Descripcion --->
				<cfif isdefined('form.Descripcion_F') and form.Descripcion_F NEQ ''>
					and ltrim(rtrim(upper(GOnombre))) like '%#trim(ucase(form.Descripcion_F))#%'
				</cfif>
				
				order by GOcodigo, GOnombre
			</cfquery>
		
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#lista#"/>
				<cfinvokeargument name="desplegar" value="GOcodigo, GOnombre,oficinasCount"/>
				<cfinvokeargument name="etiquetas" value="C&oacute;digo,Nombre,Cantidad de Oficinas"/>
				<cfinvokeargument name="formatos" value="V, V,I"/>
				<cfinvokeargument name="align" value="left, left,center"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="gruposOficinas-form.cfm"/>
				<cfinvokeargument name="keys" value="GOid"/>
				<cfinvokeargument name="showemptylistmsg" value="true"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="maxrows" value="17"/>
				
			</cfinvoke>
		<cf_web_portlet_end>
	<cf_templatefooter>
