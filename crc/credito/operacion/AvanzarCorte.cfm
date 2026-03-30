<!--- 
Creado por Jose Gutierrez 
	17/04/2018
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 				= t.Translate('LB_TituloH','Avanzar Corte')>
<cfset TIT_AvanzarCorte 		= t.Translate('TIT_AvanzarCorte','Avanzar Corte')>
<cfset LB_TituloTabla			= t.Translate('LB_TituloTabla','Cortes con saldo vencido calculado y monto a pagar calculados')>
<cfset LB_Id					= t.Translate('LB_Id','Id')>
<cfset LB_Codigo				= t.Translate('LB_Codigo','C&oacute;digo')>
<cfset LB_FechaInicio 			= t.Translate('LB_FechaInicio','Fecha Inicio')>
<cfset LB_FechaFin				= t.Translate('LB_FechaFin','Fecha Fin')>
<cfset LB_FechaInicioSV			= t.Translate('LB_FechaInicioSV','Fecha Inicio SV')>
<cfset LB_FechaFinSV			= t.Translate('LB_FechaFinSV','Fecha Fin SV')>
<cfset LB_EstadoCalculo 		= t.Translate('LB_EstadoCalculo', 'Estado de C&aacute;lculo')>
<cfset LB_Cerrado		 		= t.Translate('LB_Cerrado', 'Cerrado')>
<cfset BTN_Aplicar		 		= t.Translate('BTN_Aplicar', 'Aplicar')>
<cfset BTN_Regresar		 		= t.Translate('BTN_Regresar', 'Regresar')>
<cfset LB_UltimosCrtsCerr		= t.Translate('LB_UltimosCrtsCerr', '&Uacute;ltimos cortes cerrados.')>
<cfset LB_ProximosCrtsCerr		= t.Translate('LB_ProximosCrtsCerr', 'Pr&oacute;ximos cortes a cerrar.')>
<cfset LB_CortesAntSCerrar		= t.Translate('LB_CortesAntSCerrar', 'Cortes vencidos sin cerrar.')>
<cfset LB_MsjError				= t.Translate('LB_MsjError', 'No existen cortes para el proceso de "Avanzar Corte".')>
<cfset LB_MsjErrorCrts			= t.Translate('LB_MsjErrorCrts', 'No existen cortes anteriores sin cerrar para este proceso".')>
<cfset LB_CrtsTM				= t.Translate('LB_CrtsTM', 'Cortes Mayoristas por vencer.')>


<cf_templateheader title="#LB_TituloH#">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_AvanzarCorte#'>

<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
<cfset val = objParams.getParametroInfo('30200711')>
<cfif val.codigo eq ''><cfthrow message="El parametro [30200711 - Rol de administradores de credito] no existe"></cfif>
<cfif val.valor eq ''><cfthrow message="El parametro [30200711 - Rol de administradores de credito] no esta definido"></cfif>

<cfquery name="checkRol" datasource="#session.dsn#">
	select * from UsuarioRol where 
				Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.usucodigo#">  
			and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#val.valor#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#"> 
</cfquery>

<cfoutput>
<cfif checkRol.recordCount neq 0>

	<cfinclude template="../../../sif/Utiles/sifConcat.cfm">

	<form name="frmCorte" id="frmCorte" method="post" action="AvanzarCorte_sql.cfm">
		<table width="100%" border="0" cellspacing="" cellpadding="" align="center" class="PlistaTable">
		<tr>
			<td width="100%">
				<table width="80%" align="center" cellpadding="5" cellspacing="6" border="0" class="PlistaTable">
					<tr class="tituloListas">
						<td colspan="8" align="center" height="50"> <strong>#LB_TituloTabla#:&nbsp;</strong> </td><br>
					</tr>	
					<tr class="tituloListas" height="30">
<!--- 						<td> <strong>#LB_Id#:&nbsp;</strong> </td> --->
						<td> <strong>#LB_Codigo#:&nbsp;</strong> </td>
						<td> <strong>#LB_FechaInicio#:&nbsp;</strong></td>
						<td> <strong>#LB_FechaFin#:&nbsp;</strong></td>
