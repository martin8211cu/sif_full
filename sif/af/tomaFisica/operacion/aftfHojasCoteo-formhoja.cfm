<cfoutput>
<form action="aftfHojasCoteo-sql.cfm" method="post" name="form2" style="margin:0px">
	<input type="hidden" id="AFTFid_hoja" name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
	<cfinclude template="aftfHojasCoteo-hiddens.cfm">
	<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td>
	<fieldset><legend>Asociar Activos a la Hoja de Conteo</legend>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td align="right" nowrap>Activo&nbsp;:&nbsp;</td>
		<td>
			<cf_sifactivo form="form2" tabindex="2">
		</td>
		<td rowspan="3" valign="middle" align="center">&nbsp;</td>
		<td align="right" nowrap>Tipo&nbsp;:&nbsp;</td>
		<td>
			<cf_conlis maxrowsquery="200" form="form2"
				campos="AFCcodigo,AFCcodigoclas,AFCdescripcion"
				size="0,10,40"
				desplegables="N,S,S"
				modificables="N,S,N"
				asignar="AFCcodigo,AFCcodigoclas,AFCdescripcion"
				asignarformatos="I,S,S"
				columnas="AFCcodigo,AFCcodigoclas,AFCdescripcion"
				tabla="AFClasificaciones"
				filtro="Ecodigo = #Session.Ecodigo# order by AFCcodigoclas,AFCdescripcion"
				desplegar="AFCcodigoclas,AFCdescripcion"
				formatos="S,S"
				align="left,left"
				etiquetas="Código,Descripción"
				filtrar_por="AFCcodigoclas,AFCdescripcion"
				tabindex="2"
				title="Lista de Tipos"
				/>
		</td>
		<td rowspan="3" valign="middle" align="center">&nbsp;</td>
		<td rowspan="3" valign="middle" align="center"><cf_botones values="Generar" tabindex="3" form="form2"></td>
	  </tr>
	  <tr>
		<td align="right" nowrap>Centro F.&nbsp;:&nbsp;</td>
		<td>
			<cf_conlis maxrowsquery="200" form="form2"
				campos="CFid,CFcodigo,CFdescripcion" 
				size="0,10,40"
				desplegables="N,S,S"
				modificables="N,S,N"
				asignar="CFid,CFcodigo,CFdescripcion"
				asignarformatos="I,S,S"
				columnas="CFid,CFcodigo,CFdescripcion"
				tabla="CFuncional"
				filtro="Ecodigo = #session.Ecodigo# order by CFpath, CFcodigo, CFnivel"
				desplegar="CFcodigo,CFdescripcion"
				formatos="S,S"
				align="left,left"
				etiquetas="Código, Descripción"
				filtrar_por="CFcodigo,CFdescripcion"
				tabindex="2"
				title="Lista de Centros Funcionales"
				/>
		</td>
		<td align="right" nowrap>Oficina&nbsp;:&nbsp;</td>
		<td>
			<cf_conlis maxrowsquery="200" form="form2"
				campos="Ocodigo,Oficodigo,Odescripcion" 
				size="0,10,40"
				desplegables="N,S,S"
				modificables="N,S,N"
				asignar="Ocodigo,Oficodigo,Odescripcion"
				asignarformatos="I,S,S"
				columnas="Ocodigo,Oficodigo,Odescripcion"
				tabla="Oficinas"
				filtro="Ecodigo = #session.Ecodigo# order by Oficodigo"
				desplegar="Oficodigo,Odescripcion"
				formatos="S,S"
				align="left,left"
				etiquetas="Código, Descripción"
				filtrar_por="Oficodigo,Odescripcion"
				tabindex="2"
				title="Lista de Centros Funcionales"
				/>
		</td>
	  </tr>
	  <tr>
		<td align="right" nowrap>Categoría&nbsp;:&nbsp;</td>
		<td>
			<cf_conlis maxrowsquery="200" form="form2"
				campos="ACcodigo, ACcodigodesc, ACdescripcion, ACmascara"
				size="0,10,40,0"
				desplegables="N,S,S,N"
				modificables="N,S,N,N"
				asignar="ACcodigo, ACcodigodesc, ACdescripcion, ACmascara"
				asignarformatos="I,S,S,S"
				columnas="ACcodigo, ACcodigodesc, ACdescripcion, ACmascara"
				tabla="ACategoria a"
				filtro="Ecodigo = #Session.Ecodigo# 
				order by ACcodigodesc, ACdescripcion"
				desplegar="ACcodigodesc, ACdescripcion"
				formatos="S,S"
				align="left,left"
				etiquetas="Código,Descripción"
				alt="Categoría,Categoría"
				filtrar_por="ACcodigodesc, ACdescripcion"
				tabindex="2"
				title="Lista de Categorías"
				funcion="limpiaClase"
				/>
		</td>
		<td align="right" nowrap>Clase&nbsp;:&nbsp;</td>
		<td>
			 <cf_conlis maxrowsquery="200" form="form2"
				campos="ACid, ACcodigodesc_clas, ACdescripcion_clas"
				size="0,10,40"
				desplegables="N,S,S"
				modificables="N,S,N"
				asignar="ACid, ACcodigodesc_clas,ACdescripcion_clas"
				asignarformatos="I,S,S"
				columnas="ACid, ACcodigodesc as ACcodigodesc_clas, ACdescripcion as ACdescripcion_clas"
				tabla="AClasificacion a"
				filtro="Ecodigo = #Session.Ecodigo# 
					and ACcodigo = $ACcodigo,numeric$ 
					order by ACcodigodesc_clas, ACdescripcion_clas"
				desplegar="ACcodigodesc_clas, ACdescripcion_clas"
				formatos="S,S"
				align="left,left"
				etiquetas="Código,Descripción"
				alt="Clase,Clase"
				filtrar_por="ACcodigodesc, ACdescripcion"
				tabindex="2"			
				title="Lista de Clases"
				/>
		</td>
	  </tr>
 	  <tr>
        <td  class="fileLabel" align="left" nowrap>Empleado:</td>
        <td >
            <cf_dbfunction name="concat" args="A.DEapellido1 ,' ',A.DEapellido2 ,' ' ,A.DEnombre" returnvariable="DEnombrecompleto">
             <cf_conlis maxrowsquery="200" form="form2"
                Campos="DEid,DEidentificacion,DEnombrecompleto"  
                Size="0,10,40" 
                Desplegables="N,S,S"
                Modificables="N,S,N"
                Asignar="DEid,DEidentificacion,DEnombrecompleto" 
                Asignarformatos="I,S,S"
                Columnas="distinct A.DEid ,A.DEidentificacion,#PreserveSingleQuotes(DEnombrecompleto)# as DEnombrecompleto"
                Tabla="DatosEmpleado A 
                       inner join  AFResponsables B
                        on A.DEid = B.DEid
                        and A.Ecodigo = B.Ecodigo 
                        and #hoy# between B.AFRfini and B.AFRffin" 
                Filtro="A.Ecodigo = #Session.Ecodigo# order by DEidentificacion,DEnombrecompleto"
                Desplegar="DEidentificacion,DEnombrecompleto"
                Formatos="S,S"
                Align="left,left"
                Etiquetas="Identificaci&oacute;n,Nombre"
                tabindex="2"
                filtrar_por="A.DEidentificacion,#PreserveSingleQuotes(DEnombrecompleto)#"
                Title="Lista de Empleados"
               />		
          </td>
       </tr>      
	</table>
	</fieldset>
	</td>
	</tr>
	</table>
