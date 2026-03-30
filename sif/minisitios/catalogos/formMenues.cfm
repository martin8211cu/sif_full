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

<cfquery name="rsPaginasLigadas" datasource="sdc">
	select MSPcodigo, MSPtitulo 
	from MSPagina 
	where Scodigo = #session.Scodigo#
	order by 2
</cfquery>

<cfif modo NEQ "ALTA">
	
	<cfquery name="rsForm" datasource="sdc">
		select 
		  convert(varchar,MSMmenu) as MSMmenu,
		  MSPcodigo, 		   
		  convert(varchar,MSMpadre) as MSMpadre, 
		  MSMtexto, MSMlink, MSMorden, MSMpath, MSMprofundidad, MSMhijos, MSMumod, MSMfmod
		from MSMenu
		where Scodigo = #session.Scodigo#
		  and MSMmenu   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MSMmenu#">
	</cfquery>

	<cfquery name="rsPadresCambio" datasource="sdc">
		select disp.MSMmenu, replicate('&nbsp;', disp.MSMprofundidad * 3) + disp.MSMtexto as MSMtexto
		from MSMenu disp, MSMenu yo
		where disp.Scodigo = #session.Scodigo#
		  and yo.Scodigo   = #session.Scodigo#
		  and yo.MSMmenu   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MSMmenu#">
		  and yo.MSMmenu  != disp.MSMmenu
		  and disp.MSMpath not like yo.MSMpath + '/%' 
		order by disp.MSMpath, disp.MSMorden	
	</cfquery>

	<cfquery name="rsOrden" datasource="sdc">
		select isnull (max(hermano.MSMorden), 0) as MSMorden
		from MSMenu hermano, MSMenu yo 
		where yo.Scodigo = #session.Scodigo#
		and yo.MSMmenu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MSMmenu#">
		and hermano.Scodigo = #session.Scodigo#
		 and isnull(hermano.MSMpadre,-1) = isnull(yo.MSMpadre,-1)	
	</cfquery>

	<cfquery name="rsSubmenuesAsociados" datasource="sdc">
		select count(*) as cuantos from MSMenu
		where MSMpadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MSMmenu#">
		  and Scodigo = #session.Scodigo#
	</cfquery>	
	
<cfelse>
	<cfquery name="rsPadresAlta" datasource="sdc">
		select disp.MSMmenu, replicate('&nbsp;', disp.MSMprofundidad * 3) + disp.MSMtexto as MSMtexto
		from MSMenu disp
		where disp.Scodigo = #session.Scodigo#
		order by disp.MSMpath, disp.MSMorden
	</cfquery>
</cfif>

<script language="JavaScript1.2">

function valida(f) {
	if (f.botonSel.value == "Alta" || f.botonSel.value == "Cambio") {
        if (f.MSMtexto.value=="") {
            alert("Debe indicar un título para el menú.");
            f.MSMtexto.focus();
            return false;
        }	
	}
	
	if (f.botonSel.value == "Alta") {
        if (f.MSMpadre.value=="") {
            if (!confirm("No ha seleccionado el menú padre. ¿Desea crear un menú de primer nivel?.")) {
                f.MSMpadre.focus();
                return false;
            }
        }	
	}
		
	if (f.botonSel.value == "Baja" && f.submenuesAsociados.value > 0) {
        alert ("No puede borrar el menú mientras tenga submenúes asociados.");
        return false;	
	}
	        
    return true;
}

</script>

<cfoutput>
<table width="100%" border="0" cellspacing="1" cellpadding="1">
<form name="form1" action="SQLMenues.cfm" method="post" onSubmit="javascript: return valida(this);">

  <tr>
    <td colspan="2" class="subTitulo"><div align="center"><cfif modo NEQ "ALTA">Modificar Men&uacute;<cfelse>Nuevo Men&uacute;</cfif></div></td>
    </tr>
  <tr>
    <td><div align="right">P&aacute;gina ligada:</div></td>
    <td><select name="MSPcodigo">
		<option value="">(ninguna)</option>
		<cfloop query="rsPaginasLigadas">
			<option value="#MSPcodigo#" <cfif modo NEQ "ALTA" and rsForm.MSPcodigo EQ rsPaginasLigadas.MSPcodigo> selected </cfif> >#MSPtitulo#</option>
		</cfloop>		
	</select>
	<input name="MSMmenu" type="hidden" value="<cfif modo NEQ "ALTA">#rsForm.MSMmenu#</cfif>">
	<input name="submenuesAsociados" type="hidden" value="<cfif modo NEQ "ALTA">#rsSubmenuesAsociados.cuantos#</cfif>">
	</td>
  </tr>

  <tr>
    <td><div align="right">Men&uacute; Padre:</div></td>
    <td>
		<select name="MSMpadre">
			<option value="">(ninguno)</option>					
			<cfif modo NEQ "ALTA">
				<cfloop query="rsPadresCambio">
					<option value="#MSMmenu#" <cfif rsForm.MSMpadre EQ rsPadresCambio.MSMmenu> selected </cfif> >#MSMtexto#</option>
				</cfloop>		
			<cfelse>
				<cfloop query="rsPadresAlta">
					<option value="#MSMmenu#" >#MSMtexto#</option>
				</cfloop>		
			</cfif>
		</select>		
	</td>
  </tr>
  
  <tr>
    <td><div align="right">T&iacute;tulo:</div></td>
    <td><input type="text" name="MSMtexto" value="<cfif modo NEQ "ALTA">#rsForm.MSMtexto#</cfif>" size="30" maxlength="30"></td>
  </tr>
  
  <tr>
    <td><div align="right">Hiperv&iacute;nculo:</div></td>
    <td><input type="text" name="MSMlink" value="<cfif modo NEQ "ALTA">#rsForm.MSMlink#</cfif>" size="60" maxlength="255"></td>
  </tr>
  
  <tr>
    <td><div align="right">Orden:</div></td>
    <td>
		<select name="MSMorden">
			<!--- <cfif modo NEQ "ALTA">
				<cfloop query="rsOrden">
					<option value="#MSMorden#" <cfif rsForm.MSMorden EQ rsOrden.MSMorden> selected </cfif> >#MSMorden#</option>
				</cfloop>		
			<cfelse>
				<cfloop from="0" to="20" index="i">
					<option value="#i#" >#i#</option>
				</cfloop>		
			</cfif> --->
			<cfloop from="0" to="20" index="i">
				<option value="#i#"  <cfif modo NEQ "ALTA" and rsForm.MSMorden EQ #i#> selected </cfif> >#i#</option>
			</cfloop>
		</select>			
	</td>
  </tr>
  
  <tr>
    <td colspan="2"><div align="center"><cfinclude template="../../portlets/pBotones.cfm"></div></td>
    </tr>
	
</form>	
</table>
</cfoutput>