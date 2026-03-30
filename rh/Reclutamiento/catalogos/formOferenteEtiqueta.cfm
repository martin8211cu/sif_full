<!--- Consultas --->
<cf_translatedata name="get" tabla="RHEtiquetasOferente" col="RHEtiqueta" returnvariable="lvarRHEtiqueta">
<cfquery name="rsVerif" datasource="#Session.DSN#">
	select Ecodigo, RHEcol, #lvarRHEtiqueta# as RHEtiqueta,RHdisplay, RHrequerido, RHEdesp, coalesce(RHcorporativo,0) as RHcorporativo
    from RHEtiquetasOferente
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
</cfquery>	  

<cfquery name="rsDatosEmpl" dbtype="query">	<!--- Datos Variables para el empleado --->
	select * 
	from rsVerif
	where RHEcol like '%RHOdato%'
</cfquery>	 	  
<cfquery name="rsInfoEmpl" dbtype="query">	<!--- informacion variable para el empleado --->
	select * 
	from rsVerif
	where RHEcol like '%RHOinfo%'
</cfquery>	 	
<cfquery name="rsObsEmpl" dbtype="query">	<!--- Observaciones variables para el empleado --->
	select * 
	from rsVerif
	where RHEcol like '%RHOobs%'
</cfquery>	 

