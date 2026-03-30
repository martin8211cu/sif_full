<cfif isDefined("Form.RHEid") and len(trim(Form.RHEid)) NEQ 0>
	<cfquery name="rsRHEscalas" datasource="#Session.DSN#" >
	Select RHEid, RHEdescripcion, RHEdefault, ts_rversion
	from RHEscalas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHEid#" >		  
		order by RHEid 
	</cfquery>
</cfif>

<cfoutput>
<form action="SQLEscalas.cfm" method="post" name="form1">
	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
		<tr valign="baseline" bgcolor="##FFFFFF">
			<td>&nbsp;</td>
			<td align="right" nowrap><cf_translate key="LB_Escala">Escala</cf_translate>:</td>
			<td>&nbsp;</td>
			<td>
				<cfif isDefined("Form.RHEid") and len(trim(Form.RHEid))>
					#rsRHEscalas.RHEid#
					<input type="hidden" name="RHEid" value="#rsRHEscalas.RHEid#" >
				<cfelse>
					<input 
						name="RHEid" 
						type="text" 
						id="RHEid"  
						tabindex="1"
						size="3"
						style="text-align: right;" 
						onBlur="javascript: fm(this,-1);"  
						onFocus="javascript:this.value=qf(this); this.select();"  
						onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
						value="">
				</cfif>
			</td>
		</tr>
	
		<tr valign="baseline" bgcolor="##FFFFFF"> 
			<td>&nbsp;</td>
			<td align="right" nowrap><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:</td>
			<td>&nbsp;</td>
			<td> 
				<input type="text" name="RHEdescripcion" tabindex="1" size="40" maxlength="60"  alt="#LB_Descripcion#"
					value="<cfif isDefined("Form.RHEid") and len(trim(Form.RHEid)) NEQ 0>#HTMLEditFormat(rsRHEscalas.RHEdescripcion)#</cfif>" >
			</td>
		</tr>
		
		<tr valign="baseline" bgcolor="##FFFFFF"> 
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td> 
				<input  type="checkbox" name="RHEdefault" tabindex="1" 	<cfif isDefined("Form.RHEid") and len(trim(Form.RHEid)) NEQ 0 and rsRHEscalas.RHEdefault eq 1> checked</cfif> >
				<cf_translate key="LB_Predeterminado">Predeterminado</cf_translate>	
			</td>
		</tr>
	
	
		<tr valign="baseline"> 
			<td colspan="4" align="center" nowrap>
				<cfset tabindex=1>
				<cfinclude template="/rh/portlets/pBotones.cfm">
			</td>
		</tr>
  		
		<cfif isDefined("Form.RHEid") and len(trim(Form.RHEid)) NEQ 0>
			<cfset ts = "">
			<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsRHEscalas.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
  		</cfif>
	</table>
</form>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Escala"
	Default="Escala"
	returnvariable="MSG_Escala"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Descripcion"/>


<cf_qforms>
	<cf_qformsRequiredField name="RHEid" description="#MSG_Escala#">
	<cf_qformsRequiredField name="RHEdescripcion" description="#MSG_Descripcion#">
</cf_qforms>
</cfoutput>
