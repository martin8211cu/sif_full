<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_DatosGenerales" 	default="Datos Generales" 
returnvariable="LB_DatosGenerales" xmlfile="gruposOficinas-tab1.xml"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Codigo" 	default="C&oacute;digo" 
returnvariable="LB_Codigo" xmlfile="gruposOficinas-tab1.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Nombre" 	default="Nombre" 
returnvariable="LB_Nombre" xmlfile="gruposOficinas-tab1.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Tipo" 	default="Tipo" 
returnvariable="LB_Tipo" xmlfile="gruposOficinas-tab1.xml"/>

<cfif isdefined('url.GOid') and not isdefined('form.GOid')>
	<cfparam name="form.GOid" default="#url.GOid#">
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined('form.GOid') and len(trim(form.GOid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfquery name="rsGOT" datasource="#session.DSN#">
	select a.GOTid, a.GOTcodigo, a.GOTnombre
	  from AnexoGOTipo a
	 where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select GOid, GOcodigo, GOnombre, GOTid, ts_rversion
		from AnexoGOficina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif IsDefined("form.GOid")>
		and  GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GOid#">
		</cfif>
	</cfquery>
	
</cfif>	
	
<cfoutput>
<form name="form1" method="post" action="gruposOficinas-tab1-sql.cfm">
	
	<table width="100%" cellpadding="3" cellspacing="0">
		
		<cfif isdefined('form.Descripcion_F') and len(trim(form.Descripcion_F))>
        	<input type="hidden" name="Descripcion_F" value="#form.Descripcion_F#">
      	</cfif>
		<tr><td colspan="2" align="center" class="tituloListas" >#LB_DatosGenerales#</td></tr>
		<tr>
			<td align="right"><strong>#LB_Codigo#</strong></td>
        	<td>
				<input type="text" name="GOcodigo" size="10" maxlength="10" value="<cfif modo neq 'ALTA'>#data.GOcodigo#</cfif>">
			</td>
		</tr>
		
		<tr>
			<td align="right"><strong>#LB_Nombre#</strong></td>
        	<td >
				<input type="text" name="GOnombre" size="50" maxlength="80" value="<cfif modo neq 'ALTA'>#data.GOnombre#</cfif>">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>#LB_Tipo#</strong></td>
        	<td>
				<select name="GOTid">
					<option value="">(Sin Tipo)</option>
				<cfloop query="rsGOT">
					<option value="#rsGOT.GOTid#" <cfif modo neq 'ALTA' AND rsGOT.GOTid EQ data.GOTid>selected</cfif>>#rsGOT.GOTcodigo# - #rsGOT.GOTnombre#</option>
				</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO'>
					<input type="hidden" name="GOid" value="#data.GOid#">
					
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>
	</table>
	<cfif modo neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion_GOfi" value="#ts#">
	</cfif>
</form>

<!-- MANEJA LOS ERRORES  NOTA:QUE REVISEN ESTO EN LA BD! --->
<cf_qforms>
<script language="javascript" type="text/javascript">
	<!--//
		objForm.GOcodigo.required = true;
		objForm.GOcodigo.description = "Codigo";
		objForm.GOnombre.required = true;
		objForm.GOnombre.description = "Nombre";
	//-->
</script>
</cfoutput>