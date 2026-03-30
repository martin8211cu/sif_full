<cfset mododet = 'ALTA'>

<cfif isdefined("form.OCPid") and len(trim(form.OCPid))>
	<cfquery datasource="#session.dsn#" name="rsFormD">
		select OCPid
			 , OCid
			 , OCPlinea
			 , Aid
			 , Ecodigo
			 , Ucodigo
			 , OCPcantidad
			 , OCPprecioUnitario
			 , OCPprecioTotal
			 , OCitem_num
			 , OCport_num
			 , CFformato
		  from OCordenProducto
		 where OCPid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCPid#">
		 and   OCid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">
		 and   Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	</cfquery>
	<cfset mododet = 'CAMBIO'>
</cfif>	



<cfoutput>
<form name="form2" id="form2" method="post" action="OCTransporteProducto_sql.cfm">
	<table summary="Tabla de entrada">
		<tr>
			<td colspan="2" class="subTitulo">
				Productos
			</td>
		</tr>
		<tr>
			<td valign="top" nowrap>
				<strong>Orden Comercial</strong>
			</td>
			<td valign="top" colspan="3">
				<cf_conlis
					Campos="OCid,OCcontrato"
					Desplegables="N,S"
					Modificables="N,S"
					Size="0,20"
					tabindex="1"
					Title="Órdenes Comerciales"
					Tabla="OCordenComercial"
					Columnas="OCid,OCcontrato,OCfecha
					"
					Filtro=" Ecodigo = #Session.Ecodigo# and OCestado = 'A' order by OCfecha"
					Desplegar="OCcontrato,OCfecha"
					Etiquetas="Contrato,Fecha"
					filtrar_por="OCcontrato,Fecha"
					Formatos="S,D" 
					Align="left,left" 
					form="form2"
					Asignar="OCid,OCcontrato"
					Asignarformatos="S,S"/>
			</td>
		</tr>		
		<tr> 
		  <td><strong>Bill of lading</strong></td>
		  <td>
			<input 
				type="text" 
				name="OCTPnumeroBOL"
				id="OCTPnumeroBOL"
				value="<cfif isdefined("rsForm.OCTPnumeroBOLdefault") and len(trim(rsForm.OCTPnumeroBOLdefault))>#HTMLEditFormat(rsForm.OCTPnumeroBOLdefault)#</cfif>" 
				size="20" 
				maxlength="20"  
				autocomplete="off"
				alt="OCTPnumeroBOL"
				tabindex="2"
				title="Bill of lading">
		  </td>
		  <td><strong>Date Bill of lading</strong></td>
		  <td>
			<cfif isdefined("rsForm.OCTPfechaBOLdefault") and len(trim(rsForm.OCTPfechaBOLdefault))>
					<cf_sifcalendario	tabindex="3" name="OCTPfechaBOL" 
							value="#DateFormat(rsForm.OCTPfechaBOLdefault,'dd/mm/yyyy')#"
							form="form2" >
				<cfelse>
					<cf_sifcalendario	tabindex="3" name="OCTPfechaBOL" 
							value=""
							form="form2" >
				</cfif>	
		  </td>			
 		<tr>
			<td colspan="4" class="formButtons">
			<cfif mododet  EQ "CAMBIO">
				<cf_botones tabindex="4" modo='CAMBIO'>
			<cfelse>
				<cf_botones tabindex="4"  modo='ALTA'>
			</cfif>
			</td>
		</tr>
	</table>
	<input type="hidden" name="OCTid" value="#HTMLEditFormat(form.OCTid)#">
	<input type="hidden" name="Aid" value="">
	<input type="hidden" name="BorrarLinea" value="">
</form>
 <cf_qforms form="form2" objForm="LobjQForm2">
	<cf_qformsRequiredField args="OCid, Orden Comercial">
	<cf_qformsRequiredField args="OCTPnumeroBOL, Bill of lading">
	<cf_qformsRequiredField args="OCTPfechaBOL,Date Bill of lading">

</cf_qforms>
</cfoutput>

