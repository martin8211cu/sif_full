
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Pagos de Comision a Gestor" returnvariable="LB_Title"/>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_SNegocio 		= t.Translate('LB_SNegocio','Gestor o Abogado')>
<cfset LB_FechaDesde	= t.Translate('LB_FechaDesde','Fecha desde')>
<cfset LB_FechaHasta	= t.Translate('LB_FechaHasta','Fecha hasta')>

<cfoutput>
<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
	
	<cfparam name="form.Mostrar" default="20">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td colspan="2">
					<cfinclude template="/home/menu/pNavegacion.cfm">
				</td>
			</tr>
			<cfif isDefined('url.num')>
				<cfif url.num eq -1>
					<tr>
						<td align="center">
							<font color="blue" size="4">Se ha registrado el pago de comisi&oacute;n</font><br/>
						</td>
					</tr>
				<cfelse>
					<tr>
						<td align="center">
							<font color="blue" size="4">Se ha generado una solicitud de pago manual</font><br/>
							<cfquery name="q_beneficiario" datasource="#session.dsn#">
								select TESBeneficiario from TESbeneficiario where TESBid = #url.ben#;
							</cfquery>
							<table>
								<tr>
									<td><font color="blue" size="3">Gestor o Abogado:</font></td>
									<td><font color="blue" size="3">&emsp;#q_beneficiario.TESBeneficiario#</font></td>
								</tr>
								<tr>
									<td><font color="blue" size="3">N&uacute;mero:</font></td>
									<td><font color="blue" size="3">&emsp;#url.num#</font></td>
								</tr>
							</table>
						</td>
					</tr>
				</cfif>
				<tr><td>&nbsp;</td></tr>
			</cfif>
			<tr>
				<td>
				<cfset strFiltro = "">
				<form name="form1" action="##" method="post">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td>&nbsp;</td>
							<td nowrap align="left" width="10%"><strong>#LB_SNegocio#:&nbsp;</strong></td>
							<td>
								<cfset gestorData = ''>
								<cfif isDefined('form.DEid') and #form.DEid# neq ''>
									<cfset gestorData = "#form.DEid#,#form.DEidentificacion#,#form.DEnombreC#">
									<cfset strFiltro = "#strFiltro# and DEid = #form.DEid#">
								</cfif>
								<cf_conlis
									showEmptyListMsg="true"
									Campos="DEid,DEidentificacion,DEnombreC"
									Values= "#gestorData#"
									Desplegables="N,S,S"
									Modificables="S,S,S"
									Size="0,10,30"
									tabindex="1"
									Tabla="DatosEmpleado"
									Columnas="
										  DEid
										, DEidentificacion
										, DEnombre
										, DEapellido1
										, DEapellido2
										, concat(DEnombre,' ',DEapellido1,' ',DEapellido2) as DEnombreC
										, case isCobrador when 1 then 'X' else ' ' end as isCobrador
										, case isAbogado when 1 then 'X' else ' ' end as isAbogado
										"
									formName="form1"
									Filtro="Ecodigo = #Session.Ecodigo# and (isCobrador = 1 or isAbogado = 1)"
									Desplegar="DEidentificacion,DEnombre,DEapellido1,DEapellido2,isCobrador,isAbogado"
									Etiquetas="Identificacion,Nombre,Apellido P,Apellido M,Cobrador,Abogado"
									filtrar_por="DEidentificacion,DEnombre,DEapellido1,DEapellido2,isCobrador,isAbogado"
									Formatos="S,S,S,S"
									Align="left,left,left,left"
									Asignar="DEid,DEidentificacion,DEnombreC"
									Asignarformatos="S,S,S"
									/>
							</td>
							<td rowspan="3">
							 <cf_botones values="Filtrar,Limpiar" names="Filtrar,Limpiar"  tabindex="1" >
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td width="10%"><strong>#LB_FechaDesde#:&nbsp;</strong></td>
							<td>
								<cfset fechaDes = "">
								<cfif isdefined("form.fechaDesde") and trim(form.fechaDesde) neq "">
									<cfset fechaDes = LSDateFormat(form.fechaDesde,'dd/mm/yyyy')>
									<cfset fechaDesFiltro = LSDateFormat(form.fechaDesde,'yyyy-mm-dd')>
									<cfset strFiltro = "#strFiltro# and e.ETfecha >= '#fechaDesFiltro#'">
								</cfif>
								<cf_sifcalendario form="form1" value="#fechaDes#" name="fechaDesde" tabindex="1">
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td width="10%"><strong>#LB_FechaHasta#:&nbsp;</strong></td>
							<td>
								<cfset fechaHas = "">
								<cfif isdefined("form.fechaHasta") and trim(form.fechaHasta) neq "">
									<cfset fechaHas = LSDateFormat(form.fechaHasta,'dd/mm/yyyy')>
									<cfset fechaHasFiltro = LSDateFormat(form.fechaHasta,'yyyy-mm-dd')>
									<cfset strFiltro = "#strFiltro# and e.ETfecha <= '#fechaHasFiltro#'">
								</cfif>
								<cf_sifcalendario form="form1" value="#fechaHas#" name="fechaHasta" tabindex="1">
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td width="10%"><strong>Mostrar:&nbsp;</strong></td>
							<td>
								<select name="Mostrar" onChange="form1.submit()">
									<option value="20" <cfif form.Mostrar eq 20 > selected </cfif>>20</option>
									<option value="50" <cfif form.Mostrar eq 50 > selected </cfif>>50</option>
									<option value="100" <cfif form.Mostrar eq 100 > selected </cfif>>100</option>
								</select>
							</td>
						</tr>
					</table>
					</form>
				</td>
			</tr>
			<tr>
				<td align="center">
					<cfif isDefined('form.DEid')>
						<form name="form2" action="PagosGestor_form.cfm?BGst=#form.DEid#" method="post">
							<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
								tabla="ETransacciones e
										inner join DTransacciones d 
											on d.ETnumero = e.ETnumero 
										inner join CRCCuentas c 
											on d.CRCCuentaid = c.id 
										inner join DatosEmpleado de 
											on d.CRCDEid = de.DEid"
								columnas="
										e.ETnumero
										, e.Ecodigo
										, e.ETestado
										, e.ETfecha
										, round(sum(d.DTpreciou),2) DTtotal
										, round(sum(d.DTtotal),2) DTSubTotal
										, round(sum(d.DTdeslinea),2) DTdeslinea
										, d.CRCDEid
										, round(sum(((d.DTpreciou-d.DTdeslinea)*(d.CRCDEidPorc/100)) ),2) DTtotalComision
										, de.DEnombre + ' ' + de.DEapellido1 + ' ' + de.DEapellido2 As Empleadoe
										"
								desplegar="ETfecha,Empleadoe,DTSubTotal,DTtotal,DTtotalComision"
								etiquetas="Fecha,Gestor/Abogado,SubTotal Pago,Total Pago, Total Comision"
								formatos="D,S,M,M,M"
								filtro="e.Ecodigo=#session.Ecodigo# and e.ETestado = 'C' and d.CRCDEidPorc > 0 #strFiltro#
									and e.ETnumero NOT IN (select distinct(ETnumero) from CRCPagoGestor)
									and d.DTborrado = 0
									group by 
										e.ETnumero
										, e.Ecodigo
										, e.ETestado
										, e.ETfecha
										, d.CRCDEid,de.DEnombre + ' ' + de.DEapellido1 + ' ' + de.DEapellido2
									order by e.ETfecha"
								align="left,left,left,left,left"
								ajustar="S"
								checkboxes="S"
								checkAll="S"
								MaxRows="#form.mostrar#"
								showlink="false"
								ira="PagosGestor_form.cfm?BGst=#form.DEid#"
								keys="ETnumero"
								formName = "form2"
								checkbox_function ="funcChk(this)"
								showEmptyListMsg="true"
								botones="Siguiente">
							</cfinvoke>
						</form>
					<cfelse>
						<br><font color="blue" size="3"><b> --- Escoja un Gestor o Abogado --- </b></font><br>
					</cfif>
				</td>
				<td>					
					<!--- <cfinclude template="Convenios_form.cfm"> --->
				</td>
			</tr>			
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

<script>
	function funcSiguiente(){
		var chks = document.getElementsByName('chk');
		var checked = false;
		for (var i = 0; i < chks.length; i++){
			if(chks[i].checked){checked = true;}
		}

		if(!checked){ alert("Seleccione al menos 1 pago"); }
		
		return (checked && IDSelected());
	}

    function funcChk(e){
        if(document.getElementsByName('chkAllItems')[0].checked && !e.checked){
            document.getElementsByName('chkAllItems')[0].checked = false;
        }
    }

	function funcFiltrar(){
		return IDSelected();
	}

	function IDSelected(){
		if(document.getElementsByName('DEid')[0].value.trim() == ''){
			alert("Seleccione un Gestor o Abogado");
			return false;
		}
		return true;
	}

	function funcLimpiar(){ 
		window.location.href = '/cfmx/crc/cobros/operacion/PagosGestor.cfm';
		return true;
	}



</script>
</cfoutput>