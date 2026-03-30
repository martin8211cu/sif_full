<cfset ValuesArrayCat=ArrayNew(1)>
<cfset ValuesArrayCla=ArrayNew(1)>

<cfif modo EQ 'cambio'>
	<cfquery name="ClasConcep" datasource="#Session.DSN#">
		select padre.FPCCid,padre.FPCCcodigo,padre.FPCCdescripcion,padre.FPCCtipo,padre.FPCCconcepto,padre.FPCCcomplementoC,padre.FPCCcomplementoP,padre.FPCCidPadre, padre.CFcuenta,
		padre.BMUsucodigo,padre.FPCCTablaC,padre.ts_rversion,FPCCExigeFecha,FormatoCuenta,EspecificaCuenta,
		(select count(1) from FPCatConcepto as hijos where hijos.Ecodigo = #session.Ecodigo# and hijos.FPCCidPadre = padre.FPCCid) as hijos
			from FPCatConcepto padre
		where padre.FPCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#URL.FPCCid#">
	</cfquery>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#ClasConcep.ts_rversion#" returnvariable="ts"></cfinvoke>
	<cfif ClasConcep.FPCCconcepto EQ 'F' and LEN(TRIM(ClasConcep.FPCCTablaC))>
		<cfif LEN(TRIM(ClasConcep.FPCCTablaC))>
			<cfquery name="rsClase" datasource="#session.DSN#">
				select AClaId, ACcodigodesc, ACdescripcion, ACcodigo
					from AClasificacion
				where AClaId =  #ClasConcep.FPCCTablaC#
				  and Ecodigo = #session.Ecodigo#
			</cfquery>
			<cfset ArrayAppend(ValuesArrayCla,rsClase.AClaId)>
			<cfset ArrayAppend(ValuesArrayCla,rsClase.ACcodigodesc)>
			<cfset ArrayAppend(ValuesArrayCla,rsClase.ACdescripcion)>
			<cfif rsClase.Recordcount GT 0 and LEN(TRIM(rsClase.ACcodigo))>
				<cfquery name="rsClategoria" datasource="#session.DSN#">
					select ACcodigo,ACcodigodesc,ACdescripcion
						from ACategoria
						where ACcodigo = #rsClase.ACcodigo#
						and Ecodigo = #session.Ecodigo#
				</cfquery>
				<cfset ArrayAppend(ValuesArrayCat,rsClategoria.ACcodigo)>
				<cfset ArrayAppend(ValuesArrayCat,rsClategoria.ACcodigodesc)>
				<cfset ArrayAppend(ValuesArrayCat,rsClategoria.ACdescripcion)>
			</cfif>
		</cfif>
	<cfelseif ClasConcep.FPCCconcepto EQ 'A' and LEN(TRIM(ClasConcep.FPCCTablaC))>
		<cfquery name="rsClasificaciones" datasource="#session.DSN#">
			select Ccodigo,Ccodigoclas,Cdescripcion, Cnivel Nnivel
				from Clasificaciones
			where Ccodigo = #ClasConcep.FPCCTablaC#
			and Ecodigo = #session.Ecodigo#
		</cfquery>
	<cfelseif ListFind('S,P',ClasConcep.FPCCconcepto) and LEN(TRIM(ClasConcep.FPCCTablaC))>
		<cfquery name="rsCConceptos" datasource="#session.DSN#">
			select CCid,CCcodigo,CCdescripcion, CCnivel
				from CConceptos
			where CCid    = #ClasConcep.FPCCTablaC#
			  and Ecodigo = #session.Ecodigo#
		</cfquery>
	</cfif>
</cfif>
<cfoutput>
<form action="ClasificacionConcepto-sql.cfm" method="post" name="form1" onSubmit="javascript: return validar();" >
	<input type="hidden" name="FPCCid" 			value="#ClasConcep.FPCCid#" />
	<input type="hidden" name="ts_rversion" 	value="#ts#">
	<input type="hidden" name="idTree" 			value="#idTree#">
	<input type="hidden" name="Cantidadhijos" 	value="#ClasConcep.hijos#">
	
	<table border="0" cellspacing="1" cellpadding="1">
		<tr><td>Clasificacion Padre:</td>
			<cfif len(trim(ClasConcep.FPCCidPadre))>
			<td><cf_ConceptoGatosIngresos name="FPCCidPadre" popup="true" value="#ClasConcep.FPCCidPadre#" filtro="FPCCTablaC is null" funcionT="changetype(FPCCtipo,FPCCconcepto)"></td>
			<cfelse>
			<td><cf_ConceptoGatosIngresos name="FPCCidPadre" popup="true" filtro="FPCCTablaC is null" funcionT="changetype(FPCCtipo,FPCCconcepto)"></td>
			</cfif>
		</tr>
		<tr><td>Codigo:</td>
			<td><input name="FPCCcodigo" type="text" value="#ClasConcep.FPCCcodigo#"  size="20" maxlength="20" tabindex="1"></td>
		</tr>
		<tr><td>Descripcion:</td>
			<td><input name="FPCCdescripcion" type="text" value="#ClasConcep.FPCCdescripcion#"  size="20" maxlength="100" tabindex="1"></td>
		</tr>
		<tr><td>Tipo:</td>
			<td>
				<select name="FPCCtipo" onchange="valida()">
				  <option value="G" <cfif #ClasConcep.FPCCtipo# EQ 'G'> selected="selected"</cfif>>Egreso</option>
				  <option value="I" <cfif #ClasConcep.FPCCtipo# EQ 'I'> selected="selected"</cfif>>Ingreso</option>
				</select>
			</td>
		</tr>
		<tr>
		  <td>Indicador Auxiliar:</td>
			<td>
				<input type="hidden" name="FPCCconceptoInicial" value="#ClasConcep.FPCCconcepto#" />
				<select onchange="validaConcepto();showChkbox(this.form);" name="FPCCconcepto"></select>
			</td>
		</tr> 
		<tr>
			<td>Exigir Fechas</td>
			<td><input type="checkbox" name="FPCCExigeFecha" value="1" <cfif ClasConcep.FPCCExigeFecha EQ 1>checked="true"</cfif> /></td>
		</tr>
		<cfif ClasConcep.hijos EQ 0>
			<tr>
				<td>Complemento Contable:</td>
				<td><input name="FPCCcomplementoC" type="text" value="#ClasConcep.FPCCcomplementoC#"  size="20" maxlength="100" tabindex="1"></td>
			</tr>
			<tr>
				<td>Complemento Presupuestal:</td>
				<td><input name="FPCCcomplementoP" type="text" value="#ClasConcep.FPCCcomplementoP#"  size="20" maxlength="100" tabindex="1"></td>
			</tr>
		</cfif>
		
		<tr id="TR_R"><td>Especifica cuenta:</td>
			<td><input style="border-width:0; margin:0;" type="checkbox" onClick="javascript:mostrarCuenta(this);" name="EspecificaCuenta" <cfif modo neq 'ALTA' and ClasConcep.EspecificaCuenta eq 1>checked</cfif>  ></td>
		</tr>
		
		<!---CUENTA--->
		<tr id="cuenta">
			<td width="1%" nowrap align="right">Cuenta:&nbsp;</td>
			<td colspan="5">
				<cfif modo neq 'ALTA' and len(trim(ClasConcep.CFcuenta))>
					<cfquery name="rsCuenta" datasource="#session.DSN#">
						select CFcuenta, Ccuenta, CFdescripcion, CFformato
						  from CFinanciera f
						 where Ecodigo =  #session.Ecodigo# 
						 and CFcuenta = #ClasConcep.CFcuenta#
			</cfquery>
					<cf_cuentas  Cdescripcion="Ccdescripcion" query="#rsCuenta#">
				<cfelse>
					<cf_cuentas Cdescripcion="Ccdescripcion">
				</cfif>
			</td>
		</tr>
		
		<tr id="TR_A">
			<td>Categoria:</td>
			<td>
				
				<cf_conlis
					Campos="ACcodigo, ACcodigodesc, ACdescripcion"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,10,40"
					ValuesArray="#ValuesArrayCat#"
					Title="Lista de Categorías"
					Tabla="ACategoria a"
					Columnas="ACcodigo, 
							  ACcodigodesc, 
							  ACdescripcion"
					Filtro="Ecodigo = #Session.Ecodigo# 
					order by ACcodigodesc, ACdescripcion"
					Desplegar="ACcodigodesc, ACdescripcion"
					Etiquetas="Código,Descripción"
					filtrar_por="ACcodigodesc, ACdescripcion"
					Formatos="S,S"
					Align="left,left"
					Asignar="ACcodigo, ACcodigodesc, ACdescripcion"
					Asignarformatos="I,S,S,S"
					
					tabindex="2" />
			</td>
		</tr>
		<tr id="TR_A2">
			<td>Clase:</td>
			<td>
				
				<cf_conlis
					Campos="AClaId, ACcodigodescClas, ACdescripcionClas"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,10,40"
					ValuesArray="#ValuesArrayCla#"
					Title="Lista de Clases"
					Tabla="AClasificacion a"
					Columnas="AClaId, ACcodigodesc as ACcodigodescClas, ACdescripcion as ACdescripcionClas, ACdescripcion as GATdescripcion"
					Filtro="Ecodigo = #Session.Ecodigo# 
					and ACcodigo = $ACcodigo,numeric$ 
					order by ACcodigodescClas, ACdescripcionClas"
					Desplegar="ACcodigodescClas, ACdescripcionClas"
					Etiquetas="Código,Descripción"
					filtrar_por="ACcodigodesc, ACdescripcion"
					Formatos="S,S"
					Align="left,left"
					Asignar="AClaId, ACcodigodescClas,ACdescripcionClas,GATdescripcion"
					Asignarformatos="I,S,S,S"
					debug="false"
					left="250"
					top="150"
					width="500"
					height="300"
					tabindex="2" />
			</td>
		</tr>
		<tr id="TR_I"><td>Clasificación de Articulos:</td>
			<td>
				<cfif isdefined('rsClasificaciones')>
					<cf_sifclasificacionarticulo query = "#rsClasificaciones#">
				<cfelse>
					<cf_sifclasificacionarticulo>
				</cfif>
			</td>
		</tr>
		<tr id="TR_S"><td>Clasificación de Servicio:</td>
			<td>
				<cfif isdefined('rsCConceptos')>
					<cf_sifclasificacionconcepto query="#rsCConceptos#">
				<cfelse>
					<cf_sifclasificacionconcepto>
				</cfif>
				</td>
		</tr>
		
		<tr><td colspan="2">
				<cf_botones modo='#MODO#'>
			</td>
		</tr>
	</table>
</form>


</cfoutput>
<cf_qforms>
	<cf_qformsRequiredField name="FPCCcodigo" 	 	description="Codigo">
	<cf_qformsRequiredField name="FPCCdescripcion"  description="Descripción">
</cf_qforms>
<script type="text/javascript">
	function valida()
	{

		if(document.form1.FPCCtipo.value == 'G')
			tipo = 'I'
		else
			tipo ='G'
		fnCambiarIndicadores(document.form1.FPCCtipo);
		if(document.form1.FPCCidPadre.value != '')
			changetype(tipo,document.form1.FPCCconcepto.value);
		showChkbox(document.form1);
	}
	
	function changetype(tipo,concepto)
	{
		var combo = document.forms["form1"].FPCCtipo;
		var cantidad = combo.length;
		for (i = 0; i < cantidad; i++) {
			  if (combo[i].value == tipo) {
				 combo[i].selected = true;
			  }   
		   }
		fnCambiarIndicadores(combo);
		var combo2 = document.forms["form1"].FPCCconcepto;
		for (i = 0; i < combo2.length; i++) {
			  if (combo2[i].value == concepto) {
				 combo2[i].selected = true;
			  }   
		   }
		document.form1.FPCCconceptoInicial.value = concepto;
		showChkbox(document.form1);
	}
	function validaConcepto()
	{
		if(document.form1.FPCCidPadre.value != ''){
			changetype(document.form1.FPCCtipo.value,document.form1.FPCCconceptoInicial.value);
		}
	}
	
	function showChkbox(f)
	{
		var TR_A  = document.getElementById("TR_A");
		var TR_A2 = document.getElementById("TR_A2");
		var TR_I  = document.getElementById("TR_I");
		var TR_S  = document.getElementById("TR_S");
		
		var TR_R  = document.getElementById("TR_R");
		var cuenta  = document.getElementById("cuenta");

		
		TR_A.style.display  = "none";
		TR_A2.style.display = "none";
		TR_I.style.display  = "none";
		TR_S.style.display  = "none";
		
		TR_R.style.display  = "none";
		cuenta.style.display  = "none";

		
		objForm.AClaId.description    = 'Clase';
		objForm.Ccodigo.description = 'Clasificación de Articulos';
		objForm.CCid.description 	= 'Clasificación de Servicios';
		
		if (f.FPCCconcepto.value == 'F' & f.Cantidadhijos.value == 0)
		{
			TR_A.style.display  = "";
			TR_A2.style.display  = "";
		}
		else
			f.AClaId.value="";
		if (f.FPCCconcepto.value == 'A' & f.Cantidadhijos.value == 0)
		{
			TR_I.style.display  = "";
		}
		else
			f.Ccodigo.value="";
		if ((f.FPCCconcepto.value == 'S' || f.FPCCconcepto.value == 'P') & f.Cantidadhijos.value == 0)
		{
			TR_S.style.display  = "";
		}
		else
			f.CCid.value = "";
			
			
	if ((f.FPCCconcepto.value == '2' || f.FPCCconcepto.value == '1') & f.Cantidadhijos.value == 0)
		{
			TR_R.style.display  = "";
			cuenta.style.display  = "";
		}
	}
	// Indicadores, se crea un array con los indicadores por si en un futuro se desean ingresar más.
	var indicadoresArray = new Array(new Array('F','Activo Fijo','G'), 
		new Array('A','Artículos Inventario','G'),
		new Array('S','Gastos o Servicio','G'),
		new Array('P','Obras en Proceso','G'),
		new Array('2','Concepto Salarial','G'),
		new Array('3','Amortización de Prestamos','G'),
		new Array('1','Otros','G'),
		new Array('4','Financiamiento','I'),
		new Array('5','Patrimonio','I'),
		new Array('6','Ventas','I'));
	
	// Muestra los indicadores pertenecientes al tipo(Gasto ó Ingreso)
	function fnCambiarIndicadores(obj){
		combo = document.form1.FPCCconcepto;
		if(combo.hasChildNodes()){
			while(combo.childNodes.length >= 1 )
				combo.removeChild(combo.firstChild );       
		}
		for(var i = 0; i < indicadoresArray.length; i++){
			if (fnBuscarTipo(indicadoresArray[i],obj.value)){
				var option = document.createElement("option");
				option.value = indicadoresArray[i][0];
				option.innerHTML = indicadoresArray[i][1];
				option.selected = ("<cfoutput>#ClasConcep.FPCCconcepto#</cfoutput>" == indicadoresArray[i][0] ? true : false);
				combo.appendChild(option);
			}
		}
	}
	
	
	// Busca en el array el tipo(Gasto ó Ingreso) del indicador
	function fnBuscarTipo(array, indicador){
		if(indicador == array[2])
			return true;
		return false;
	}
	
	var validar1 = true;
	function validar(){
		if (validar1){
			var error = false;
			var mensaje = "Se presentaron los siguientes errores:\n";
			<cfif modo neq 'ALTA'>
				if ( document.form1.EspecificaCuenta.checked && ( trim(document.form1.Ccuenta.value) == '' ) ){
					error = true;
					mensaje += " - El campo Cuenta es requerido.\n";
				}
			</cfif>
	
			if ( error ){
				alert(mensaje);
				return false;
			}
			else{
		
				document.form1.EspecificaCuenta.disabled 	= false;
	
				return true;
			}
		}
		else{
			return true;
		}	
	}
	

	fnCambiarIndicadores(document.form1.FPCCtipo);
	showChkbox(document.form1);	
	
	function mostrarCuenta(obj){
		if( obj.checked ){
			document.getElementById("cuenta").style.visibility = 'visible';
			document.getElementById("cuenta").style.visibility = 'visible';
			
		}
		else{
			document.getElementById("cuenta").style.visibility = 'hidden';
		}
	}

	// activa o desactiva la cuenta financiera
	mostrarCuenta(document.form1.EspecificaCuenta);
	

</script>