<!--- Estilos --->
<style type="text/css">
	.encabReporte {
		background-color:  #E1E1E1;
		font-weight: bolder;
		color: #000000;
		padding-top: 15px;
		padding-bottom: 15px;
	}
	.topline {
		background-color: #F5F5F5;
		font-weight: bolder;
		color: #000000;
		padding-top: 15px;
		padding-bottom: 15px;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
</style>

<form name="formEtiquetas" id="formEtiquetas" method="post" action="SQLOferenteEtiqueta.cfm">
	<input type="hidden" name="modo" value="CAMBIO">				
	
  <cfif isdefined('rsVerif') and rsVerif.recordCount EQ 0>
	<!--- Se insertan los 18 registros automaticamente --->		
		<script language="JavaScript" type="text/javascript">
			document.formEtiquetas.modo.value="ALTA";
			document.formEtiquetas.submit();
		</script>
  </cfif>				
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td>&nbsp;</td></tr>
		<tr class="encabReporte"><td colspan="5" class="subTitulo"><cf_translate key="LB_DatosVariablesDelOferente">Datos variables del Oferente</cf_translate></td></tr>				  
		<tr class="topline">
			<td width="11%">&nbsp;</td>					
			<td width="30%" class="subTitulo">&nbsp;</td>
			<td width="32%" class="subTitulo"><cf_translate key="LB_Etiqueta">Etiqueta</cf_translate></td>
			<td width="13%" class="subTitulo" align="center"><cf_translate key="LB_Despliegue">Despliegue</cf_translate></td>
			<td width="14%" class="subTitulo" align="center"><cf_translate key="LB_Requerido">Requerido</cf_translate></td>
            <td width="14%" class="subTitulo" align="center"><cf_translate key="LB_Corporativo">Corporativo</cf_translate></td>
		</tr>				
		<tr><td>&nbsp;</td></tr>
		<cfset cont = 0>
		<cfoutput query="rsDatosEmpl">	<!--- DEdatos 1 - 5 --->
			<cfset cont = cont + 1>					
			<tr>
				<td height="24">&nbsp;</td>											
				<td><cf_translate key="LB_DatoVariable">Dato Variable</cf_translate>#cont#</td>
				<td>
					<input name="RHdato_#cont#_RHEtiq" type="text" id="RHdato_#cont#_RHEtiq" size="50" maxlength="50" 
						onFocus="this.select()" value="#rsDatosEmpl.RHEtiqueta#"></td>
				<td align="center">
					<input name="RHdato_#cont#_ckRHdisplay" type="checkbox" id="RHdato_#cont#_ckRHdisplay" 
					<cfif isdefined('rsDatosEmpl') and rsDatosEmpl.RHdisplay EQ 1> checked</cfif> value="1">
				</td>
				<td align="center">
					<input name="RHdato_#cont#_ckRHreq" type="checkbox" id="RHdato_#cont#_ckRHreq" 
						<cfif isdefined('rsDatosEmpl') and rsDatosEmpl.RHrequerido EQ 1> checked</cfif> value="1">
				</td>
                <td align="center">
					<input name="RHdato_#cont#_ckRHcp" type="checkbox" id="RHdato_#cont#_ckRHcp" 
						<cfif isdefined('rsDatosEmpl') and rsDatosEmpl.RHcorporativo EQ 1> checked</cfif> value="1">
				</td>
			</tr>
		</cfoutput>
		<cfset cont = 0>
		<cfoutput query="rsInfoEmpl">	<!--- DEInfo 1 - 3 --->
			<cfset cont = cont + 1>					
			<tr>
				<td>&nbsp;</td>											
			  	<td><cf_translate key="LB_InformacionVariable">Información Variable</cf_translate>#cont#</td>
			  	<td>
					<input name="RHinfo_#cont#_RHEtiq" type="text" id="RHinfo_#cont#_RHEtiq" size="50" maxlength="50" 
					onFocus="this.select()" value="#rsInfoEmpl.RHEtiqueta#">
				</td>
			  	<td align="center"><input name="RHinfo_#cont#_ckRHdisplay" type="checkbox" id="RHinfo_#cont#_ckRHdisplay" 
					value="1" <cfif isdefined('rsInfoEmpl') and rsInfoEmpl.RHdisplay EQ 1> checked</cfif>>
				</td>
			  	<td align="center">
					<input name="RHinfo_#cont#_ckRHreq" type="checkbox" id="RHinfo_#cont#_ckRHreq" value="checkbox" 
						<cfif isdefined('rsInfoEmpl') and rsInfoEmpl.RHrequerido EQ 1> checked</cfif>>
				</td>
                <td align="center">
					<input name="RHinfo_#cont#_ckRHcp" type="checkbox" id="RHinfo_#cont#_ckRHcp" value="checkbox" 
						<cfif isdefined('rsInfoEmpl') and rsInfoEmpl.RHcorporativo EQ 1> checked</cfif>>
				</td>
			</tr>
		</cfoutput>
		<cfset cont = 0>					
		<cfoutput query="rsObsEmpl">	<!--- DEobs 1 - 3 --->
			<cfset cont = cont + 1>					
			<tr>
				<td>&nbsp;</td>											
			  	<td><cf_translate key="LB_ObservacionVariable">Observacion Variable</cf_translate>#cont#</td>
			  	<td>
					<input name="RHobs_#cont#_RHEtiq" type="text" id="RHobs_#cont#_RHEtiq" size="50" maxlength="50" 
					onFocus="this.select()" value="#rsObsEmpl.RHEtiqueta#">
				</td>
			  	<td align="center">
					<input name="RHobs_#cont#_ckRHdisplay" type="checkbox" id="RHobs_#cont#_ckRHdisplay" value="1" 
					<cfif isdefined('rsObsEmpl') and rsObsEmpl.RHdisplay EQ 1> checked</cfif>>
				</td>
			  	<td align="center">
					<input name="RHobs_#cont#_ckRHreq" type="checkbox" id="RHobs_#cont#_ckRHreq" value="1" 
					<cfif isdefined('rsObsEmpl') and rsObsEmpl.RHrequerido EQ 1> checked</cfif>>
				</td>
                <td align="center">
					<input name="RHobs_#cont#_ckRHcp" type="checkbox" id="RHobs_#cont#_ckRHcp" value="1" 
					<cfif isdefined('rsObsEmpl') and rsObsEmpl.RHcorporativo EQ 1> checked</cfif>>
				</td>
			</tr>
		</cfoutput>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		
		<tr>
		  <td colspan="5">&nbsp;</td>
		</tr>					
		<tr>
		  <td colspan="5" align="center">
		  <!--- <input name="btnCambiar" type="submit" id="btnCambiar" value="Actualizar"> --->
		  	<cf_botones regresarMenu='true' names='btnCambiar' values='Actualizar' formname='formEtiquetas'> 
		  </td>
		</tr>
	</table>
</form> 

<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>			
<script language="JavaScript" type="text/javascript">
//------------------------------------------------------------------------------------------
	arrNombreObjs = new Array();
	arrNombreEtiquetas = new Array();	
	
	//Objetos de los datos variables del empleado
	var cont = 0;
	<cfloop query="rsDatosEmpl">	
		cont++;
		arrNombreObjs[arrNombreObjs.length] = 'RHdato_' + cont + '_RHEtiq';
		arrNombreEtiquetas[arrNombreEtiquetas.length] = '<cfoutput>#rsDatosEmpl.RHEdesp#</cfoutput>';
	</cfloop>
	var cont = 0;
	<cfloop query="rsInfoEmpl">	
		cont++;
		arrNombreObjs[arrNombreObjs.length] = 'RHinfo_' + cont + '_RHEtiq'						
		arrNombreEtiquetas[arrNombreEtiquetas.length] = '<cfoutput>#rsInfoEmpl.RHEdesp#</cfoutput>';		
	</cfloop>
	var cont = 0;
	<cfloop query="rsObsEmpl">	
		cont++;
		arrNombreObjs[arrNombreObjs.length] = 'RHobs_' + cont + '_RHEtiq'				
		arrNombreEtiquetas[arrNombreEtiquetas.length] = '<cfoutput>#rsObsEmpl.RHEdesp#</cfoutput>';		
	</cfloop>	
		
//------------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");			
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formEtiquetas");

	for(var i=0;i<arrNombreObjs.length;i++){
		eval("objForm." + arrNombreObjs[i] + ".required = true;");
		eval("objForm." + arrNombreObjs[i] + ".description = '" + arrNombreEtiquetas[i] + "';");		
	}
//------------------------------------------------------------------------------------------							
</script>
