<!--- Consultas --->

<cfquery name="rsVerif" datasource="#Session.DSN#">
	select * 
	from RHEtiquetasEmpresa
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
	order by RHEcol
</cfquery>	  

<cfquery name="rsDatosEmpl" dbtype="query">	<!--- Datos Variables para el empleado --->
	select * 
	from rsVerif
	where RHEcol like '%DEdato%'
</cfquery>	 	  
<cfquery name="rsInfoEmpl" dbtype="query">	<!--- informacion variable para el empleado --->
	select * 
	from rsVerif
	where RHEcol like '%DEinfo%'
</cfquery>	 	
<cfquery name="rsObsEmpl" dbtype="query">	<!--- Observaciones variables para el empleado --->
	select * 
	from rsVerif
	where RHEcol like '%DEobs%'
</cfquery>	 

<cfquery name="rsDatosFam" dbtype="query">	<!--- Datos Variables para el familiar --->
	select * 
	from rsVerif
	where RHEcol like '%FEdato%'
</cfquery>	 	  
<cfquery name="rsInfoFam" dbtype="query">	<!--- informacion variable para el familiar --->
	select * 
	from rsVerif
	where RHEcol like '%FEinfo%'
</cfquery>	
<cfquery name="rsObsFam" dbtype="query">	<!--- Observaciones variables para el familiar --->
	select * 
	from rsVerif
	where RHEcol like '%FEobs%'
</cfquery>

