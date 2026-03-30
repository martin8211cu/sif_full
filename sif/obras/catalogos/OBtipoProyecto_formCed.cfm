<cfquery datasource="#session.dsn#" name="rsDet">
	select OBTPCnivel, OBTPCencabezado
	  from OBTPcedulaObrasDet
	 where OBTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBTPid#" null="#Len(form.OBTPid) Is 0#">
	 order by OBTPCcorte
</cfquery>

<cfoutput>
<table>
	<tr>
		<td valign="top" align="center" colspan="2" style="background-color:##CCCCCC">
			<strong>Parametrización de la Cédula de Obras en Construcción</strong><BR>
			(Definición de Cortes con base en los Niveles de la Cuenta Financiera)
		</td>
	</tr>
	<tr>
		<td valign="top">
			<strong>Clasificación de Objetos de Gasto:</strong>
		</td>
		<td valign="top">

			<cf_conlis
				Campos="PCCEclaidOG=PCCEclaid, PCCEcodigo, PCCEdescripcion"
				Desplegables="N,S,S"
				Modificables="N,S,N"
				Size="0,4,40"

				traerInicial="#rsForm.PCCEclaidOG NEQ ''#"  
				traerFiltro="PCCEclaid=#rsForm.PCCEclaidOG#"  

				Title="Lista de Clasificaciones de Catalogos del Plan de Cuentas"
				Tabla="PCClasificacionE"
				Columnas="PCCEclaid, PCCEcodigo, PCCEdescripcion"
				Filtrar_por="PCCEcodigo, PCCEdescripcion"
				Filtro="CEcodigo = #session.CEcodigo#"
				Desplegar="PCCEcodigo, PCCEdescripcion"
				Etiquetas="Código, Clasificacion"
				Formatos="S,S"
				Align="left,left"

				Asignar="PCCEclaidOG, PCCEcodigo, PCCEdescripcion"
				Asignarformatos="S,S,S"
				MaxRowsQuery="200"
			>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<table>
				<tr>
					<td><strong>Corte</strong></td>
					<td><strong>Nivel</strong></td>
					<td><strong>Encabezado</strong></td>
				</tr>
		<cfif rsForm.RecordCount GT 0>
			<cfloop query="rsDet">
				<cfset i=rsDet.currentRow>
				<tr>
					<td align="center">#i#</td>
					<td>
						<cf_inputNumber	name="OBTPCnivel#i#" 
									value="#rsDet.OBTPCnivel#"
									enteros="2" decimales="0"
						>
					</td>
					<td>
						<input 	type="text" 
								name="OBTPCencabezado#i#"
								id="OBTPCencabezado#i#"
								value="#rsDet.OBTPCencabezado#"/>
					</td>
				</tr>
			</cfloop>
		</cfif>
			<cfloop index="i" from="#rsDet.recordCount+1#" to="10">
				<tr>
					<td align="center">#i#</td>
					<td>
					<cf_inputNumber	name="OBTPCnivel#i#" 
								value="0"
								enteros="2" decimales="0"
					>
					</td>
					<td>
						<input 	type="text" 
								name="OBTPCencabezado#i#"
								id="OBTPCencabezado#i#"
								value=""/>
					</td>
				</tr>
			</cfloop>
			</table>
		</td>
	</tr>
</table>

<script language="javascript">
	function fnOBCOdetalle()
	{
		var LvarMSG = "";
		var LvarNIVs = ",";
		var j = 0;

		if (document.form1.PCCEclaidOG.value == "")
			LvarMSG += "\n    - El Campo Clasificación de Objetos de Gasto es requerido";

		for (var i = 1; i<=10; i++)
		{
			var LvarNivel = eval("document.form1.OBTPCnivel"+i).value;
			var LvarEncab = eval("document.form1.OBTPCencabezado"+i).value;
			eval("document.form1.OBTPCnivel"+i).value = "0";
			eval("document.form1.OBTPCencabezado"+i).value = "";
			if (LvarNivel != "" && parseInt(LvarNivel) != 0)
			{
				j++;
				eval("document.form1.OBTPCnivel"+j).value = LvarNivel;
				if (LvarNIVs.indexOf(","+LvarNivel+",") >= 0)
					LvarMSG += "\n    - El Nivel '" + LvarNivel + "' en el Corte '" + j + "' está repetido.";
				else if (LvarNivel == LobjQForm.OBTPnivelObjeto.value)
					LvarMSG += "\n    - El Nivel de Objeto de Gasto '" + LvarNivel + "' en el Corte '" + j + "' no puede ser parte de los niveles de corte de la Cédula.";
				else if (parseInt(LvarNivel) > parseInt(document.form1.MaxNivel.value))
					LvarMSG += "\n    - El Nivel '" + LvarNivel + "' en el Corte '" + j + "' no puede ser mayor que los niveles de cuenta '" + document.form1.MaxNivel.value + "'.";

				if (LvarEncab != "")
					eval("document.form1.OBTPCencabezado"+j).value = LvarEncab;
				else if (LvarNivel == LobjQForm.OBTPnivelProyecto.value)
					eval("document.form1.OBTPCencabezado"+j).value = "Proyecto";
				else if (LvarNivel == LobjQForm.OBTPnivelObra.value)
					eval("document.form1.OBTPCencabezado"+j).value = "Obra";
				else
					eval("document.form1.OBTPCencabezado"+j).value = "Nivel " + LvarNivel;
				LvarNIVs += LvarNivel + ",";
			}
			else
			{
				eval("document.form1.OBTPCnivel"+i).value = "0";
				eval("document.form1.OBTPCencabezado"+i).value = "";
			}
		}
		if (j < 2)
			LvarMSG += "\n    - La Cédula de Obras en Construcción debe incluir por lo menos 2 niveles: Proyecto y Obra";
		
		if (LvarMSG != "")
			this.error = "Errores en la Parametrización de la Cédula de Obras en Construcción:" + LvarMSG;
	}
</script>
</cfoutput>

