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
<cfif isdefined("url.id_sucursal") and Len("url.id_sucursal") gt 0 >
	<cfset form.id_sucursal = url.id_sucursal >
</cfif>


<cfif isdefined("Form.id_sucursal") AND Len(Trim(Form.id_sucursal)) GT 0 and isdefined("Form.id_inst") AND Len(Trim(Form.id_inst)) GT 0 >
	<cfset modo="CAMBIO">
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		select *
		from TPSucursal 
		where id_sucursal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_sucursal#">
		  and id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
	</cfquery>
</cfif>

<cfoutput>
<form method="post" name="formsucursal" action="sucursal-sql.cfm">
	<table align="center" width="100%" cellpadding="2" cellspacing="0">
		<tr><td class="tituloMantenimiento" colspan="2"><font size="1">Sucursal</font></td></tr>
		<tr valign="baseline"> 
			<td nowrap align="left">C&oacute;digo:</td>
			<td>
				<input type="text" name="codigo_sucursal" 
				value="<cfif modo NEQ "ALTA">#rsDatos.codigo_sucursal#</cfif>" 
				size="10" maxlength="10" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="left">Descripci&oacute;n:</td>
			<td>
				<input type="text" name="nombre_sucursal" 
				value="<cfif modo NEQ "ALTA">#rsDatos.nombre_sucursal#</cfif>" 
				size="60" maxlength="100" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="left">Horario:</td>
			<td>
				<input type="text" name="horario_sucursal" 
				value="<cfif modo NEQ "ALTA">#rsDatos.horario_sucursal#</cfif>" 
				size="60" maxlength="255" onfocus="javascript:this.select();" >
			</td>
		</tr>		

		<tr valign="baseline"> 
				<td  colspan="2" class="subTitulo" align="left"><font size="1" color="black"><strong>Direcci&oacute;n </strong></font></td>
		</tr>		
		<tr valign="baseline"> 
			<td nowrap colspan="2"  align="left">
				<cfif modo NEQ "ALTA" and Len(trim(rsDatos.id_direccion)) >
					<input type="hidden" name="id_direccion" value="#rsDatos.id_direccion#">	
					<cf_tr_direccion action="input" key="#rsDatos.id_direccion#" title="">
				<cfelse>
					<cf_tr_direccion action="input"  title="">
				</cfif>			
			</td>
		</tr>			
		<tr><td>&nbsp;</td></tr>
		<tr valign="baseline">
			<td colspan="2" align="center" nowrap>
				<cfinclude template="../../../sif/portlets/pBotones.cfm">
			</td>
		</tr>
		<tr valign="baseline"> 
			<cfset ts = "">
			<cfif modo NEQ "ALTA">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatos.ts_rversion#" returnvariable="ts">
				</cfinvoke>
			</cfif>
			<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
			<input type="hidden" name="id_sucursal" value="<cfif modo NEQ "ALTA">#rsDatos.id_sucursal#</cfif>">
			<input type="hidden" name="id_inst" value="#Form.id_inst#">
		</tr>
	</table>
</form>
</cfoutput>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formsucursal");
	
	objForm.codigo_sucursal.required = true;
	objForm.codigo_sucursal.description="Código";				
	objForm.nombre_sucursal.required = true;
	objForm.nombre_sucursal.description="Descripción";		
	objForm.horario_sucursal.required = true;
	objForm.horario_sucursal.description="Horario";					

	function deshabilitarValidacionSuc(){
		objForm.codigo_sucursal.required = false;
		objForm.nombre_sucursal.required = false;
		objForm.horario_sucursal.required = false;
	}
</SCRIPT>