<form name="formEtiquetas" id="formEtiquetas" method="post" action="SQLempresa-etiqueta.cfm">
	<input type="hidden" name="modo" value="CAMBIO">				
	
  <cfif isdefined('rsVerif') and rsVerif.recordCount EQ 0>
	<!--- Se insertan los 18 registros automaticamente --->		
		<script language="JavaScript" type="text/javascript">
			document.formEtiquetas.modo.value="ALTA";
			document.formEtiquetas.submit();
		</script>
  </cfif>				
  
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DatosVariablesDelEmpleado"
	Default="Datos variables del empleado"
	returnvariable="LB_DatosVariablesDelEmpleado"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Etiqueta"
	Default="Etiqueta"
	returnvariable="LB_Etiqueta"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Despliegue"
	Default="Despliegue"
	returnvariable="LB_Despliegue"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Requerido"
	Default="Requerido"
	returnvariable="LB_Requerido"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DatosVariablesDeLosFamiliares"
	Default="Datos variables de los familiares"
	returnvariable="LB_DatosVariablesDeLosFamiliares"/>
	
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td colspan="5" class="subTitulo"><cfoutput>#LB_DatosVariablesDelEmpleado#</cfoutput></td>
	</tr>				  
	<tr>
	  <td width="6%">&nbsp;</td>					
	  <td width="35%" class="subTitulo">&nbsp;</td>
	  <td width="38%" class="subTitulo"><cfoutput>#LB_Etiqueta#</cfoutput></td>
	  <td width="11%" class="subTitulo"><cfoutput>#LB_Despliegue#</cfoutput></td>
	  <td width="10%" class="subTitulo"><cfoutput>#LB_Requerido#</cfoutput></td>
	</tr>				
	<cfset cont = 0>
	<cfoutput query="rsDatosEmpl">	<!--- DEdatos 1 - 5 --->
		<cfset cont = cont + 1>					
		<tr>
		  
        <td height="24">&nbsp;</td>											
		  <td>#rsDatosEmpl.RHEdesp#</td>
		  <td><input name="RHdato_#cont#_RHEtiq" type="text" id="RHdato_#cont#_RHEtiq" size="50" maxlength="50" onFocus="this.select()" value="#rsDatosEmpl.RHEtiqueta#"></td>
		  <td align="center"><input name="RHdato_#cont#_ckRHdisplay" type="checkbox" id="RHdato_#cont#_ckRHdisplay" <cfif isdefined('rsDatosEmpl') and rsDatosEmpl.RHdisplay EQ 1> checked</cfif> value="1"></td>
		  <td align="center"><input name="RHdato_#cont#_ckRHreq" type="checkbox" id="RHdato_#cont#_ckRHreq" <cfif isdefined('rsDatosEmpl') and rsDatosEmpl.RHrequerido EQ 1> checked</cfif> value="1"></td>
		</tr>
	</cfoutput>
	<cfset cont = 0>
	<cfoutput query="rsInfoEmpl">	<!--- DEInfo 1 - 3 --->
		<cfset cont = cont + 1>					
		<tr>
		  <td>&nbsp;</td>											
		  <td>#rsInfoEmpl.RHEdesp#</td>
		  <td><input name="RHinfo_#cont#_RHEtiq" type="text" id="RHinfo_#cont#_RHEtiq" size="50" maxlength="50" onFocus="this.select()" value="#rsInfoEmpl.RHEtiqueta#"></td>
		  <td align="center"><input name="RHinfo_#cont#_ckRHdisplay" type="checkbox" id="RHinfo_#cont#_ckRHdisplay" value="1" <cfif isdefined('rsInfoEmpl') and rsInfoEmpl.RHdisplay EQ 1> checked</cfif>></td>
		  <td align="center"><input name="RHinfo_#cont#_ckRHreq" type="checkbox" id="RHinfo_#cont#_ckRHreq" value="checkbox" <cfif isdefined('rsInfoEmpl') and rsInfoEmpl.RHrequerido EQ 1> checked</cfif>></td>
		</tr>
	</cfoutput>
	<cfset cont = 0>					
	<cfoutput query="rsObsEmpl">	<!--- DEobs 1 - 3 --->
		<cfset cont = cont + 1>					
		<tr>
		  <td>&nbsp;</td>											
		  <td>#rsObsEmpl.RHEdesp#</td>
		  <td><input name="RHobs_#cont#_RHEtiq" type="text" id="RHobs_#cont#_RHEtiq" size="50" maxlength="50" onFocus="this.select()" value="#rsObsEmpl.RHEtiqueta#"></td>
		  <td align="center"><input name="RHobs_#cont#_ckRHdisplay" type="checkbox" id="RHobs_#cont#_ckRHdisplay" value="1" <cfif isdefined('rsObsEmpl') and rsObsEmpl.RHdisplay EQ 1> checked</cfif>></td>
		  <td align="center"><input name="RHobs_#cont#_ckRHreq" type="checkbox" id="RHobs_#cont#_ckRHreq" value="1" <cfif isdefined('rsObsEmpl') and rsObsEmpl.RHrequerido EQ 1> checked</cfif>></td>
		</tr>
	</cfoutput>														
	<tr>
	  <td colspan="5" class="subTitulo"><cfoutput>#LB_DatosVariablesDeLosFamiliares#</cfoutput></td>
	</tr>				  
	<tr>
	  <td width="6%" height="22">&nbsp;</td>					
	  <td width="35%" class="subTitulo">&nbsp;</td>
	  <td width="38%" class="subTitulo"><cfoutput>#LB_Etiqueta#</cfoutput></td>
	  <td width="11%" class="subTitulo"><cfoutput>#LB_Despliegue#</cfoutput></td>
	  <td width="10%" class="subTitulo"><cfoutput>#LB_Requerido#</cfoutput></td>	  
	</tr>
						
	
	<cfset cont = 0>					
	<cfoutput query="rsDatosFam">	<!--- FEdatos 1 - 3 --->
		<cfset cont = cont + 1>					
		<tr>
		  <td>&nbsp;</td>											
		  <td>#rsDatosFam.RHEdesp#</td>
		  <td><input name="FEdatos_#cont#_RHEtiq" type="text" id="FEdatos_#cont#_RHEtiq" size="50" maxlength="50" onFocus="this.select()" value="#rsDatosFam.RHEtiqueta#"></td>
		  <td align="center"><input name="FEdatos_#cont#_ckRHdisplay" type="checkbox" id="FEdatos_#cont#_ckRHdisplay" value="1" <cfif isdefined('rsDatosFam') and rsDatosFam.RHdisplay EQ 1> checked</cfif>></td>
		  <td align="center"><input name="FEdatos_#cont#_ckRHreq" type="checkbox" id="FEdatos_#cont#_ckRHreq" value="checkbox" <cfif isdefined('rsDatosFam') and rsDatosFam.RHrequerido EQ 1> checked</cfif>></td>
		</tr>
	</cfoutput>

	<cfset cont = 0>					
	<cfoutput query="rsInfoFam">	<!--- FEinfo 1 - 2 --->
		<cfset cont = cont + 1>					
		<tr>
		  <td>&nbsp;</td>											
		  <td>#rsInfoFam.RHEdesp#</td>
		  <td><input name="FEinfo_#cont#_RHEtiq" type="text" id="FEinfo_#cont#_RHEtiq" size="50" maxlength="50" onFocus="this.select()" value="#rsInfoFam.RHEtiqueta#"></td>
		  <td align="center"><input name="FEinfo_#cont#_ckRHdisplay" type="checkbox" id="FEinfo_#cont#_ckRHdisplay" value="1" <cfif isdefined('rsInfoFam') and rsInfoFam.RHdisplay EQ 1> checked</cfif>></td>
		  <td align="center"><input name="FEinfo_#cont#_ckRHreq" type="checkbox" id="FEinfo_#cont#_ckRHreq" value="checkbox" <cfif isdefined('rsInfoFam') and rsInfoFam.RHrequerido EQ 1> checked</cfif>></td>
		</tr>
	</cfoutput>															
	
	<cfset cont = 0>					
	<cfoutput query="rsObsFam">	<!--- FEobs 1 - 2 --->
		<cfset cont = cont + 1>					
		<tr>
		  <td>&nbsp;</td>											
		  <td>#rsObsFam.RHEdesp#</td>
		  <td><input name="FEobs_#cont#_RHEtiq" type="text" id="FEobs_#cont#_RHEtiq" size="50" maxlength="50" onFocus="this.select()" value="#rsObsFam.RHEtiqueta#"></td>
		  <td align="center"><input name="FEobs_#cont#_ckRHdisplay" type="checkbox" id="FEobs_#cont#_ckRHdisplay" value="1" <cfif isdefined('rsObsFam') and rsObsFam.RHdisplay EQ 1> checked</cfif>></td>
		  <td align="center"><input name="FEobs_#cont#_ckRHreq" type="checkbox" id="FEobs_#cont#_ckRHreq" value="checkbox" <cfif isdefined('rsObsFam') and rsObsFam.RHrequerido EQ 1> checked</cfif>></td>
		</tr>
	</cfoutput>																				
	<tr>
	  <td colspan="5">&nbsp;</td>
	</tr>	
					
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Actualizar"
	Default="Actualizar"
	returnvariable="BTN_Actualizar"/>
	
	<tr>
	  <td colspan="5" align="center"><input name="btnCambiar" type="submit" id="btnCambiar" value="<cfoutput>#BTN_Actualizar#</cfoutput>" /></td>
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
	
	//Objetos de los datos variables del Familiar
	var cont = 0;
	<cfloop query="rsDatosFam">	
		cont++;
		arrNombreObjs[arrNombreObjs.length] = 'FEdatos_' + cont + '_RHEtiq'				
		arrNombreEtiquetas[arrNombreEtiquetas.length] = '<cfoutput>#rsDatosFam.RHEdesp#</cfoutput>';
	</cfloop>	
	var cont = 0;
	<cfloop query="rsInfoFam">	
		cont++;
		arrNombreObjs[arrNombreObjs.length] = 'FEinfo_' + cont + '_RHEtiq'				
		arrNombreEtiquetas[arrNombreEtiquetas.length] = '<cfoutput>#rsInfoFam.RHEdesp#</cfoutput>';
	</cfloop>
	var cont = 0;
	<cfloop query="rsObsFam">	
		cont++;
		arrNombreObjs[arrNombreObjs.length] = 'FEobs_' + cont + '_RHEtiq'				
		arrNombreEtiquetas[arrNombreEtiquetas.length] = '<cfoutput>#rsObsFam.RHEdesp#</cfoutput>';
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
