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

<cfif modo neq "ALTA">
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

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
	
	function deshabilitarValidacion(){
		if (document.form1.botonSel.value == 'Baja' || document.form1.botonSel.value == 'Nuevo' ){
			objForm.EEcodigo.required = false;
			objForm.EEnombre.required = false;
			objForm.Ppais.required = false;
			objForm.EEcache.required = false;			
		}
	}
	
</script>

<form method="post" name="form1" action="SQLTEncuestadoras.cfm" onSubmit="return valida();">
	<table align="center" border="0">
    	<tr valign="baseline">
      		<td width="161" align="right" nowrap>Código:</td>
      		<td width="53">
				<input type="text" name="EEcodigo" 
					   value="<cfif modo NEQ 'ALTA'><cfoutput>#trim(rsForm.EEcodigo)#</cfoutput></cfif>" 
					   size="10" maxlength="10" onFocus="this.select();">
      		</td>
    	</tr>
    	<tr valign="baseline">
			<td nowrap align="right">Descripción:</td>
		  	<td colspan="3">
		  		<input type="text" name="EEnombre" 
					   value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EEnombre#</cfoutput></cfif>" 
					   size="60" maxlength="60" onFocus="this.select();"  >
		  	</td>
    	</tr>
    	<tr valign="baseline">
			<td align="right">País:</td>
			<td colspan="3">
			  <cfoutput>
				  <select name="Ppais" id="Ppais">
                    <cfif rsPaises.recordCount EQ 0>
                      <option value="">--No Disponible--</option>
                    </cfif>
                    <cfloop query="rsPaises">
                      <option value="#rsPaises.Ppais#"
									<cfif modo NEQ 'ALTA' and rsForm.Ppais EQ rsPaises.Ppais>selected</cfif>>#rsPaises.Pnombre#</option>
                    </cfloop>
                  </select>
		    	</cfoutput>			
			</td>
    	</tr>
		<tr>
			<td align="right">Cache:</td>
			<td colspan="3">
			  <cfoutput>
					<select name="EEcache">
						<cfif rsCaches.recordCount EQ 0>
							<option value="">--No Disponible--</option>
						</cfif>
						<cfloop query="rsCaches">
							<option value="#rsCaches.Cid#"
									<cfif modo NEQ 'ALTA' and rsForm.EEcache EQ rsCaches.Cid>selected</cfif>>#rsCaches.Ccache#</option>
						  </cfloop>
					</select>
				</cfoutput>	
			</td>
		</tr>
		<tr valign="baseline">
      		<td colspan="4" align="right" nowrap>
				<div align="center"><cfinclude template="/sif/portlets/pBotones.cfm"></div>
      		</td>
		</tr>
  </table>
  <input type="hidden" name="EEid" 
		   value="<cfif modo neq "ALTA"><cfoutput>#rsform.EEid#</cfoutput></cfif>">
</form>

<script language="JavaScript">

	function valida(){
		document.form1.EEcodigo.disabled = false;
		return true;
	}
	
	function __CodeExists(){
		<cfoutput query="rsCodigos">
			var valor = "#Trim(rsCodigos.EEcodigo)#".toUpperCase( );
			if ( valor == trim(this.value.toUpperCase( ))
			<cfif modo neq "ALTA">
				&& "#Trim(rsForm.EEcodigo)#".toUpperCase( ) != trim(this.value.toUpperCase( ))
			</cfif>
			) {
				this.error = "El código que intenta insertar ya existe";
			}
		</cfoutput>
	}
	_addValidator("isCodeExists", __CodeExists);

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.EEcodigo.required = true;
	objForm.EEcodigo.validateCodeExists();
	objForm.EEcodigo.validate = true;
	objForm.EEcodigo.description="Código de Empresa Encuestadora";
	objForm.EEnombre.required = true;
	objForm.EEnombre.description="Descripción";
	objForm.Ppais.required=true;
	objForm.Ppais.description="País";
	objForm.EEcache.required=true;
	objForm.EEcache.description="Cache";
	
</script>