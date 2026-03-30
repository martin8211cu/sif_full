<!--- se redefine el tiempo máximo para que responda el request a 3600 segundos  --->
<cfsetting requesttimeout="3600">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="Msg_Error_Agrupando_Marcas" default="Error Agrupando Marcas"	 returnvariable="Msg_Error_Agrupando_Marcas" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="MSG_Proceso_Cancelado" default="Proceso Cancelado"	 returnvariable="MSG_Proceso_Cancelado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_El_grupo_de_marcas_debe_de_ser_para_un_solo_empleado" default="El grupo de marcas debe de ser para un solo empleado"	 returnvariable="MSG_EmpleadosDeGrupo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Se_ha_encontrado_una_inconsistencia_por_favor_verifique_de_nuevo_el_grupo_de_marcas" default="Se ha encontrado una inconsistencia, por favor verifique de nuevo el grupo de marcas" returnvariable="MSG_InconsistenciaGrupo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_No_se_ha_encontrado_la_marca" default="No se ha encontrado la marca"	 returnvariable="MSG_No_se_ha_encontrado_la_marca" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_La_cantidad_de_registros_por_agrupar_debe_ser_par" default="La cantidad de registros por agrupar debe ser par"	 returnvariable="MSG_cantidad_registros" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<!----=========== Agrupación de marcas =============---->
<cfif isdefined("form.btnAgrupar") and isdefined("form.chk") and len(trim(form.chk))>	
	<cfset Loop_Count = 0>
	<cfset Loop_DEid  = 0>
	<cfset Loop_Fecha = "">
	<cfset First_DEid = 0>
	<cfset First_Fecha = "">
	<cfset First_RHCMid = 0>
	<cfif ListLen(form.chk) Mod 2 NEQ 0>
		<cf_throw message="#Msg_Error_Agrupando_Marcas#, #MSG_cantidad_registros#, #MSG_Proceso_Cancelado#!" errorcode="5090">
	</cfif>
	<cfloop list="#form.chk#" index="item">
		<cfset Loop_DEid 	= ListGetAt(item,1,'|')>
		<cfset Loop_Fecha 	= ListGetAt(item,2,'|')>
		<cfset Loop_Count 	= Loop_Count + 1>
		<cfquery name="rsMarca" datasource="#session.DSN#">			
			select RHCMid, TipoMarca
			from RHControlMarcas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and fechahoramarca = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Loop_Fecha#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Loop_DEid#">
		</cfquery>
		<cfif rsMarca.Recordcount EQ 0>
			<cf_throw message="#Msg_Error_Agrupando_Marcas#, #MSG_No_se_ha_encontrado_la_marca#, #MSG_Proceso_Cancelado#!" errorcode="5095">
		</cfif>
		<cfif Loop_count EQ 1>
			<cfset First_DEid = Loop_DEid>
			<cfset First_Fecha = Loop_Fecha>
			<cfset First_RHCMid = Loop_DEid>
		</cfif>
		<cfif (Loop_count Mod 2 NEQ 0 and Trim(rsMarca.TipoMarca) NEQ "E")
			or (Loop_count Mod 2 EQ 0 and Trim(rsMarca.TipoMarca) NEQ "S")>
			<cf_throw message="#Msg_Error_Agrupando_Marcas#, #MSG_InconsistenciaGrupo#, #MSG_Proceso_Cancelado#!" errorcode="5100">
		</cfif>
		<cfif Loop_DEid NEQ First_DEid>
			<cf_throw message="#Msg_Error_Agrupando_Marcas#, #MSG_EmpleadosDeGrupo#, #MSG_Proceso_Cancelado#!" errorcode="5105">
		</cfif>
		<cfquery name="rsMarca" datasource="#session.DSN#">			
			update RHControlMarcas 
			set grupomarcas = <cfqueryparam cfsqltype="cf_sql_numeric" value="#First_RHCMid#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and fechahoramarca = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Loop_Fecha#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Loop_DEid#">
		</cfquery>
	</cfloop>
