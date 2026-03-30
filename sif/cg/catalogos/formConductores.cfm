<cfif isdefined("form.CGCid") and len(trim(form.CGCid))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfif (modo neq "ALTA")>
	<cfquery name="rsConductor" datasource="#Session.DSN#">
		select CGCid, CGCcodigo, CGCdescripcion, CGCtipo, CGCmodo, CGCidc, ts_rversion 
		from CGConductores 
		where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and CGCid = <cfqueryparam value="#Form.CGCid#" cfsqltype="cf_sql_integer">
	</cfquery>
</cfif>

<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfoutput>

<form name="form1" method="post" action="SQLConductores.cfm">
	<table align="center" width="100%" cellpadding="0" cellspacing="0" border="0">

		<tr valign="baseline"> 
			<td colspan="2" class="subTitulo" align="center">
				<cfif modo neq "ALTA">
					Cambio de Conductor: #rsConductor.CGCdescripcion#
				<cfelse>
					Registro de Nuevo Conductor
				</cfif>
			</td>
		</tr>

		<tr valign="baseline"> 
			<td align="right" nowrap>Código:&nbsp;</td>
			<td>
				<input name="CGCcodigo" type="text" tabindex="1"
				value="<cfif modo NEQ "ALTA">#rsConductor.CGCcodigo#</cfif>" size="10" maxlength="10" onFocus="this.select();"> 
			</td>
		</tr>

		<tr valign="baseline"> 
			<td align="right" nowrap>Descripci&oacute;n:&nbsp;</td>
			<td>
				<input name="CGCdescripcion" type="text" tabindex="1"
				value="<cfif modo NEQ "ALTA">#rsConductor.CGCdescripcion#</cfif>" size="40" maxlength="50" onFocus="this.select();"> 
			</td>
		</tr>

		<tr valign="baseline"> 
			<td align="right" nowrap>Tipo:&nbsp;</td>
			<td>
				<select name="cboTipo">
				<option value="1" <cfif modo NEQ "ALTA" and rsConductor.CGCtipo eq 1>selected</cfif>>Sugerido</option>
				<option value="2" <cfif modo NEQ "ALTA" and rsConductor.CGCtipo eq 2>selected</cfif>>No Sugerido</option>
				</select>
			</td>
		</tr>
		
		<tr valign="baseline"> 
			<td align="right" nowrap>Modo:&nbsp;</td>
			<td>
				<select name="cboModo" onChange="javascript:MuestraCL(this.value);">
				<option value="1" <cfif modo NEQ "ALTA" and rsConductor.CGCmodo eq 1>selected</cfif>>Por Catálogo</option>
				<option value="2" <cfif modo NEQ "ALTA" and rsConductor.CGCmodo eq 2>selected<cfelse><cfif modo EQ "ALTA">selected</cfif></cfif>>Por Clasificación</option>
				</select>
			</td>
		</tr>
	
		<tr id="DivCat" style="display:none"> 
			<td align="right" valign="middle" nowrap>Catálogo:&nbsp;</td>
			<td valign="middle">
		
					<cfif isdefined("form.F_Catalogo") and form.F_Catalogo NEQ '' and form.CGCmodo eq 1>
						<cfquery name="rsF_PCEcatid" datasource="#Session.DSN#">
							select PCEcatid as F_PCEcatid,
									PCEcodigo as F_PCEcodigo,
									PCEdescripcion as F_PCEdescripcion
							from PCECatalogo
							where CEcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
								and PCEcatid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.F_Catalogo#">
						</cfquery>
						
						<cf_sifcatalogos name="F_PCEcatid" frame="filtroFrame" llave="#Form.F_Catalogo#" codigo="F_PCEcodigo" desc="F_PCEdescripcion" query="#rsF_PCEcatid#" form="form1" Conexion="#Session.DSN#" tabindex="2">
					<cfelse>					
						<cf_sifcatalogos name="F_PCEcatid" frame="filtroFrame" codigo="F_PCEcodigo" desc="F_PCEdescripcion" form="form1" Conexion="#Session.DSN#" tabindex="2">
					</cfif>
				
			</td>
		</tr>
					
		<tr id="DivCla" style="display:"> 
			<td align="right" valign="middle" nowrap>Clasificación:&nbsp;</td>
			<td valign="middle">
		
				<cfquery name="rsF_PCCEclaid" datasource="#Session.DSN#">
					select  PCCEclaid as F_PCCEclaid,
							PCCEcodigo as F_PCEcodigo,
							PCCEdescripcion as F_PCEdescripcion
							
					from PCClasificacionE
					where CEcodigo	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				</cfquery>
				
				<select name="F_PCCEclaid">
				<cfloop query="rsF_PCCEclaid">
					<option value="<cfoutput>#rsF_PCCEclaid.F_PCCEclaid#</cfoutput>" <cfif modo NEQ "ALTA" and rsF_PCCEclaid.F_PCCEclaid eq form.F_Catalogo and form.CGCmodo eq 2>selected</cfif>><cfoutput>#rsF_PCCEclaid.F_PCEcodigo#-#rsF_PCCEclaid.F_PCEdescripcion#</cfoutput></option>
				</cfloop>
				</select>
				
			</td>
		</tr>		
		
		<tr> 
			<cfset ts = "">
			<cfif modo NEQ "ALTA">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsConductor.ts_rversion#" returnvariable="ts"></cfinvoke>
			</cfif>
			
			<td align="right" colspan="2" nowrap>
				<cfif modo NEQ "ALTA">
					<input name="CGCid" type="hidden" tabindex="-1" value="<cfif modo NEQ "ALTA">#rsConductor.CGCid#</cfif>" >
				</cfif> 
				
				<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" tabindex="-1"> 
				<input type="hidden" name="Pagina" tabindex="-1" 
					value="
						<cfif isdefined("form.pagenum1") and form.pagenum1 NEQ "">
							#form.pagenum1#
						<cfelseif isdefined("url.PageNum_lista1") and url.PageNum_lista1 NEQ "">
							#url.PageNum_lista1#
						</cfif>">
			</td>
		</tr>

		<tr><td colspan="2">&nbsp;</td></tr>
		<tr valign="baseline"> 
			<td colspan="2" align="right" nowrap > 
				<cf_botones modo="#modo#" tabindex="1" include="Importar">
			</td>
		</tr>

	</table>
