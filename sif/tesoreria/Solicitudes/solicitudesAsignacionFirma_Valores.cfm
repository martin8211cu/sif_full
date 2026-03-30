<!--- 
	Creado por: Maria de los Angeles Blanco López
		Fecha: 19 Octubre 2011
 --->
<cf_templateheader title="Firmas">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Firmas de Solicitudes de Pago'> 

<cfif isdefined("form.TESSPid") and #form.TESSPid# NEQ ''>
	<cfset session.TESSPid = #form.TESSPid#>
</cfif>

<cfquery name="rsFirmas" datasource="#session.dsn#">
	select UAP.DEapellido1 +' '+ UAP.DEapellido2+' '+UAP.DEnombre as Aprueba, UAU.DEapellido1+' '+
	UAU.DEapellido2+' '+UAU.DEnombre as Autoriza, convert(varchar(10), Fecha_Act, 103) as Fecha,  Usuario
	from TESsolicitudFirmas	SF
	inner join (select DEid, DEidentificacion, DEapellido1,  DEapellido2, DEnombre
				from DatosEmpleado) as UAP 
	on UAP.DEid = SF.DEid_Aprueba
	inner join (select DEid, DEidentificacion, DEapellido1, DEapellido2, DEnombre 
				from DatosEmpleado) as UAU
	on UAU.DEid = SF.DEid_Autoriza
	where TESSPid = 
	<cfif isdefined("form.TESSPid") and #form.TESSPid# NEQ ''>
		#form.TESSPid#
	<cfelse>
		#session.TESSPid#
	</cfif>
	and Ecodigo = #session.Ecodigo#
</cfquery>

<cfoutput>
	<form name="form1" method="post" action="">
	<table class="areaFiltro" width="100%" border="0" cellpadding="0" cellspacing="" align="center">	
		<tr>
			<td valign="top">
				<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="2">&nbsp;</td></tr>	
				<table width=500 align=center><tr><td>
				<cfif isdefined("rsFirmas") and rsFirmas.recordCount EQ 1>
			   		<table width=800 align=center><tr><td>
					<cf_web_portlet_start titulo="Firmas Asignadas">
						<cfset LvarCampos = rsFirmas.getColumnnames()>
						<table width="100%" border="1">
						<TR>
                            <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                                <td style="font-size:12;font-weight:bold">
                                    <cfoutput>#ucase(LvarCampos[i])#</cfoutput>
                                </td>
                            </cfloop>
                        </TR>
                        <cfloop query="rsFirmas">   
                            <TR>
                                <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                                    <td style="font-size:10">
                                    <cfoutput>#evaluate("rsFirmas.#LvarCampos[i]#")#&nbsp;</cfoutput>
                                    </td>
                                </cfloop>
                            </TR>
                        </cfloop> 						
						</table>
					<cf_web_portlet_end>
			 		</td></tr></table>
				<cfelse>
					<tr><td><strong> No se han indicado las firmas para la solicitud</strong></td></tr>
				</cfif> 
					<tr><td colspan="2">&nbsp;</td></tr>						
					<td align="center"><strong>Aprobó: </strong>
					<cf_conlis title="LISTA DE EMPLEADOS"
						campos = "DEid, DEidentificacion, DEnombre, DEapellido1, DEapellido2" 
						desplegables = "N,S,S,S,S" 
						modificables = "N,S,N,N,N" 
						size = "0,15,25,20,20"
						asignar="DEid, DEidentificacion, DEnombre, DEapellido1, DEapellido2"
						asignarformatos="S,S,S,S,S"
						tabla="DatosEmpleado"
						columnas="DEid, DEidentificacion, DEnombre, DEapellido1, DEapellido2"
						filtro="Ecodigo = #Session.Ecodigo# and DEdato1 = 'SI'"
						desplegar="DEidentificacion, DEnombre, DEapellido1, DEapellido2"
						etiquetas="Identificación, Nombre, Apellido Paterno, Apellido Materno"
						formatos="S,S,S,S,S"
						align="left,left,left,left,left"
						showEmptyListMsg="true"
						EmptyListMsg=""
						form="form1"
						width="800"
						height="500"
						left="70"
						top="20"
						filtrar_por="DEidentificacion, DEnombre, DEapellido1, DEapellido2"
						index="1"			
						funcion=""
						fparams="DEid"/>
					</td>				
				</tr>			
				<tr>					
					<td align="center"><strong>Autorizo: </strong>					
					<cf_conlis title="LISTA DE EMPLEADOS"
						campos = "DEidA, DEidentificacionA, DEnombreA, DEapellido1A, DEapellido2A" 
						desplegables = "N,S,S,S,S" 
						modificables = "N,S,N,N,N" 
						size = "0,15,25,20,20"
						asignar="DEidA, DEidentificacionA, DEnombreA, DEapellido1A, DEapellido2A"
						asignarformatos="S,S,S,S,S"
						tabla="DatosEmpleado"
						columnas="DEid as DEidA, DEidentificacion as DEidentificacionA, DEnombre as DEnombreA, DEapellido1 as DEapellido1A, DEapellido2 as DEapellido2A"
						filtro="Ecodigo = #Session.Ecodigo# and DEdato1 = 'SI'"
						desplegar="DEidentificacionA, DEnombreA, DEapellido1A, DEapellido2A"
						etiquetas="Identificación, Nombre, Apellido Paterno, Apellido Materno"
						formatos="S,S,S,S,S"
						align="left,left,left,left,left"
						showEmptyListMsg="true"
						EmptyListMsg=""
						form="form1"
						width="800"
						height="500"
						left="70"
						top="20"
						filtrar_por="DEidentificacion, DEnombre, DEapellido1, DEapellido2"
						index="1"			
						funcion=""
						fparams="DEidA"/>        
					</td>
				</tr>							
				</table>	
				<tr>
					<tr><td>&nbsp;</td></tr>							
					<td align="center"><input type="button" name="btnGuardar"   	class="btnGuardar"   value="Guardar"          	onClick="javascript:funcGuardar();;" >				
					<input type="button" name="btnRegresar"   	class="btnRegresar"   value="Regresar"          	onClick="javascript:funcRegresar();"></td>
					<tr><td>&nbsp;</td></tr>		
				</tr>							
		</td>	
		</tr>
	</form>
	
<script language="JavaScript1.2" type="text/javascript">
	function funcGuardar() {
		document.form1.action = "solicitudesAsignacionFirma_Motor.cfm";
		document.form1.submit();
		}
		
	function funcRegresar() {
		document.form1.action = "solicitudesAsignacionFirma.cfm";
		document.form1.submit();
		}
</script>


</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form1'>
<cfset session.ListaReg = "">