</form>
</cfoutput>
<cf_qforms objForm="objForm2" form="form2">
<script language="javascript" type="text/javascript">
	<!--//
	function funcGenerar(){
		var filtros = new String("");
		var aux = new String("");
		if (objForm2.Aid.getValue()){
			filtros+=aux+" Activo "+ objForm2.Aplaca.getValue() + "-" + objForm2.Adescripcion.getValue();aux=",";
		}
		if (objForm2.AFCcodigo.getValue()){
			filtros+=aux+" Tipo "+ objForm2.AFCcodigoclas.getValue() + "-" + objForm2.AFCdescripcion.getValue();aux=",";
		}
		if (objForm2.CFid.getValue()){
			filtros+=aux+" Centro Funcional "+ objForm2.CFcodigo.getValue() + "-" + objForm2.CFdescripcion.getValue();aux=",";
		}
		if (objForm2.Ocodigo.getValue()){
			filtros+=aux+" Oficina "+ objForm2.Oficodigo.getValue() + "-" + objForm2.Odescripcion.getValue();aux=",";
		}
		if (objForm2.ACcodigo.getValue()){
			filtros+=aux+" Categoría "+ objForm2.ACcodigodesc.getValue() + "-" + objForm2.ACdescripcion.getValue();aux=",";
		}
		if (objForm2.ACid.getValue()){
			filtros+=aux+" Clase "+ objForm2.ACcodigodesc_clas.getValue() + "-" + objForm2.ACdescripcion_clas.getValue();aux=",";
		}
		if (objForm2.DEid.getValue()){
			filtros+=aux+" Empleado "+ objForm2.DEidentificacion.getValue() + "-" + objForm2.DEnombrecompleto.getValue();aux=",";
		}
		if (filtros.length==0) {
			alert("Se presentaron los siguientes errores:\n\n-Debe definir al menos un criterio de filtro para \ngenerar la lista de activos asociados a la hoja!");
			return false;
		}
		return confirm("¿Confirma que desea generar activos en esta hoja de conteo correspondientes con los siguientes filtros: "+filtros+"?");
	}
	function limpiaClase(){
		objForm2.ACid.obj.value='';
		objForm2.ACcodigodesc_clas.obj.value='';
		objForm2.ACdescripcion_clas.obj.value='';
	}
	//-->
</script>