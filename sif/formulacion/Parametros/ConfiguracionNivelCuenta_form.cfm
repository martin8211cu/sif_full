<table border="0" align="center" width="100%">
	<tr id="TR_I">
		<td>
			<strong>Cuentas de Ingresos:</strong>&nbsp;
		</td>
	</tr>
	<tr id="TR_E">
		<td>
			<strong>Cuentas de Egresos:</strong>&nbsp;
		</td>
	</tr>
	<tr id="TR_IT">
		<td>
			<strong>Cuentas de Ingresos-Transferencias:</strong>&nbsp;
		</td>
	</tr>
	<tr id="TR_ET">
		<td>
			<strong>Cuentas de Egresos-Transferencias:</strong>&nbsp;
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr id="TR_Ingresos">
		<td>
			<cfinvoke
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="rsLista"
				query="#rsListaIngreso#"
				columnas="Cmayor1,Cdescripcion1"
				desplegar="Cmayor1,Cdescripcion1"
				etiquetas="Cuenta Mayor,Descripción"
				formatos="S,S"
				align="left,left,left"
				ajustar="S"
				keys="Cmayor1"
				irA="ConfiguracionNivelCuenta.cfm"
				maxrows="15"
				pageindex="3"
				showEmptyListMsg= "true"
				checkboxes= "N"
				form_method="post"
				incluyeForm="true"
				formName="form2"
				usaAJAX = "no"
			/>
		</td>
	</tr>
	<tr id="TR_Egresos">
		<td>
			<cfinvoke
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="rsLista"
				query="#rsListaEgresos#"
				columnas="Cmayor2,Cdescripcion2"
				desplegar="Cmayor2,Cdescripcion2"
				etiquetas="Cuenta Mayor,Descripción"
				formatos="S,S"
				align="left,left"
				ajustar="S"
				keys="Cmayor2"
				irA="ConfiguracionNivelCuenta.cfm"
				maxrows="15"
				pageindex="3"
				showEmptyListMsg= "true"
				checkboxes= "N"
				form_method="post"
				incluyeForm="true"
				formName="form3"
				usaAJAX = "no"
			/>
		</td>
	</tr>
	
	<tr id="TR_IngresosTransferencias">
		<td>
			<cfinvoke
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="rsLista"
				query="#rsListaIngresoTransferencia#"
				columnas="Cmayor3,Cdescripcion3"
				desplegar="Cmayor3,Cdescripcion3"
				etiquetas="Cuenta Mayor,Descripción"
				formatos="S,S"
				align="left,left,left"
				ajustar="S"
				keys="Cmayor3"
				irA="ConfiguracionNivelCuenta.cfm"
				maxrows="15"
				pageindex="3"
				showEmptyListMsg= "true"
				checkboxes= "N"
				form_method="post"
				incluyeForm="true"
				formName="form4"
				usaAJAX = "no"
			/>
		</td>
	</tr>
	
	<tr id="TR_EgresosTransferencias">
		<td>
			<cfinvoke
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="rsLista"
				query="#rsListaEgresosTransferencia#"
				columnas="Cmayor4,Cdescripcion4"
				desplegar="Cmayor4,Cdescripcion4"
				etiquetas="Cuenta Mayor,Descripción"
				formatos="S,S"
				align="left,left"
				ajustar="S"
				keys="Cmayor4"
				irA="ConfiguracionNivelCuenta.cfm"
				maxrows="15"
				pageindex="3"
				showEmptyListMsg= "true"
				checkboxes= "N"
				form_method="post"
				incluyeForm="true"
				formName="form5"
				usaAJAX = "no"
			/>
		</td>
	</tr>
</table>

<script language="javascript" type="text/javascript">
	var TR_Ingresos = document.getElementById("TR_Ingresos");
	var TR_Egresos = document.getElementById("TR_Egresos");
	var TR_IngresosTransferencias = document.getElementById("TR_IngresosTransferencias");
	var TR_EgresosTransferencias = document.getElementById("TR_EgresosTransferencias");
	TR_Ingresos.style.display = "";
	TR_Egresos.style.display = "";
	TR_IngresosTransferencias.style.display = "";
	TR_EgresosTransferencias.style.display = "";

	function seleccionar(type)
	{
		if(type == 'I')
		{
			TR_Ingresos.style.display = "";
			TR_Egresos.style.display = "none";
			TR_IngresosTransferencias.style.display = "none";
			TR_EgresosTransferencias.style.display = "none";
			document.getElementById("TR_I").style.display="";
			document.getElementById("TR_E").style.display="none";
			document.getElementById("TR_IT").style.display="none";
			document.getElementById("TR_ET").style.display="none";
		}
		else
		if(type == 'E') {
			TR_Ingresos.style.display = "none";
			TR_Egresos.style.display = "";
			TR_IngresosTransferencias.style.display = "none";
			TR_EgresosTransferencias.style.display = "none";
			document.getElementById("TR_I").style.display="none";
			document.getElementById("TR_E").style.display="";
			document.getElementById("TR_IT").style.display="none";
			document.getElementById("TR_ET").style.display="none";
		}
		else
		if(type == 'IT'){
			TR_Ingresos.style.display = "none";
			TR_Egresos.style.display = "none";
			TR_IngresosTransferencias.style.display = "";
			TR_EgresosTransferencias.style.display = "none";
			document.getElementById("TR_I").style.display="none";
			document.getElementById("TR_E").style.display="none";
			document.getElementById("TR_IT").style.display="";
			document.getElementById("TR_ET").style.display="none";
		}
		else{
			TR_Ingresos.style.display = "none";
			TR_Egresos.style.display = "none";
			TR_IngresosTransferencias.style.display = "none";
			TR_EgresosTransferencias.style.display = "";
			document.getElementById("TR_I").style.display="none";
			document.getElementById("TR_E").style.display="none";
			document.getElementById("TR_IT").style.display="none";
			document.getElementById("TR_ET").style.display="";
		}
	}
	 seleccionar('I');
</script>	

											