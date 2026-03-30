<cfset modo = 'ALTA'>

<cfif isdefined("form.OCid") and len(trim(form.OCid))>
	<cfquery datasource="#session.dsn#" name="rsForm">
		select a.OCid,
			a.Ecodigo,
			a.OCtipoOD,
			a.OCtipoIC,
			a.OCcontrato,
			a.OCVid,
			a.OCfecha,
			a.SNid,
			a.Mcodigo,
			a.OCestado,
			a.OCmodulo,
			a.OCincoterm,
			a.OCtrade_num,
			a.OCorder_num,
			a.OCfechaAllocationDefault,
			a.OCfechaPropiedadDefault
		  from OCordenComercial a
		 where a.OCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">
		 and a.Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset modo = 'CAMBIO'>
</cfif>
	
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select Mcodigo as Mcodigo, Mnombre 
	from Monedas 
	where Ecodigo = #Session.Ecodigo#
	order by Mcodigo
</cfquery>

<cfquery name="rstipoventa" datasource="#Session.DSN#">
	select 	OCVid,OCVcodigo,OCVdescripcion
	from OCtipoVenta
	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo as Mcodigo 
	from Empresas
	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfoutput>

<script language="JavaScript" src="../../js/utilesMonto.js"></script>

<form name="form1" id="form1" method="post" action="OCordenComercial_sql.cfm">
	<table  width="100%"summary="Tabla de entrada">
		<tr>
			<td colspan="4" class="subTitulo">
				Orden Comercial
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>Tipo de Orden</strong>
			</td>
			<td valign="top">
				<cfif modo  EQ "CAMBIO">
					<strong>
					<cfif rsForm.OCtipoOD  EQ "O">
						Origen
					<cfelseif rsForm.OCtipoOD EQ "D">
						Destino
					</cfif>
					</strong>
					<input type="hidden" name="OCtipoOD" value="#rsForm.OCtipoOD#">
					<strong>
					<cfif rsForm.OCtipoIC  EQ "I">
						Inventario
					<cfelseif rsForm.OCtipoIC EQ "C">
						Comercial
					<cfelseif rsForm.OCtipoIC EQ "V">
						Venta Almacén
					</cfif>
					</strong>
					<input type="hidden" name="OCtipoIC" value="#rsForm.OCtipoIC#">
				<cfelse>
					<select name="OCtipoOD" tabindex="1" onchange="javascript: verTR(); ">
						<option value="O">Origen</option>
						<option value="D">Destino</option>
					</select>
					<select name="OCtipoIC" tabindex="1" onchange="javascript: verTR2(); ">
						<option value="C">Comercial</option>
						<option value="I">Inventario</option>
						<option value="V">Venta Almacen</option>
					</select>
				</cfif>
			</td>
		</tr>
		  <tr id = "TR_TIPO1"> 
			<td valign="top">
				<strong>Tipo de Venta</strong>			 
			</td>
			<td valign="top" colspan="3">
				<select name="OCVid" tabindex="1">
					<cfloop query="rstipoventa">
						<option value="#rstipoventa.OCVid#" <cfif isdefined("rsForm.OCVid") and rsForm.OCVid  EQ rstipoventa.OCVid> selected </cfif>>#rstipoventa.OCVcodigo#-#rstipoventa.OCVdescripcion#</option>	
					</cfloop>
				</select>
		   </td>
		</tr>	
		<tr>
			<td valign="top">
				<strong>N&uacute;mero Contrato</strong>
			</td>
			<td valign="top">
				<input type="text" name="OCcontrato" id="OCcontrato"  
					value="<cfif isdefined("rsForm.OCcontrato") and len(trim(rsForm.OCcontrato))>#HTMLEditFormat(rsForm.OCcontrato)#</cfif>" 
					 size="20" maxlength="20"
					onfocus="this.select()"   
					tabindex="3"					
				>
			</td>
			<td valign="top">
				<strong>Fecha Contrato</strong>
			</td>
			<td valign="top">
				<cfif isdefined("rsForm.OCfecha") and len(trim(rsForm.OCfecha))>
					<cf_sifcalendario	tabindex="4" name="OCfecha" 
							value="#DateFormat(rsForm.OCfecha,'dd/mm/yyyy')#"
							form="form1" >
				<cfelse>
					<cf_sifcalendario	tabindex="4" name="OCfecha" 
							value="#DateFormat(Now(),'dd/mm/yyyy')#"
							form="form1" >
				</cfif>	
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong> Moneda</strong>
			</td>
			<td valign="top">
				<select name="Mcodigo" id="Mcodigo" tabindex="6">
				  <cfloop query="rsMonedas">
					<option value="#Mcodigo#" 
						<cfif isdefined("rsForm.Mcodigo") and len(trim(rsForm.Mcodigo)) and rsMonedas.Mcodigo EQ rsForm.Mcodigo >selected<cfelseif rsMonedas.Mcodigo EQ rsMonedaLocal.Mcodigo>selected</cfif>>#Mnombre#</option>
				  </cfloop>
				</select>
			</td>
			<td valign="top" id="TD_LB">
				<strong>Socio de Negocio</strong>
			</td>
			<td valign="top" id="TD_IM">
				<cfset valuesArraySN = ArrayNew(1)>
				<cfif isdefined("rsForm.SNid") and len(trim(rsForm.SNid))>
					<cfquery datasource="#Session.DSN#" name="rsSN">
						select SNid,SNcodigo,SNidentificacion,SNnombre
						from SNegocios
						where Ecodigo = #session.Ecodigo#
						and   SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.SNid#">
					</cfquery>
					<cfset ArrayAppend(valuesArraySN, rsSN.SNid)>
					<cfset ArrayAppend(valuesArraySN, rsSN.SNcodigo)>
					<cfset ArrayAppend(valuesArraySN, rsSN.SNidentificacion)>
					<cfset ArrayAppend(valuesArraySN, rsSN.SNnombre)>
				</cfif>	
				<cf_conlis
				Campos="SNid,SNcodigo,SNidentificacion,SNnombre"
				valuesArray="#valuesArraySN#"
				Desplegables="N,N,S,S"
				Modificables="N,N,S,N"
				Size="0,0,10,30"
				tabindex="5"
				Title="Lista de Socios de Negocio"
				Tabla="SNegocios"
				Columnas="SNid,SNcodigo,SNidentificacion,SNnombre"
				Filtro=" Ecodigo = #Session.Ecodigo#  order by SNnombre "
				Desplegar="SNidentificacion,SNnombre"
				Etiquetas="Identificaci&oacute;n,Nombre"
				filtrar_por="SNidentificacion,SNnombre"
				Formatos="S,S"
				Align="left,left"
				form="form1"
				Asignar="SNid,SNcodigo,SNidentificacion,SNnombre"
				Asignarformatos="S,S,S,S"/>
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>Modulo Origen</strong>
			</td>
			<td valign="top">
				<input type="text" name="OCmodulo" id="OCmodulo"  tabindex="7"
					value="<cfif isdefined("rsForm.OCmodulo") and len(trim(rsForm.OCmodulo))>#HTMLEditFormat(rsForm.OCmodulo)#</cfif>" 
					size="20" maxlength="20"
					onfocus="this.select()"  
				>
			</td>
			<td valign="top">
				<strong>Terminos Comerciales</strong>
			</td>
			<td valign="top">
				<input type="text" name="OCincoterm" id="OCincoterm" tabindex="8" 
						value="<cfif isdefined("rsForm.OCincoterm") and len(trim(rsForm.OCincoterm))>#HTMLEditFormat(rsForm.OCincoterm)#</cfif>" 
						size="20" maxlength="20"
						onfocus="this.select()"  
				>
			</td>
		</tr>
		<tr>
			<td valign="top">
				<strong>Trade Number</strong></td>
			<td valign="top">
				<cfif isdefined("rsForm.OCtrade_num") and len(trim(rsForm.OCtrade_num))>
					<cf_monto	name="OCtrade_num" 
							value="#HTMLEditFormat(rsForm.OCtrade_num)#"
							size="18" decimales="0" tabindex="9"
					>
				<cfelse>
					<cf_monto	name="OCtrade_num" 
								value=""
								size="18" decimales="0" tabindex="9"
					>
				</cfif>
			</td>
			<td valign="top">
				<strong>Order Number</strong>
			</td>
			<td valign="top">
					<cfif isdefined("rsForm.OCorder_num") and len(trim(rsForm.OCorder_num))>
						<cf_monto	name="OCorder_num" 
								value="#HTMLEditFormat(rsForm.OCorder_num)#"
								size="18" decimales="0" tabindex="10"
						>
					<cfelse>
						<cf_monto   name="OCorder_num" 
									value=""
									size="18" decimales="0" tabindex="10"
						>
					</cfif>
			</td>
		</tr>
		<tr> 
	      <td><strong>Date Allocation (Default)</strong></td>
		  <td>
			<cfif isdefined("rsForm.OCfechaAllocationDefault") and len(trim(rsForm.OCfechaAllocationDefault))>
					<cf_sifcalendario	tabindex="5" name="OCfechaAllocationDefault" 
							value="#DateFormat(rsForm.OCfechaAllocationDefault,'dd/mm/yyyy')#"
							form="form1" >
				<cfelse>
					<cf_sifcalendario	tabindex="5" name="OCfechaAllocationDefault" 
							value=""
							form="form1" >
				</cfif>	
		  </td>		
		  <td><strong>Fecha Propiedad (Default)</strong></td>
		  <td>
			<cfif isdefined("rsForm.OCfechaPropiedadDefault") and len(trim(rsForm.OCfechaPropiedadDefault))>
					<cf_sifcalendario	tabindex="5" name="OCfechaPropiedadDefault" 
							value="#DateFormat(rsForm.OCfechaPropiedadDefault,'dd/mm/yyyy')#"
							form="form1" >
				<cfelse>
					<cf_sifcalendario	tabindex="5" name="OCfechaPropiedadDefault" 
							value=""
							form="form1" >
				</cfif>	
		  </td>		  
		</tr>			

		<tr>
			<td colspan="4" class="formButtons">
			<cfif modo  EQ "CAMBIO">
				<cf_botones  tabindex="11" regresar='OCordenComercial.cfm' modo='CAMBIO'>
			<cfelse>
				<cf_botones  tabindex="11" regresar='OCordenComercial.cfm' modo='ALTA'>
			</cfif>
			</td>
		</tr>
	</table>
	<cfif modo  EQ "CAMBIO">
		<input type="hidden" name="OCid" value="#HTMLEditFormat(rsForm.OCid)#">
	</cfif>
