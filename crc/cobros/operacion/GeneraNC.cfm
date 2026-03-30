
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Notas de Cr&eacute;dito por descuentos" returnvariable="LB_Title"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cuenta" Default="Cuenta" returnvariable="LB_Cuenta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Interes" Default="Intereses" returnvariable="LB_Interes"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Condonado" Default="Monto Condonado" returnvariable="LB_Condonado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoCondo" Default="Monto A Condonar" returnvariable="LB_MontoCondo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_SNegocio 		= t.Translate('LB_SNegocio','Socio de Negocio')>
<cfset LB_FechaDesde	= t.Translate('LB_FechaDesde','Fecha desde')>
<cfset LB_FechaHasta	= t.Translate('LB_FechaHasta','Fecha hasta')>

<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
	
	<cfparam name="form.Mostrar" default="20">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td colspan="2">
					<cfinclude template="/home/menu/pNavegacion.cfm">
				</td>
			</tr>
			<tr>
				<td>
				<cfoutput>
				<cfset strFiltro = "">
				<form name="form1" action="GeneraNC.cfm" method="post">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td>&nbsp;</td>
							<td nowrap align="left" width="10%"><strong>#LB_SNegocio#:&nbsp;</strong></td>
							<td>
								<cfset tipoSN = "D">
								<cfset arrSocio = "">
								<cfif isdefined("form.snid") and trim(form.snid) neq "">
									<cfquery name="rsSocio" datasource="#Session.dsn#">
										select SNnombre,SNid,SNnumero from SNegocios where SNid = #form.snid#
									</cfquery>
									<cfif rsSocio.recordCount gt 0 >
										<cfset arrSocio = listAppend(arrSocio,rsSocio.Snid)>
										<cfset arrSocio = listAppend(arrSocio,rsSocio.SNnumero)>
										<cfset arrSocio = listAppend(arrSocio,replace(rsSocio.SNnombre,',','','ALL'))>
										<cfset strFiltro = "#strFiltro# and s.SNid = #rsSocio.Snid#">
									</cfif>
								</cfif>
								<cf_conlis
									title="#LB_SNegocio#"
									Campos="SNid,SNnumero, Nombre"
									Desplegables="N,S,S"
									Modificables="N,S,S"
									Size="0,10,30"
									tabindex="1"
									Tabla="SNegocios sn inner join CRCCuentas cc on cc.SNegociosSNid = sn.SNid"
									Columnas="cc.id as idCuenta,SNnumero,SNnombre as Nombre,SNdireccion as Direccion, sn.SNid as SNID"
									form="form1"
									Filtro="sn.Ecodigo = #Session.Ecodigo# and cc.Tipo = 'D'"
									Desplegar="SNid,SNnumero,Nombre"
									Etiquetas="Identificador,Numero, Nombre"
									filtrar_por="SNid,SNnumero,SNnombre"
									Formatos="S,S,S"
									values="#arrSocio#"
									Align="center,center, center"
									Asignar="SNid,SNnumero,Nombre"
									Asignarformatos="S,S,S"/>
									
							</td>
							<td rowspan="3">
							 <cf_botones values="Filtrar" names="Filtrar"  tabindex="1">
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
				</cfoutput>
				</td>
			</tr>
			<tr>
				<td>
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="ETransacciones e 
								inner join ( 
									select d.CRCCuentaid, d.ETnumero, d.Ecodigo, round(sum(d.DTpreciou),2) DTtotal, round(sum(d.DTtotal),2) DTSubTotal,round(sum(d.DTdeslinea),2) DTdeslinea 
									from DTransacciones d
									where d.DTborrado = 0 and d.DTdeslinea > 0
									group by d.CRCCuentaid, d.ETnumero, d.Ecodigo
								) d on d.ETnumero = e.ETnumero and e.Ecodigo = d.Ecodigo
								inner join (
									select distinct ETnumero from  FPAgos 
								) f on e.ETnumero = f.ETnumero
								inner join CRCCuentas c on d.CRCCuentaid = c.id
								inner join SNegocios s on c.SNegociosSNid = s.SNid
								left join CRCGenerarNC nc on e.ETnumero = nc.ETnumero and e.Ecodigo = nc.Ecodigo"
						columnas="e.ETnumero, e.Ecodigo,e.ETestado, e.ETfecha,
									DTtotal,DTSubTotal,DTdeslinea, 
									c.SNegociosSNid,s.SNnombre"
						desplegar="ETfecha,SNnombre,DTtotal,DTSubTotal,DTdeslinea"
						etiquetas="Fecha,Socio de Negocio,Total,SubTotal,Descuento"
						formatos="S,S,S,S,M,M"
						filtro="e.Ecodigo=#session.Ecodigo# #strFiltro#
									and e.ETestado = 'C' 
									and nc.ETnumero is null and nc.Ecodigo is null
									order by e.ETfecha"
						align="left,left,right,right,right"
						ajustar="S"
						checkboxes="S"
						checkAll="S"
						MaxRows="#form.mostrar#"
						showlink="false"
						ira="GeneraNC_form.cfm"
						keys="ETnumero"
						botones="Siguiente">
					</cfinvoke>
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

		if(!checked){ alert("Seleccione al menos 1 detalle"); }
		
		return checked;
	}

    function funcChk(e){
        if(document.getElementsByName('chkAllItems')[0].checked && !e.checked){
            document.getElementsByName('chkAllItems')[0].checked = false;
        }
    }

</script>