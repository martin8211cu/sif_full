<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif isDefined("session.Ecodigo") and isDefined("Form.Dcodigo") and len(trim(#Form.Dcodigo#)) NEQ 0>
	<cfquery name="rsDepartamentos" datasource="#Session.DSN#" >
	Select Dcodigo, Deptocodigo, Ddescripcion, ts_rversion
	from Departamentos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#" >		  
		order by Ddescripcion asc
	</cfquery>
</cfif>

<cfoutput>
<form action="SQLDepartamentos.cfm<cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>" 
method="post" name="form">
	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
		<tr valign="baseline" bgcolor="##FFFFFF">
			<td>&nbsp;</td>
			<td align="right" nowrap><cf_translate key="LB_Codigo" XmlFile="/sif/generales.xml">C&oacute;digo</cf_translate>:</td>
			<td>&nbsp;</td>
			<td>
				<input name="Deptocodigo" type="text"  size="10" maxlength="10"  alt="El Código" tabindex="1"
					value="<cfif #modo# NEQ "ALTA">#HTMLEditFormat(rsDepartamentos.Deptocodigo)#</cfif>" >
			</td>
			<td>&nbsp;</td>
			<cfif modo EQ 'CAMBIO'>
				<input type="hidden" name="xDeptocodigo" value="#rsDepartamentos.Deptocodigo#" >
			</cfif>
		</tr>
	
		<tr valign="baseline" bgcolor="##FFFFFF"> 
			<td>&nbsp;</td>
			<td align="right" nowrap><cf_translate key="LB_Descripcion" XmlFile="/sif/generales.xml">Descripci&oacute;n</cf_translate>:</td>
			<td>&nbsp;</td>
			<td> 
				<input type="text" name="Ddescripcion" tabindex="1" size="40" maxlength="60"  alt="La Descripción"
					value="<cfif #modo# NEQ "ALTA">#HTMLEditFormat(rsDepartamentos.Ddescripcion)#</cfif>" >
				<input type="hidden" name="Dcodigo" value="<cfif modo NEQ "ALTA">#rsDepartamentos.Dcodigo#</cfif>">
				<input type="text" name="txt" readonly class="cajasinbordeb" size="1">
			</td>
			<td>&nbsp;</td>
		</tr>
		<!--- *************************************************** --->
		<cfif modo NEQ 'ALTA'>
			<tr>
			  <td colspan="5" align="center" class="tituloListas"><cf_translate key="LB_ComplementosContables" XmlFile="/sif/generales.xml">Complementos Contables</cf_translate></td>
			</tr>
			<tr><td colspan="5" align="center">
			<cf_sifcomplementofinanciero action='display' tabindex="1"
					tabla="Departamentos"
					form = "form"
					llave="#form.Dcodigo#" />		
			</td></tr>
		</cfif>	
		<!--- *************************************************** ---> 	
	
	
		<tr valign="baseline"> 
			<td colspan="5" align="center" nowrap>
				<cfset tabindex=1>
				<cfinclude template="../../portlets/pBotones.cfm">
			</td>
		</tr>
  		
		<cfif modo neq "ALTA">
			<cfset ts = "">
			<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsDepartamentos.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
  		</cfif>

  		<input type="hidden" name="desde" value="<cfif isdefined("form.desde")>#form.desde#</cfif>" >
	</table>
</form>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	XmlFile="/sif/generales.xml"
	returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	XmlFile="/sif/generales.xml"
	returnvariable="MSG_Codigo"/>
<cf_qforms form="form">
	<cf_qformsRequiredField name="Deptocodigo"  description="#MSG_Codigo#">
	<cf_qformsRequiredField name="Ddescripcion" description="#MSG_Descripcion#">
</cf_qforms>
</cfoutput>