<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_DatosVariablesDeExperiencia" Default="Datos variables de experiencia" returnvariable="LB_DatosVariablesDeExperiencia" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Etiqueta" Default="Etiqueta" returnvariable="LB_Etiqueta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Despliegue" Default="Despliegue" returnvariable="LB_Despliegue"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Requerido" Default="Requerido" returnvariable="LB_Requerido"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DatosVariablesDeLosFamiliares" Default="Datos variables de los familiares" returnvariable="LB_DatosVariablesDeLosFamiliares"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Actualizar" Default="Actualizar" returnvariable="BTN_Actualizar" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION --->
<!--- Consultas --->

<cfquery name="rsVerif" datasource="#Session.DSN#">
	select RHDVEcol,RHDVErequerido,RHDVEDatoV,RHDVEdisplay,RHDVEdesp
	from RHDVExperiencia
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
	order by RHDVEorden
</cfquery>
<cfquery name="rsDatosExp" dbtype="query">	<!--- Datos Variables para el expediente --->
	select * 
	from rsVerif
	where RHDVEcol like '%RHEEDV%'
</cfquery>	 	  
<cfparam name="form.modo" default="ALTA">
<cfif rsVerif.REcordCount GT 0><cfset form.modo = 'CAMBIO'></cfif>
<form name="formDVexp" id="formDVexp" method="post" action="DVExperiencia-sql.cfm">
	<input type="hidden" name="modo" value="CAMBIO">				
	
  <cfif isdefined('rsVerif') and rsVerif.recordCount EQ 0>
	<!--- Se insertan los 18 registros automaticamente --->		
		<script language="JavaScript" type="text/javascript">
			document.formDVexp.modo.value="ALTA";
			document.formDVexp.submit();
		</script>
  </cfif>				
  
	
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td colspan="5" class="subTitulo"><cfoutput>#LB_DatosVariablesDeExperiencia#</cfoutput></td>
	</tr>				  
	<tr>
	  <td width="6%">&nbsp;</td>					
	  <td width="35%" class="subTitulo">&nbsp;</td>
	  <td width="38%" class="subTitulo"><cfoutput>#LB_Etiqueta#</cfoutput></td>
	  <td width="11%" class="subTitulo"><cfoutput>#LB_Despliegue#</cfoutput></td>
	  <td width="10%" class="subTitulo"><cfoutput>#LB_Requerido#</cfoutput></td>
	</tr>				
	<cfset cont = 0>
	<cfif rsDatosExp.RecordCount>
		<cfoutput query="rsDatosExp">	<!--- DEdatos 1 - 10 --->
			<cfset cont = cont + 1>					
			<tr>
			  
			<td height="24">&nbsp;</td>											
			  <td>#rsDatosExp.RHDVEdesp#</td>
			  <td><input name="RHdato_#cont#_RHEtiq" type="text" id="RHdato_#cont#_RHEtiq" size="50" maxlength="50" onFocus="this.select()" value="#rsDatosExp.RHDVEDatoV#"></td>
			  <td align="center"><input name="RHdato_#cont#_ckRHdisplay" type="checkbox" id="RHdato_#cont#_ckRHdisplay" <cfif isdefined('rsDatosExp') and rsDatosExp.RHDVEdisplay EQ 1> checked</cfif> value="1"></td>
			  <td align="center"><input name="RHdato_#cont#_ckRHreq" type="checkbox" id="RHdato_#cont#_ckRHreq" <cfif isdefined('rsDatosExp') and rsDatosExp.RHDVErequerido EQ 1> checked</cfif> value="1"></td>
			</tr>
		</cfoutput>
	<cfelse>
	<cfoutput>
		<cfloop from="1" to="10" index="cont">
			<tr>
			<td height="24">&nbsp;</td>											
			  <td><cf_translate key="LB_DatosVariable">Dato Variable</cf_translate>&nbsp;#cont#</td>
			  <td><input name="RHdato_#cont#_RHEtiq" type="text" id="RHdato_#cont#_RHEtiq" size="50" maxlength="50" onFocus="this.select()" value=""></td>
			  <td align="center"><input name="RHdato_#cont#_ckRHdisplay" type="checkbox" id="RHdato_#cont#_ckRHdisplay"  value="1"></td>
			  <td align="center"><input name="RHdato_#cont#_ckRHreq" type="checkbox" id="RHdato_#cont#_ckRHreq"  value="1"></td>
			</tr>
		</cfloop>
	</cfoutput>	
	</cfif>
	  <td colspan="5">&nbsp;</td>
	</tr>	
				
	
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
	<cfloop query="rsDatosExp">	
		cont++;
		arrNombreObjs[arrNombreObjs.length] = 'RHdato_' + cont + '_RHEtiq';
		arrNombreEtiquetas[arrNombreEtiquetas.length] = '<cfoutput>#rsDatosExp.RHDVEdesp#</cfoutput>';
	</cfloop>
	var cont = 0;
//------------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");			
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formDVexp");

	for(var i=0;i<arrNombreObjs.length;i++){
		eval("objForm." + arrNombreObjs[i] + ".required = true;");
		eval("objForm." + arrNombreObjs[i] + ".description = '" + arrNombreEtiquetas[i] + "';");		
	}
//------------------------------------------------------------------------------------------							
</script>
