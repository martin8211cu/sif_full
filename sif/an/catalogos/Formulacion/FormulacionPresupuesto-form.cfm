<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Codigo" 	default="C&oacute;digo" 
returnvariable="LB_Codigo" xmlfile="FormulacionPresupuesto-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Descripcion" 	default="Descripci&oacute;n" 
returnvariable="LB_Descripcion" xmlfile="FormulacionPresupuesto-form.xml"/>
<cfset modo = "ALTA">
<cfif isdefined("form.ANFid") and len(trim(form.ANFid))>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		 select  ANFid,ANFcodigo,ANFdescripcion, ts_rversion
   				from ANformulacion
		where ANFid =#form.ANFid# 
	</cfquery>
</cfif>

<form style="margin:0;" name="form1" action="FormulacionPresupuesto-sql.cfm" method="post">
	<!---Codigo--->
	<table align="center" width="100%" cellpadding="2" cellspacing="0" border="0" >
		<tr>
			<td nowrap align="right"><strong><cfoutput>#LB_Codigo#</cfoutput>: </strong></td>
			<td nowrap>
				<input type="text" name="ANFcodigo" size="8" maxlength="15" value="<cfif modo neq 'ALTA'><cfoutput>#data.ANFcodigo#</cfoutput></cfif>" onfocus="this.select();" <cfif modo neq 'ALTA'>readonly</cfif> >
			</td>
		</tr>
	<!---Descripción--->	
		<tr>
			<td nowrap align="right"><strong><cfoutput>#LB_Descripcion#</cfoutput>: </strong></td>
			<td nowrap>
				<input type="text" name="ANFdescripcion" size="50" maxlength="80" value="<cfif modo neq 'ALTA'><cfoutput>#data.ANFdescripcion#</cfoutput></cfif>" onfocus="this.select();">
			</td>
		</tr>
	<!--- Portles de Botones --->
		<tr><td nowrap colspan="2">&nbsp;</td></tr>
		<tr>
			<td nowrap colspan="2" align="center">
				<cfinclude template="/sif/portlets/pBotones.cfm">
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<cfif modo neq 'ALTA'>
		<cfoutput>
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
			<input type="hidden" name="ANFid" value="#data.ANFid#">
		</cfoutput>
	</cfif>
</form>
<cfif modo neq 'ALTA'>
	<cfinclude template="ListaPeriodosPresupuestales.cfm">
</cfif>
<cf_qforms>
	<cf_qformsRequiredField name="ANFcodigo" description="Codigo">
		<cf_qformsRequiredField name="ANFdescripcion" description="Descripción">
</cf_qforms>

