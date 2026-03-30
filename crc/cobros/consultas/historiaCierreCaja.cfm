<cfset translate = createObject('component', 'sif.Componentes.Translate')>
<cfset LB_Title = translate.Translate('LB_Title','Historial de Cierre de Caja')>

<!---
<cfset rsPagos = CierreCaja.TotalesCierreCaja(Mcodigo=MCodigo,FCid=FCid,FACid=FACid)>
--->

<cfoutput>

<cfset filtros = "">
<cfset f_Caja = "">
<cfset f_fecha = "">

<cfif isDefined('form.FCid') && form.FCid neq ''>
	<cfset filtros = "#filtros# and fc.FCid = #form.FCid#">
	<cfset f_Caja = "#form.FCid#,#form.FCcodigo#">
</cfif>

<cfif isDefined('form.fechaf') && form.fechaf neq ''>
	<cfset f_fecha = '#form.fechaf#'>
	<cfset form.fechaf = ListToArray(form.fechaf,'/')>
	<cfset form.fechaf = "#form.fechaf[3]#-#form.fechaf[2]#-#form.fechaf[1]#">
	<cfset filtros = "#filtros# and fce.FCAfecha between '#form.fechaf#' and DATEADD(day,1, '#form.fechaf#')">
</cfif>

<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">
					<cfinclude template="/home/menu/pNavegacion.cfm">
				</td>
			</tr> 
			<tr>
				<td align="center">
					<form name="form1" action="historiaCierreCaja.cfm" method="post">
						<table>
							<tr>
								<td>Caja:&emsp;</td>
								<td>
									<cf_conlis
										title="CAJAS"
										Campos="FCid,FCcodigo"
										values="#f_Caja#"
										Desplegables="N,S"
										Modificables="N,N"
										Size="0,30"
										tabindex="1"
										Tabla="FCajas"
										Columnas="FCid,FCcodigo,FCdesc"
										Filtro="Ecodigo = #Session.Ecodigo#"
										Desplegar="FCcodigo,FCdesc"
										Etiquetas="Codigo,Descripcion"
										filtrar_por="FCcodigo,FCdesc"
										Formatos="S,S"
										Align="left,left"
										Asignar="FCid,FCcodigo"
										Asignarformatos="S,S"/>
								</td>
								<td>
									&emsp;&emsp;&emsp;
								</td>
								<td>
									Fecha de Cierre:&emsp;
								</td>
								<td>
									<cf_sifcalendario form="form1" value="#f_fecha#" name="fechaf" tabindex="1">
								</td>
								<td>
									&emsp;&emsp;&emsp;
								</td>
								<td>
									<cf_botones values="Filtrar,Limpiar">
								</td>
							</tr>
						</table>
					</form>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<cfset buttonA = '<input type="hidden" value="'>
					<cfset buttonB = '"><i class="fa fa-search"></i>'>
					<cfset buttonF = "Concat('#buttonA#',fc.FCid,',',fce.FACid,'#buttonB#')">
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="FACierres fce
                                inner join FCajas fc
                                    on fce.FCid = fc.FCid
                                inner join FADCierres fcd
                                    on fcd.FACid = fce.FACid"
						columnas="	1 as primeracol  
                                    , fce.FACid         as CierreID
                                    , fc.FCid           as CajaID
                                    , fc.FCcodigo       as CodCaja
                                    , fc.FCdesc         as DescripCaja
                                    , fc.FCresponsable  as Responsable
                                    , fce.FCAfecha      as FechaCierre
									, #buttonF#			as Ver"
						desplegar="CodCaja,DescripCaja,Responsable,FechaCierre,Ver"
						etiquetas="CodCaja,DescripCaja,Responsable,FechaCierre,Ver"
						formatos="S,S,S,S,S"
						filtro="fc.Ecodigo = #session.ecodigo# #filtros# order by fce.FCAfecha desc"
						align="left,left,left,left,left"
						checkboxes="N"
						MaxRowsQuery= 1000
						ira="historiaCierreCaja.cfm"
						funcion="funcDisplay(this.parentElement.childNodes[6].childNodes[0].value.split(','));"
						keys="CierreID,CajaID">
					</cfinvoke>
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;
					
				</td>
			</tr>
		</table>

		<cfset style1 = "
			background-color: rgba(0, 0, 0, 0.5);
			position:fixed; left:0px; right:0px; bottom:0px; 
			height:100%; width:100%;
			z-index:1; display:none;"
			>
		<cfset style2 ="
			border: 3px solid ##606060; background-color: white;
			text-align: center; 
			height:300px; width:600px;  
			margin-top:7%; margin-left:30%; padding-top:20px;padding-left:10px;
			">

		<div id="div_procesando" style="#style1# ">
			<div  valign="center" id="div_in" style="#style2#">
				<iframe name="download_iframe" id="download_iframe" style="border:0; border:none;" 
					width="600px" height="300px" >
				</iframe>
			</div>
		</div>			

	</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>

<script>
	function funcDisplay(values){
		caja = values[0];
		cierre = values[1];
		document.getElementById('download_iframe').src = "/cfmx/crc/cobros/consultas/historiaCierreCaja_form.cfm?CajaID="+caja+"&CierreID="+cierre
		document.getElementById('div_procesando').style.display="inline";
	}

	function funcLimpiar(){ 
		window.location.href = '/cfmx/crc/cobros/consultas/historiaCierreCaja.cfm';
		return true;}

</script>