<!---						<td> <strong>#LB_FechaInicioSV#:&nbsp;</strong></td>
						<td> <strong>#LB_FechaFinSV#:&nbsp;</strong></td> --->
						<td> <strong>#LB_EstadoCalculo#:&nbsp;</strong></td>
						<td> <strong>#LB_Cerrado#:&nbsp;</strong></td>
					</tr>
						<cfquery name="qCortesACerrar" datasource="#session.DSN#">
							select id, Codigo, FechaInicio, FechaFin, status, FechaInicioSV, FechaFinSV,cerrado
							from CRCCortes 
							where ((Tipo <> 'TM' and status = '0' and Cerrado = 0) or (Tipo ='TM' and status = 1))
						</cfquery>

						<cfquery name="cortesSinCerrar" datasource="#session.DSN#">
							select * from CRCCortes 
							where ((Tipo <> 'TM' and status = '0' and Cerrado = 0) or (Tipo ='TM' and status = 1)) 
							and convert(date,GETDATE()) > convert(date,FechaFin)
						</cfquery>

						<cfquery name="qCortesSVPM" datasource="#session.DSN#">

						 	select id, Codigo, FechaInicio, FechaFin, status = 'Monto a Pagar Calculado', FechaInicioSV, FechaFinSV,cerrado = case 
							when cerrado = 1 then 'Si'
							when cerrado = 0 then 'No' 
							end, status status_cod
							from CRCCortes 
							where Ecodigo = #session.Ecodigo#
							and status = 1
							and Tipo <> 'TM'
							union all 
							select id, Codigo, FechaInicio, FechaFin, status = 'Corte Mayorista por vencer', FechaInicioSV, FechaFinSV,cerrado = case 
							when cerrado = 1 then 'Si'
							when cerrado = 0 then 'No' 
							end, status status_cod
							from CRCCortes 
							where Ecodigo = #session.Ecodigo#
							and status = 1
							and Tipo = 'TM'
							and convert(date,GETDATE()) between convert(date,FechaInicio) and convert(date,FechaFin)
							union all 
							select id, Codigo, FechaInicio, FechaFin, status ='C&aacute;lculo Pendiente', FechaInicioSV, FechaFinSV,cerrado = case 
							when cerrado = 1 then 'Si'
							when cerrado = 0 then 'No' 
							end, status status_cod
							from CRCCortes 
							where Ecodigo = #session.Ecodigo#
							and convert(date,GETDATE()) between convert(date,FechaInicio) and convert(date,FechaFin)
							and Cerrado = 0
							union all 
							select id, Codigo, FechaInicio, FechaFin, status ='C&aacute;lculo Pendiente Atrasado', FechaInicioSV, FechaFinSV,cerrado = case 
							when cerrado = 1 then 'Si'
							when cerrado = 0 then 'No' 
							end, status status_cod 
							from CRCCortes 
							where Ecodigo = #session.Ecodigo#
							and convert(date,FechaFin) < convert(date,GETDATE())
							and (Cerrado = 0)
							union all 
							select id, Codigo, FechaInicio, FechaFin, status ='C&aacute;lculo Pendiente Atrasado', FechaInicioSV, FechaFinSV,cerrado = case 
							when cerrado = 1 then 'Si'
							when cerrado = 0 then 'No' 
							end, status status_cod 
							from CRCCortes 
							where Ecodigo = #session.Ecodigo#
							and convert(date,FechaFin) < convert(date,GETDATE())
							and (status = 1 and Tipo = 'TM')
							order by FechaFin asc 
						</cfquery>	

						<cfif qCortesSVPM.recordCount neq 0 >
							<cfloop query="qCortesSVPM" >
								<cfif #status# eq 3>
									<tr style="background-color:gray">
								</cfif>
								<cfif #status# eq 2>
									<tr style="background-color:orange">
								</cfif>
								<cfif #status# eq 'Monto a Pagar Calculado'>
									<tr style="background-color:##78B1C4">
								</cfif>
								<cfif #cerrado# eq 0>
									<tr style="background-color:##BDBFBF">
								</cfif>
								<cfif #status# eq 'C&aacute;lculo Pendiente Atrasado'>
									<tr style="background-color:##A9D0F5">
								</cfif>
								<cfif #status# eq 'Corte Mayorista por vencer'>
									<tr style="background-color:##4DB8FF">
								</cfif>
								<!---<cfif  #cerrado# eq 0 and #DateFormat(qCortesSVPM.FechaFin, "mmm-dd-yyyy")# lt #DateFormat(now(), "mmm-dd-yyyy")#>
									<tr style="background-color:##A9D0F5">
								</cfif>---> 

