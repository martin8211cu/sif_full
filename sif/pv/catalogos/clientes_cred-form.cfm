<cfset modoCC = 'ALTA'>
	<cfif isdefined('form.SNcodigo') and len(trim(form.SNcodigo)) and isdefined('form.CDCcodigo') and len(trim(form.CDCcodigo))>
		<cfset modoCC = 'CAMBIO'>
	</cfif>

<cfif modoCC eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select SNcodigo, CDCcodigo, CDCactivo, CDCDefault, ts_rversion
		from FACSnegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer " value="#form.SNcodigo#">
		and CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric " value="#form.CDCcodigo#">
	</cfquery>

<!--- QUERY PARA SOCIOS DE NEGOCIOS--->
	<cfquery name="rsSocNeg" datasource="#Session.DSN#" >
		Select SNidentificacion, SNnumero, SNnombre, SNcodigo
		from SNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.SNcodigo#" >		  
		order by SNnombre
	</cfquery>

<!--- QUERY PARA CLIENTES DETALLISTAS CORPORATIVO--->
	<cfquery name="rsCliDetCorp" datasource="#Session.DSN#" >
		Select CDCcodigo, CDCidentificacion, CDCnombre 
		from ClientesDetallistasCorp
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
		and CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CDCcodigo#">		  
		order by CDCnombre
	</cfquery>
</cfif>

<cfoutput>
<form name="formCC" method="post" action="clientes_cred-sql.cfm">
	<cfif isdefined('form.CDCcodigo') and len(trim(form.CDCcodigo))>
		<input type="hidden" name="CDCcodigo" value="#form.CDCcodigo#">
	</cfif>
	
	<cfif isdefined("Form.CDCidentificacion_F") and Len(Trim(Form.CDCidentificacion_F)) NEQ 0>
		<input type="hidden" name="CDCidentificacion_F" value="#form.CDCidentificacion_F#">
	</cfif>	
	<cfif isdefined("Form.CDCnombre_F") and Len(Trim(Form.CDCnombre_F)) NEQ 0>
		<input type="hidden" name="CDCnombre_F" value="#form.CDCnombre_F#">
	</cfif>
	
	<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
		<tr>
			<td width="16%" align="right" nowrap><strong>Socio de Negocio&nbsp;</strong></td>

			<td width="49%">
			<!--- <cfdump var="#form#">--->
			<!--- <cfdump var="#rsSocNeg#">  --->
			
			    <cfif modoCC NEQ "ALTA">
			        <cf_sifsociosnegocios2 SNtiposocio="C" modificable='false' form="formCC" idquery="#rsSocNeg.SNcodigo#"> 
				<cfelse>
					 <cf_sifsociosnegocios2 SNtiposocio="C" form="formCC" SNcodigo="SNcodigo" SNumero="SNumero" SNdescripcion="SNdescripcion">
				</cfif> 		
		    </td>
			
			<td width="10%" align="right"><strong> Activo</strong></td>
			<td width="7%"><input name="CDCactivo" type="checkbox" value="1" <cfif modoCC NEQ "ALTA" and data.CDCactivo eq 1> checked</cfif>></td>			  
			
			<td width="14%" align="right"><strong>Default</strong></td>
			<td width="4%"><input name="CDCDefault" type="checkbox" value="1" <cfif modoCC NEQ "ALTA" and data.CDCDefault eq 1> checked</cfif>></td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cf_botones formName='formCC' modo='#modoCC#'>
			</td>
		</tr>
	</table>
	
	<cfif modoCC neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
</form>

	<!-- MANEJA LOS ERRORES--->
	<cf_qforms form="formCC" objForm="objFormCC">

	<script language="javascript">
		<!--//
			objFormCC.SNcodigo.description = "Socios de Negocios";
			objFormCC.SNcodigo.required = true;
			
			function habilitarValidacion(){
				objFormCC.SNcodigo.required = true;
			}
			
			function deshabilitarValidacion(){
				objFormCC.SNcodigo.required = false;
			}
		//-->
	</script>
</cfoutput>