<!---================ Desagrupar marcas ===============---->
<cfelseif isdefined("form.btnDesagrupar")>
	<cfset va_arreglo =''>
	<cfset va_arreglo = ListToArray(chk ,',')>
	<!---============ Para cada fecha se desagrupa la familia completa =============== ---->	
	<cfloop index="i"  from="1" to="#ArrayLen(va_arreglo)#">		
		<cfset va_arreglofecha = ListToArray(va_arreglo[i] ,'|')>	
		<cfif ArrayLen(va_arreglofecha) EQ 2>
			<cfquery name="rsMarca" datasource="#session.DSN#">			
				select grupomarcas from RHControlMarcas 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and fechahoramarca = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#va_arreglofecha[2]#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#va_arreglofecha[1]#">
			</cfquery>
			<cfif len(trim(rsMarca.grupomarcas))>
				<cfquery datasource="#session.DSN#">
					update RHControlMarcas
						set grupomarcas = null
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and grupomarcas = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMarca.grupomarcas#">
				</cfquery>		
			</cfif>
		</cfif>
	</cfloop>
<cfelseif isdefined("form.btnAgruparAutNew1") and form.btnAgruparAutNew1 EQ 1>
	<cfinvoke component="rh.Componentes.RH_ProcesoAgrupaMarcas" method="RH_ProcesoAgrupaMarcas">
</cfif>
<cfoutput>
	<form name="form1" action="RevMarcas-tabs.cfm?tab=2" method="post">		
		<input type="hidden" name="btnFAFiltrar" value="btnFAFiltrar">	
		<input type="hidden" name="chk" value="<cfif isdefined("form.chk") and len(trim(form.chk))>#form.chk#</cfif>">	
		<input type="hidden" name="FADEid" value="<cfif isdefined("form.FADEid") and len(trim(form.FADEid))>#form.FADEid#</cfif>">		
		<input type="hidden" name="FADEIdentificacion" value="<cfif isdefined("form.FADEIdentificacion") and len(trim(form.FADEIdentificacion))>#form.FADEIdentificacion#</cfif>">
		<input type="hidden" name="FANombre" value="<cfif isdefined("form.FANombre") and len(trim(form.FANombre))>#form.FANombre#</cfif>">
		<input type="hidden" name="FAGrupo" value="<cfif isdefined("form.FAGrupo") and len(trim(form.FAGrupo))>#form.FAGrupo#</cfif>">
		<input type="hidden" name="FAver" value="<cfif isdefined("form.FAver") and len(trim(form.FAver))>#form.FAver#</cfif>">
		<input type="hidden" name="FAInicio_h" value="<cfif isdefined("form.FAInicio_h") and len(trim(form.FAInicio_h))>#form.FAInicio_h#</cfif>">	
		<input type="hidden" name="FAInicio_m" value="<cfif isdefined("form.FAInicio_m") and len(trim(form.FAInicio_m))>#form.FAInicio_m#</cfif>">	
		<input type="hidden" name="FAInicio_s" value="<cfif isdefined("form.FAInicio_s") and len(trim(form.FAInicio_s))>#form.FAInicio_s#</cfif>">	
		<input type="hidden" name="FAFin_h" value="<cfif isdefined("form.FAFin_h") and len(trim(form.FAFin_h))>#form.FAFin_h#</cfif>">	
		<input type="hidden" name="FAFin_m" value="<cfif isdefined("form.FAFin_m") and len(trim(form.FAFin_m))>#form.FAFin_m#</cfif>">	
		<input type="hidden" name="FAFin_s" value="<cfif isdefined("form.FAFin_s") and len(trim(form.FAFin_s))>#form.FAFin_s#</cfif>">
		<input type="hidden" name="FAfechaInicio" value="<cfif isdefined("form.FAfechaInicio") and len(trim(form.FAfechaInicio))>#form.FAfechaInicio#</cfif>">
		<input type="hidden" name="FAfechaFinal" value="<cfif isdefined("form.FAfechaFinal") and len(trim(form.FAfechaFinal))>#form.FAfechaFinal#</cfif>">
		<input type="hidden" name="FAEstado" value="<cfif isdefined("form.FAEstado") and len(trim(form.FAEstado))>#form.FAEstado#</cfif>">	
	</form>
</cfoutput>
<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>
