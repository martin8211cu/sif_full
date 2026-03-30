<cfif isdefined("Form.EEid")>  
  <cfset modoEnc="CAMBIO">
<cfelse>  
  <cfset modoEnc="ALTA">
</cfif>

<cfif modoEnc neq "ALTA">
	<cfquery name="rsForm" datasource="sifpublica">
		select * 
		from EncuestaEmpresa 
		where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">
	</cfquery>
</cfif>

<cfquery name="rsCodigos" datasource="sifpublica">
	select EEcodigo 
	from EncuestaEmpresa 
</cfquery>

<cfquery name="rsPaises" datasource="asp">
	select Ppais, Pnombre
	from Pais
	order by Pnombre
</cfquery>

<cfquery name="rsCaches" datasource="asp">
	select Cid,
		   a.Ccache,
		   a.Cexclusivo
	from Caches a
	where a.Cexclusivo = 0
	and not exists (
		select 1
		from CECaches b
		where b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		and b.Cid = a.Cid)
	union
	select Cid,
		   a.Ccache,
		   a.Cexclusivo
	from Caches a
	where a.Cexclusivo = 1
	and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and not exists (select 1
					from CECaches b
					where b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					and b.Cid = a.Cid)
	order by 2
</cfquery> 

<form method="post" name="formEnc" action="SQLTEncuestadoras.cfm" onSubmit="return validaEnc();">
	<table align="center" border="0">
    	<tr valign="baseline">
      		<td width="161" align="right" nowrap><strong>Código:</strong></td>
      		<td width="53">
				<input type="text" name="EEcodigo" 
					   value="<cfif modoEnc NEQ 'ALTA'><cfoutput>#trim(rsForm.EEcodigo)#</cfoutput></cfif>" 
					   size="10" maxlength="10" onFocus="this.select();">
      		</td>
    	</tr>
    	<tr valign="baseline">
			<td nowrap align="right"><strong>Descripción:</strong></td>
		  	<td colspan="3">
		  		<input type="text" name="EEnombre" 
					   value="<cfif modoEnc NEQ 'ALTA'><cfoutput>#rsForm.EEnombre#</cfoutput></cfif>" 
					   size="60" maxlength="60" onFocus="this.select();"  >
		  	</td>
    	</tr>
    	<tr valign="baseline">
			<td align="right"><strong>País:</strong></td>
			<td colspan="3">
			  <cfoutput>
				  <select name="Ppais" id="Ppais">
                    <cfif rsPaises.recordCount EQ 0>
                      <option value="">--No Disponible--</option>
                    </cfif>
                    <cfloop query="rsPaises">
                      <option value="#rsPaises.Ppais#"
									<cfif modoEnc NEQ 'ALTA' and rsForm.Ppais EQ rsPaises.Ppais>selected</cfif>>#rsPaises.Pnombre#</option>
                    </cfloop>
                  </select>
		    	</cfoutput>			
			</td>
    	</tr>
		<tr valign="baseline">
      		<td colspan="4" align="right" nowrap>
<!--- 				<div align="center"><cfinclude template="/rh/portlets/pBotones.cfm"></div> --->
				<cf_botones form="formEnc" modo="#modoEnc#">
      		</td>
		</tr>
  </table>
  <input type="hidden" name="EEid" 
		   value="<cfif modoEnc neq "ALTA"><cfoutput>#rsform.EEid#</cfoutput></cfif>">
</form>

<cf_qforms form="formEnc">

<script language="JavaScript">

	function validaEnc(){
		document.formEnc.EEcodigo.disabled = false;
		return true;
	}
	
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function __CodeExists(){
		<cfoutput query="rsCodigos">
			var valor = "#Trim(rsCodigos.EEcodigo)#".toUpperCase( );
			if ( valor == trim(this.value.toUpperCase( ))
			<cfif modoEnc neq "ALTA">
				&& "#Trim(rsForm.EEcodigo)#".toUpperCase( ) != trim(this.value.toUpperCase( ))
			</cfif>
			) {
				this.error = "El código que intenta insertar ya existe";
			}
		</cfoutput>
	}
	_addValidator("isCodeExists", __CodeExists);

	objForm.EEcodigo.validateCodeExists();
	objForm.EEcodigo.description="Código de Empresa Encuestadora";
	objForm.EEnombre.description="Descripción";
	objForm.Ppais.description="País";

	function habilitarValidacion(){
		objForm.EEcodigo.required = true;
		objForm.EEcodigo.validate = true;
		objForm.EEnombre.required = true;
		objForm.Ppais.required=true;
	}	
	function deshabilitarValidacion(){
		objForm.EEcodigo.required = false;
		objForm.EEcodigo.validate = false;
		objForm.EEnombre.required = false;
		objForm.Ppais.required=false;
	}	
		
</script>