</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	<!--//
	<cfif modo neq 'ALTA' and isdefined("form.CGCmodo")>
		MuestraCL('<cfoutput>#form.CGCmodo#</cfoutput>');
	</cfif>		
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	<cfoutput>
		objForm.CGCcodigo.description="#JSStringFormat('Código')#";
		objForm.CGCdescripcion.description="#JSStringFormat('Descripción')#";
		objForm.CGCvalor.description="#JSStringFormat('Valor')#";
	</cfoutput>	
	
	function habilitarValidacion(){
		objForm.CGCdescripcion.required = true;
		objForm.CGCvalor.required = true;
	}
	
	function deshabilitarValidacion(){
		objForm.CGCdescripcion.required = false;
		objForm.CGCvalor.required = false;
	}

	habilitarValidacion();
	
	objForm.CGCdescripcion.obj.focus();
	
	function acceptX(evt){	
		// NOTE: x = 120, X = 88, Enter = 13, - = 45
		var key = nav4 ? evt.which : evt.keyCode;
		return (key == 13 || key == 45 || key == 88 || key == 8 || key == 0);
	}

	function funcImportar()
	{
		document.form1.action='Conductores-import.cfm';
		document.form1.submit();
	}

	function MuestraCL(numval)
	{	
		var LvarCla = document.getElementById("DivCla");
		var LvarCat = document.getElementById("DivCat");		
		if (numval == 1)
		{
			LvarCla.style.display = 'none';
			LvarCat.style.display = '';
		}
		else
		{
			LvarCla.style.display = '';
			LvarCat.style.display = 'none';
		}
	}
	//-->
</script>