<cfset modo = 'ALTA' >
<cfif isdefined("form.Modo") and form.Modo NEQ 'ALTA'>
	<cfset modo = 'CAMBIO' >
</cfif>

<cfif modo NEQ "ALTA">
	<cfquery name="rsCPValidacionValores" datasource="#Session.DSN#">
		select Codigo, Descripcion
		from CPValidacionValores
		where CPVid = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPVid#" >	
			and Ecodigo = #Session.Ecodigo#	  
	</cfquery>
</cfif> 

<form action="CPValidacionValores-SQL.cfm" method="post" name="form1" onSubmit="javascript: document.form1.CPcodigo.disabled = false; return true;" >
	<cfoutput>
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">
	<input name="CPVid" type="hidden" tabindex="-1" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(Form.CPVid)#</cfoutput></cfif>">	
	</cfoutput>
  <table width="100%" align="center">
    <tr> 
      <td width="50%" align="right" valign="middle" nowrap> C&oacute;digo:&nbsp;</td>
      <td> 
        <input  name="CPcodigo" type="text" tabindex="1" <cfif modo neq 'ALTA'>disabled</cfif> value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsCPValidacionValores.Codigo)#</cfoutput></cfif>" size="10" maxlength="30">
		<div align="right"></div>
      </td>
    </tr>
    <tr> 
      <td align="right" valign="middle" nowrap>Descripci&oacute;n:&nbsp;</td>
      <td> 
        <input name="CPdescripcion" type="text" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsCPValidacionValores.Descripcion)#</cfoutput></cfif>" size="40" maxlength="80">	
		<div align="right"></div>
      </td>
    </tr>
	
    <tr> 
      <td colspan="2" nowrap>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="2" align="center" nowrap> 
		<cfset tabindex = 2 >
        <!--- <cfinclude template="../../portlets/pBotones.cfm"> --->
		<cf_botones modo="#modo#" tabindex="1">
      </td>
    </tr>
  </table>
<cfset ts = "">
<!---   <cfif modo NEQ "ALTA">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsTipoTransacciones.ts_rversion#"/>
	</cfinvoke>
</cfif>   --->
  <!--- <input tabindex="-1" type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32"> --->
 </form>

<cf_qforms form="form1">
	<cf_qformsRequiredField  name="CPcodigo" description="Código">
	<cf_qformsRequiredField name="CPdescripcion" description="Descripción">
</cf_qforms>