<!--- 									<td><cfoutput>#id#&nbsp;&nbsp;</cfoutput></td> --->
									<td><cfoutput>#Codigo#&nbsp;&nbsp;</cfoutput></td>
									<td><cfoutput>#DateFormat(FechaInicio,"dd/mm/yyyy")#&nbsp;&nbsp;</cfoutput></td>
									<td><cfoutput>#DateFormat(FechaFin,"dd/mm/yyyy")#&nbsp;&nbsp;</cfoutput></td>
<!---									<td><cfoutput>#DateFormat(FechaInicioSV,"dd/mm/yyyy")#&nbsp;&nbsp;</cfoutput></td>
									<td><cfoutput>#DateFormat(FechaFinSV,"dd/mm/yyyy")#&nbsp;&nbsp;</cfoutput></td> --->
									<td><cfoutput>#status#&nbsp;&nbsp;</cfoutput></td>
									<td><cfoutput>#cerrado#&nbsp;&nbsp;</cfoutput></td>
								</tr> 
							</cfloop> 
						</cfif>
						<tr>
							<td colspan="8" align="right">
								<input tabindex="3" type="submit" id="btnModificar" class="btnGuardar" name="Cambio" value="#BTN_Aplicar#" 
									<cfif qCortesACerrar.recordCount neq 0> 
										disabled
										<cfset form.avanzar = 3> 
									</cfif> onblur="validarCortesACerrar()">
								<input type="hidden" name="avanzar" value="1">
							</td>
						</tr>
				</table>
				<table width="80%" align="center">
					<tr>		
						<td style="background-color: ##78B1C4">
							
						</td>
						<td align="left">
							<strong>#LB_UltimosCrtsCerr#</strong>
						</td>	
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>		
						<td border="1px" style="background-color:##BDBFBF">
							
						</td>
						<td align="left">
							<strong>#LB_ProximosCrtsCerr#</strong>
						</td>	
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>		
						<td border="1px" style="background-color:##A9D0F5">
							
						</td>
						<td align="left">
							<strong>#LB_CortesAntSCerrar#</strong>
						</td>	
					</tr>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>		
						<td border="1px" style="background-color:##4DB8FF">
							
						</td>
						<td align="left">
							<strong>#LB_CrtsTM#</strong>
						</td>	
					</tr>
				</table>		 
				  
			</td>
		</tr>
		<tr>
			<td valign="top">
				<!---
				<table border="1">
					<tr>
						<td> Avanzar Corte </td>
						<td> <input type="radio" name="avanzar" checked="" value="1"  <cfif isDefined('form.avanzar') and  #form.avanzar# eq 1> checked  </cfif> > </td>
					</tr>
					<tr>
						<td> Ejecutar Corte por fecha Actual(Fecha de la PC) </td>
						<td> <input type="radio" name="avanzar" value="2"  <cfif isDefined('form.avanzar') and  #form.avanzar# eq 2> checked  </cfif> ></td>
					</tr>	
					<tr>
						<td> </td>
						<td> <input type="submit" value="Aplicar" > </td>
					</tr>	
				</table>--->		
		 
			</td>
		</tr>
		</table>
	</form>
<cfelse>
	<cfthrow message="No cuentas con los permisos para realizar esta operacion">
</cfif>
<cf_web_portlet_end>			

<cf_templatefooter>

<script type="text/javascript">
	window.onload=validarCortesACerrar;


	function validarCortesACerrar(){

		if(#cortesSinCerrar.recordCount# <= 0){
			document.frmCorte.Cambio.style.visibility='hidden';
			document.frmCorte.Cambio.disabled = true;
			
		}else{
			document.frmCorte.Cambio.style.visibility='';
			document.frmCorte.Cambio.disabled = false;
			
		}
	}

</script>
</cfoutput>


