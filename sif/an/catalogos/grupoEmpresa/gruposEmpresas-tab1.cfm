<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_DatosGenerales" 	default="Datos Generales" 
returnvariable="LB_DatosGenerales" xmlfile="gruposEmpresas-tab1.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Codigo" 	default="C&oacute;digo" 
returnvariable="LB_Codigo" xmlfile="gruposEmpresas-tab1.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Nombre" 	default="Nombre" 
returnvariable="LB_Nombre" xmlfile="gruposEmpresas-tab1.xml"/>

<cfif isdefined('url.GEid') and not isdefined('form.GEid')>
	<cfparam name="form.GEid" default="#url.GEid#">
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined('form.GEid') and len(trim(form.GEid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select GEid, GEcodigo, GEnombre,ts_rversion
		from AnexoGEmpresa
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		<cfif IsDefined("form.GEid")>
		and  GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEid#">
		</cfif>
	</cfquery>
	
</cfif>	
	
<cfoutput>
<form name="form1" method="post" action="gruposEmpresas-tab1-sql.cfm">
	
	<table width="100%" cellpadding="3" cellspacing="0">
		
		<cfif isdefined('form.Descripcion_F') and len(trim(form.Descripcion_F))>
        	<input type="hidden" name="Descripcion_F" value="#form.Descripcion_F#">
      	</cfif>
		<tr><td colspan="2" align="center" class="tituloListas" >#LB_DatosGenerales#</td></tr>
		<tr>
			<td align="right"><strong>#LB_Codigo#</strong></td>
        	<td>
				<input type="text" name="GEcodigo" size="10" maxlength="10" value="<cfif modo neq 'ALTA'>#data.GEcodigo#</cfif>">
			</td>
		</tr>
		
		<tr>
			<td align="right"><strong>#LB_Nombre#</strong></td>
        	<td >
				<input type="text" name="GEnombre" size="50" maxlength="80" value="<cfif modo neq 'ALTA'>#data.GEnombre#</cfif>">
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO'>
					<input type="hidden" name="GEid" value="#data.GEid#">
					
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>
	</table>
	
</form>

<!-- MANEJA LOS ERRORES  NOTA:QUE REVISEN ESTO EN LA BD! --->
<cf_qforms>
<script language="javascript" type="text/javascript">
	<!--//
		objForm.GEcodigo.required = true;
		objForm.GEcodigo.description = "Codigo";
		objForm.GEnombre.required = true;
		objForm.GEnombre.description = "Nombre";
	//-->
</script>
</cfoutput>