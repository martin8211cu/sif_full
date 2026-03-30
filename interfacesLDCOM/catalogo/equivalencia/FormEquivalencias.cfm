<cfif isdefined("Form.EQUid") and len(trim(form.EQUid)) NEQ 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfif isDefined("Form.EQUid") and len(trim(#Form.EQUid#)) NEQ 0>
	<cfquery name="rsEquivalencias" datasource="sifinterfaces" >
    	select siscodigo, catcodigo, equid, equemporigen, equcodigoorigen, equempsif, equcodigosif, ts_rversion
        from sifld_equivalencia
        where EQUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EQUid#">
	</cfquery>
</cfif>

<cfquery name="rsEmpOrigen" datasource="LDCOM" >
	select Cadena_Id, Cadena_Nombre
    from Cadena
    order by Cadena_Nombre
</cfquery>

<cfquery name="rsEmpSIF" datasource="asp" >
	select Ecodigo, Enombre
    from Empresa
    order by Enombre
</cfquery>

<body>
<cfoutput>
<form action="SQLEquivalencias.cfm" method="post" name="form">
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">	
	<input name="filtro_SISCodigo" type="hidden" value="<cfif isdefined('form.filtro_SISCodigo')>#form.filtro_SISCodigo#</cfif>">
	<input name="filtro_CATcodigo" type="hidden" value="<cfif isdefined('form.filtro_CATcodigo')>#form.filtro_CATcodigo#</cfif>">
	<input name="fSistema" type="hidden" value="<cfif isdefined('form.fSistema')>#form.fSistema#</cfif>">
    <input name="fCatalogo" type="hidden" value="<cfif isdefined('form.fCatalogo')>#form.fCatalogo#</cfif>">
	
	<table width="67%" height="75%" align="center" cellpadding="2" cellspacing="0">
 
     	<tr> 
			<td align="right" nowrap>Sistema:&nbsp;</td>
			<td>
    	   <select name="SIScodigo" tabindex="1">
				<cfloop query="SelSistema">
					<option value="#SelSistema.SIScodigo#" <cfif modo neq 'ALTA' and trim(SelSistema.SIScodigo) eq trim(rsEquivalencias.siscodigo)>selected</cfif> >#SelSistema.SISnombre#</option>
				</cfloop>
			</select>
      		</td>
		</tr>
        
		<tr> 
			<td align="right" nowrap>C&oacute;digo:&nbsp;</td>
			<td>
		   <select name="CATcodigo" tabindex="1">
				<cfloop query="SelCatalogo">
					<option value="#SelCatalogo.CATcodigo#" <cfif modo neq 'ALTA' and trim(SelCatalogo.CATcodigo) eq trim(rsEquivalencias.CATcodigo)>selected</cfif> >#SelCatalogo.catnombre#</option>
				</cfloop>
				</select>
     			</td>
		</tr>

		<tr> 
			<td align="right" nowrap>Empresa origen:&nbsp;</td>
			<td>
		   <select name="EQUempOrigen" tabindex="1">
					<option value=""></option>
				<cfloop query="rsEmpOrigen">
					<option value="#rsEmpOrigen.Cadena_Id#" <cfif modo neq 'ALTA' and trim(rsEquivalencias.equemporigen) eq trim(rsEmpOrigen.Cadena_Id)>selected</cfif> >#rsEmpOrigen.Cadena_Nombre#</option>
				</cfloop>
				</select>
                </td>
            <td>&nbsp;</td>
		</tr>

		<tr> 
			<td align="right" nowrap>Codigo Origen:&nbsp;</td>
			<td>
				<input name="EQUcodigoOrigen" tabindex="1" type="text"  value="<cfif modo neq "ALTA"><cfoutput>#rsEquivalencias.EQUcodigoOrigen#</cfoutput></cfif>" size="35" maxlength="30" onFocus="this.select();"  alt="Codigo Origen">	
            </td>
		</tr>

		<tr> 
			<td align="right" nowrap>Empresa SIF:&nbsp;</td>
			<td>
		   <select name="EQUempSIF" tabindex="1">
					<option value=""></option>
				<cfloop query="rsEmpSIF">
					<option value="#rsEmpSIF.Ecodigo#" <cfif modo neq 'ALTA' and trim(rsEquivalencias.EQUempSIF) eq trim(rsEmpSIF.Ecodigo)>selected</cfif> >#rsEmpSIF.ENombre#</option>
				</cfloop>
				</select>
                </td>
            <td>&nbsp;</td>
		</tr>

		<tr> 
			<td align="right" nowrap>Codigo SIF:&nbsp;</td>
			<td>
				<input name="EQUcodigoSIF" tabindex="1" type="text"  value="<cfif modo neq "ALTA"><cfoutput>#rsEquivalencias.EQUcodigoSIF#</cfoutput></cfif>" size="35" maxlength="30" onFocus="this.select();"  alt="Codigo SIF">
            </td>
		</tr>

	
		<!--- *************************************************** --->  

		<tr><td colspan="2">&nbsp;</td></tr>

		<tr> 
			<td colspan="2" align="center" nowrap>
				<cfif modo neq "ALTA">
					<cfset masbotones = "">
					<cfset masbotonesv = "">
				<cfelse>
					<cfset masbotones = "">
					<cfset masbotonesv = "">
				</cfif>
				<cf_botones modo="#modo#" include="#masbotones#" includevalues="#masbotonesv#" tabindex="1">
	</td>
		</tr>
	</table>

  <cfset ts = "">
	  <cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsEquivalencias.ts_rversion#"/>
		</cfinvoke>
	</cfif>  

  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
  <input type="hidden" name="EQUid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsEquivalencias.EQUid#</cfoutput></cfif>">
	
 </form>
 </cfoutput>
 <cf_qforms form="form">
<script language="JavaScript" type="text/JavaScript">
	
	objForm.SIScodigo.required = true;
	objForm.SIScodigo.description="Código Sistema";
	objForm.Catcodigo.required = true;
	objForm.Catcodigo.description="Concepto";
	objForm.EQUempOrigen.required = true;
	objForm.EQUempOrigen.description="Empresa Origen";
	objForm.EQUcodigoOrigen.required = true;
	objForm.EQUcodigoOrigen.description="Codigo Origen";
	objForm.EQUempSIF.required = true;
	objForm.EQUempSIF.description="Empresa SIF";
	objForm.EQUcodigoSIF.required = true;
	objForm.EQUcodigoSIF.description="Codigo SIF";

	function deshabilitarValidacion(){
		objForm.SIScodigo.required = false;
		objForm.Catcodigo.required = false;
		objForm.EQUempOrigen.required = false;
		objForm.EQUcodigoOrigen.required = false;
		objForm.EQUempSIF.required = false;
		objForm.EQUcodigoSIF.required = false;
		
	}
	function habilitarValidacion(){
		objForm.SIScodigo.required = true;
		objForm.Catcodigo.required = true;
		objForm.EQUempOrigen.required = true;
		objForm.EQUcodigoOrigen.required = true;
		objForm.EQUempSIF.required = true;
		objForm.EQUcodigoSIF.required = true;
	}
	
	function funcBaja(){
		deshabilitarValidacion();
	}

	}	

 	<cfif modo NEQ "ALTA">
 		document.form.SIScodigo.focus();
	<cfelse>
		document.form.SIScodigo.focus();
 	</cfif> 
</script>
