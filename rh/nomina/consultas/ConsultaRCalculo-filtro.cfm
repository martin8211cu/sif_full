<!--- Consultas --->

<!--- Tipos de Nómina --->
<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
	select Tcodigo, Tdescripcion
	from TiposNomina
	where Ecodigo = #Session.Ecodigo#
</cfquery>
<!--- Empleado --->
<cfif isdefined("Form.Filtrar") and isdefined("Form.DEid") AND Len(Trim(Form.DEid)) NEQ 0>
	<cfquery name="rsEmpleadoDef" datasource="#Session.DSN#">
		select convert(varchar, a.DEid) as DEid, 
		{fn concat({fn concat({fn concat({fn concat(
		a.DEnombre , ' ' )}, a.DEapellido1 )}, ' ' )}, a.DEapellido2 )} as NombreEmp,
        a.DEidentificacion, a.NTIcodigo
		from DatosEmpleado a
		where a.Ecodigo = #Session.Ecodigo#
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	</cfquery>
</cfif>
<!--- JavaScript --->
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>



<form name="filtro" method="post" action="ConsultaRCalculo.cfm">

<cfif isdefined('url.HNA')>
<input type="hidden" name="HNA" id="HNA" value="1"/><!---Historico de Nominas Aplicadas--->
</cfif>
	
<table width="98%" border="0" cellpadding="2" cellspacing="2" class="areaFiltro" align="center">
	
	<tr>
		<td align="right"><strong>Nómina&nbsp;:&nbsp;</strong> &nbsp;</td>
		<td colspan="7" nowrap style="width:10% ">
			<cfif not isdefined('form.HNA')><!--- indica que la llamada a la pantalla proviene del menu del link: Histórico de Nominas Aplicadas. --->
				<label for="NH" style="font-style:normal;font-weight:normal"><strong>Histórica</strong></label> <input name="RadioNomina" id="NH" type="radio" value="1" checked tabindex="1" onclick="javascript: Verificar();">	
				<label for="NP" style="font-style:normal;font-weight:normal"><strong>&nbsp;&nbsp;En Proceso</strong></label> <input name="RadioNomina" id="NP" type="radio" value="2" tabindex="1" onclick="javascript: Verificar();">
			<cfelse>
				<label for="NH" style="font-style:normal;font-weight:normal"><strong>Histórica</strong></label> <input name="RadioNomina" id="NH" type="radio" value="1" checked tabindex="1" onclick="javascript: Verificar();" style="display:none">	
			</cfif>			
		</td>
	</tr>
	
	<tr id="NHistoricas">
        <td nowrap align="right"> <strong><cf_translate  key="LB_Codigo_del_Calendario_de_Pago">Código del Calendario de Pago</cf_translate> :&nbsp;</strong></td>
        <td colspan="7">
            <cf_rhcalendariopagos form="filtro" historicos="true" tcodigo="true" index="1" tabindex="1" pintaRCDescripcion="true">
        </td>
	</tr>
	<tr id="NominasenProceso" style="display:none">
        <td nowrap align="right"> <strong><cf_translate  key="LB_Codigo_del_Calendario_de_Pago">Código del Calendario de Pago</cf_translate> :&nbsp;</strong></td>
        <td colspan="7">
            <cf_rhcalendariopagos form="filtro" historicos="false" tcodigo="true" index="2" tabindex="1" pintaRCDescripcion="true">
        </td>
	</tr>

	<tr>
        <td nowrap class="fileLabel" align="right"><cf_translate key="LB_Empleado">Empleado</cf_translate> :&nbsp;</td>
        <td width="1%" nowrap>
            <!--- Empleado --->
            <cf_rhempleado form="filtro">
        </td>
    
        <td width="1%" nowrap align="right">
            <!--- Ver Incidencias --->
            <input type="checkbox" name="chkIncidencias" id="chkIncidencias">
        </td>
    
        <td width="1%" nowrap class="fileLabel" align="right"><cf_translate key="CHK_VerIncidencias">Ver Incidencias</cf_translate>.&nbsp;</td>
        <td width="1%" nowrap align="right">
            <!--- Ver Cargas --->
            <input type="checkbox" name="chkCargas" id="chkCargas">
        </td>
        <td width="1%" nowrap class="fileLabel"><cf_translate key="CHK_VerCargas">Ver Cargas</cf_translate>.&nbsp;</td>
        <td width="1%" nowrap align="right">
            <!--- Ver Deducciones --->
            <input type="checkbox" name="chkDeducciones" id="chkDeducciones">
        </td>
    	<td nowrap class="fileLabel"><cf_translate key="CHK_VerDeducciones">Ver Deducciones</cf_translate>.&nbsp;</td>
  	</tr>
   <!--- <tr>	
   		<td>&nbsp;</td>	
		<td nowrap class="fileLabel" colspan="7">
		<input type="checkbox" name="chkMostrarXMes" id="MostrarXMes" />
		<cf_translate key="CHK_MostrarMes">Mostrar por Mes </cf_translate></td>	
   	</tr>--->
        <td nowrap align="center" colspan="10">
            <cfinvoke component="sif.Componentes.Translate"
                method="Translate"
                Key="BTN_Consultar"
                Default="Consultar"
                XmlFile="/rh/generales.xml"
                returnvariable="BTN_Consultar"/>
                
            <input type="submit" name="butFiltrar" id="butFiltrar" value="<cfoutput>#BTN_Consultar#</cfoutput>">
        </td>
  	</tr>
</table>
</form>

<script language="JavaScript" type="text/javascript">
	//Instancia de qForm
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("filtro");
	
	
	
	function Verificar(){
		if (document.getElementById("NH").checked){ 
			document.getElementById("NHistoricas").style.display=''
			document.getElementById("NominasenProceso").style.display='none'; 
			document.filtro.Tcodigo1.value = '';
			document.filtro.CPid1.value = '';
			document.filtro.CPcodigo1.value = '';
			document.filtro.CPdescripcion1.value = '';
			ValidaNH();
			}
		else{
			document.getElementById("NHistoricas").style.display='none'
			document.getElementById("NominasenProceso").style.display=''; 
			document.filtro.Tcodigo2.value = '';
			document.filtro.CPid2.value = '';
			document.filtro.CPcodigo2.value = '';
			document.filtro.CPdescripcion2.value = '';
			ValidaNP();
		}
	}
	
	function ValidaNH(){
		//Validaciones 
		objForm.Tcodigo1.required = true;
		objForm.Tcodigo1.description = "Tipo Nómina";
		objForm.CPcodigo1.required = true;
		objForm.CPcodigo1.description = "Código";
		objForm.Tcodigo1.obj.focus();
		objForm.Tcodigo2.required = false;
		objForm.CPcodigo2.required = false;
		}
		
	function ValidaNP(){
		//Validaciones 
		objForm.Tcodigo2.required = true;
		objForm.Tcodigo2.description = "Tipo Nómina";
		objForm.CPcodigo2.required = true;
		objForm.CPcodigo2.description = "Código";
		objForm.Tcodigo2.obj.focus();
		objForm.Tcodigo1.required = false;
		objForm.CPcodigo1.required = false;
		}
	
	Verificar();
</script>