</form>
<!--- *******************************************************************************--->
<cfif modo  EQ "CAMBIO">
	<cf_navegacion name="Aid" default="">
	<cf_web_portlet_start titulo="Productos Contratados">
		<table width="100%" align="center">
			<tr>
				<td width="48%" valign="top">
					<cfinclude template="OCordenProducto_list.cfm">
				</td>
				<td width="4%">&nbsp; </td>
				<td width="48%" valign="top">
					<cfinclude template="OCordenProducto_form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
</cfif>  

</cfoutput>


<script language="JavaScript1.2" type="text/javascript">
	 function verTR() {
		var tr1  = document.getElementById("TR_TIPO1");
			
		if (document.form1.OCtipoOD.value == 'D'){
			tr1.style.display = "";
		}
		else{
			tr1.style.display = "none";
		}	
	}
	
	function verTR2() {
		var td1  = document.getElementById("TD_LB");
		var td2  = document.getElementById("TD_IM");
			
		if (document.form1.OCtipoOD.value != 'D' && document.form1.OCtipoIC.value == 'V')
		{
			document.form1.OCtipoIC.value = 'C';
		}
		
		if (document.form1.OCtipoIC.value == 'C')
		{
			td1.style.display = "";
			td2.style.display = "";
			document.form1.SNcodigo.value = ''
		}
		else
		{
			td1.style.display = "none";
			td2.style.display = "none";
			document.form1.SNcodigo.value = '-1'
			
		}	
	}	
	
	
	
	
	function verTR3() {
		var td1  = document.getElementById("TD_LB");
		var td2  = document.getElementById("TD_IM");
			
		if (document.form1.OCtipoIC.value == 'C'){
			td1.style.display = "";
			td2.style.display = "";
			document.form1.SNcodigo.value = ''
			if (document.form1.SNid.value == '' ){alert ('El campo Socio de negocios es requerido.');return false;}
		}
		else{
			td1.style.display = "none";
			td2.style.display = "none";
			document.form1.SNcodigo.value = '-1'
			
		}	
	}	
	
	verTR() ;
	verTR2() ;
</script>


<cf_qforms form="form1" objForm="LobjQForm" onsubmit="verTR3">
	<cf_qformsRequiredField args="OCcontrato, Número Contrato">
</cf_qforms> 
