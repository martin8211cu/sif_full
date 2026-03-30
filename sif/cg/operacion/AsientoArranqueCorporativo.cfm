<cfset LvarTitulo = "Arrancar de Saldos Iniciales Corporativos">
<cf_templateheader title="#LvarTitulo#">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LvarTitulo#'>
	<cfset LvarMes = arrayNew(1)>
	<cfset LvarMes[1]	= "Enero">
	<cfset LvarMes[2]	= "Febrero">
	<cfset LvarMes[3]	= "Marzo">
	<cfset LvarMes[4]	= "Abril">
	<cfset LvarMes[5]	= "Mayo">
	<cfset LvarMes[6]	= "Junio">
	<cfset LvarMes[7]	= "Julio">
	<cfset LvarMes[8]	= "Agosto">
	<cfset LvarMes[9]	= "Setiembre">
	<cfset LvarMes[10]	= "Octubre">
	<cfset LvarMes[11]	= "Noviembre">
	<cfset LvarMes[12]	= "Diciembre">
	<cfquery datasource="#session.dsn#" name="Periodo">
		select Pvalor from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = 30
	</cfquery>

	<cfquery datasource="#session.dsn#" name="Mes">
		select Pvalor from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = 40
	</cfquery>

	<cfquery datasource="#session.dsn#" name="MesCierreFiscal">
		select Pvalor 
		from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = 45
	</cfquery>

	<cfquery datasource="#session.dsn#" name="MesCierreCorporativo">
		select Pvalor 
		from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = 46
	</cfquery>

	<cfquery datasource="#session.dsn#" name="FechaArranque">
		select Pvalor 
		from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = 47
	</cfquery>
	<cfif FechaArranque.Pvalor EQ "" or not isdate(FechaArranque.Pvalor)>
		<cfset LvarPerArranque = 0>
		<cfset LvarMesArranque = 0>
	<cfelse>
		<cfset LvarFecha = LSParseDateTime(FechaArranque.Pvalor)>
		<cfset LvarPerArranque = datePart("yyyy",LvarFecha)>
		<cfset LvarMesArranque = datePart("m",LvarFecha)>
	</cfif>

	<cfquery datasource="#session.dsn#" name="rsInicioConta">
		select min(Speriodo*100 + Smes) as AnoMes
		  from SaldosContables
		 where Ecodigo = #session.Ecodigo#
		   and (SLinicial <> 0 OR SOinicial <> 0)
	</cfquery>
	<cfif rsInicioConta.AnoMes EQ "">
		<cfquery datasource="#session.dsn#" name="rsInicioConta">
			select min(Speriodo*100 + Smes) as AnoMes
			  from SaldosContables
			 where Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfif rsInicioConta.AnoMes EQ "">
			<cfthrow message="No ha habido ningún movimiento contable en la Empresa">
		</cfif>
	</cfif>
	
	<cfoutput>
	<form name="frmArranque" method="post" enctype="multipart/form-data" action="AsientoArranqueCorporativo_sql.cfm"
				onsubmit="
				<cfif MesCierreCorporativo.Pvalor NEQ "" and MesCierreCorporativo.Pvalor GT 0>
					if(confirm('¿Desea Reinicializar los Saldos Iniciales Corporativos?'))
				</cfif>
					{
						//document.frmArranque.disabled=true;
						//document.frmArranque.btnArrancar1.disabled=true;
						//document.frmArranque.btnArrancar2.disabled=true;
						//document.frmArranque.btnArrancar3.disabled=true;
						//document.frmArranque.btnExportar.disabled=true;
						document.getElementById('divArrancar').style.display = '';
					}
				"
			>
		<table width="100%">
			<tr>
				<td>
					Empresa:
				</td>
				<td>
					#session.Enombre#
				</td>
				<td width="40%">
				</td>
			</tr>
			<tr>
				<td>
					Periodo y Mes de Arranque de Contabilidad:
				</td>
				<td>
					#mid(rsInicioConta.AnoMes,1,4)# #LvarMes[mid(rsInicioConta.AnoMes,5,2)]#
				</td>
			</tr>
			<tr>
				<td>
					Periodo y Mes Actual de Contabilidad:
				</td>
				<td>
					#Periodo.Pvalor# #LvarMes[Mes.Pvalor]#
				</td>
			</tr>
			<tr>
				<td>
					Mes de Cierre Fiscal:
				</td>
				<td>
					#LvarMes[MesCierreFiscal.Pvalor]#
				</td>
			</tr>
			<tr>
				<td>
					Mes de Cierre Corporativo:
				</td>
				<td>
					<cfif MesCierreCorporativo.Pvalor EQ "">
						<cfset LvarMesCorporativo = MesCierreFiscal.Pvalor>
					<cfelse>
						<cfset LvarMesCorporativo = MesCierreCorporativo.Pvalor>
					</cfif>
					<select name="MesCorporativo" onchange="sbEscogerTipo();">
					<cfloop index="i" from="1" to="12">
						<option value="#i#" <cfif i EQ abs(LvarMesCorporativo)>selected</cfif>>#LvarMes[i]#</option>
					</cfloop>
					</select>
					<cfif LvarMesCorporativo LT 0>
						(No se ha inicializado)
					</cfif>
				</td>
			</tr>
			<tr>
				<td nowrap="nowrap">
					Período y Mes de Arranque de Saldos Iniciales Coporativos:&nbsp;

				</td>
				<td>
					<select name="PerArrancar">
					<cfloop index="i" from="#mid(rsInicioConta.AnoMes,1,4)#" to="#Periodo.Pvalor#">
						<option value="#i#" <cfif i EQ LvarPerArranque>selected</cfif>>#i#</option>
					</cfloop>
					</select>
					<select name="MesArrancar" onchange="sbEscogerTipo();">
					<cfloop index="i" from="1" to="12">
						<option value="#i#" <cfif i EQ LvarMesArranque>selected<cfelseif LvarMesArranque EQ 0 AND i EQ mid(rsInicioConta.AnoMes,5,2)>selected</cfif>>#LvarMes[i]#</option>
					</cfloop>
					</select>

				</td>
			</tr>
			<tr>
				<td>
					Archivo de Saldos Iniciales Corporativos:
				</td>
				<td colspan="3">
					<input type="file" name="Archivo" size="80" onclick="this.value='';" />
				</td>
			</tr>
		<cfif MesCierreCorporativo.Pvalor EQ 0>
			<script language="javascript">
				alert("Hay un Proceso de Arranque en marcha");
			</script>
		<cfelse>
			<tr id="TR_btnArranque1">
				<td align="center" colspan="3">
					<BR>
					<input type="submit" name="btnArrancar1" value="Arrancar Saldos Iniciales Corporativos"
						onclick="if (document.frmArranque.Archivo.value != '') return confirm('El Arranque de Saldos Iniciales Corporativos = Fiscales no requiere Archivo. \n¿Desea realizar el Arranque sin la importación del Archivo de Saldos Iniciales?');"
					>
				</td>
			</tr>
			<tr id="TR_btnArranque2" style="display:none;">
				<td align="center" colspan="3">
					<BR>
					<input type="submit" name="btnArrancar2" value="Arrancar Saldos Iniciales Corporativos"
						onclick="if (document.frmArranque.Archivo.value != '') return confirm('El Arranque de Saldos Iniciales Corporativos al inicio del Período Corporativo no requiere Archivo. \n¿Desea realizar el Arranque sin la importación del Archivo de Saldos Iniciales Corporativos?');"
					>
				</td>
			</tr>
			<tr id="TR_btnArranque3" style="display:none;">
				<td align="center" colspan="3">
					<BR>
					<input type="button" name="btnExportar" value="Exportar Saldos Contables"
						onclick="
								if (confirm('¿Desea exportar los Saldos Iniciales Fiscales para ' + document.frmArranque.PerArrancar.value+ '/' +document.frmArranque.MesArrancar.value+'?'))
									document.getElementById('ifrExp').src='AsientoArranqueCorporativo_sql.cfm?btnExportar&Per='  + document.frmArranque.PerArrancar.value+ '&Mes=' +document.frmArranque.MesArrancar.value;"
					>
					<input type="submit" name="btnArrancar3" value="Importar y Arrancar Saldos Iniciales Corporativos"
						onclick="if (document.frmArranque.Archivo.value == '') 
								 {
									alert('Favor indicar el Archivo que desea Importar'); 
									return false;
								 }
								 	else
										return confirm('¿Desea importar los Saldos Iniciales Corporativos para ' + document.frmArranque.PerArrancar.value+ '/' +document.frmArranque.MesArrancar.value+'?');
								"
					>
					<iframe id="ifrExp" style="display:none"></iframe>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="3">&nbsp;
				</td>
			</tr>
			<tr>
				<td id="TDCF" align="left" colspan="3" bordercolor="##0033FF" style="border:solid">
					<strong>Iniciar Saldos Corporativos cuando los Meses de Cierre Fiscal y Corporativo son iguales:</strong>
						<ul>
							<li>Los Saldos Iniciales de las todas las Cuentas Fiscal y Corporativos siempre se mantienen automáticamente iguales</li>
							<li>Como los Saldos Fiscal y Corporativos son iguales, se pueden sacar reportes Corporativos en cualquier fecha</li>
						</ul>

				</td>
			</tr>
			<tr>
				<td id="TDPC" align="left" colspan="3" bordercolor="##0033FF" style="border:none">
					<strong>Iniciar Saldos Corporativos al Inicio de un Período Corporativo:</strong>
						<ul>
							<li>Si se arranca los Saldos Iniciales Corporativos al inicio de un Período Corporativo (Siguiente Mes al Cierre Corporativo) los Saldos Iniciales Coporativos de las cuentas de Resultado se inicializan en CERO y su saldo Fiscal pasa automáticamente al Saldo Inicial Corporativo de la Cuenta de Utilidad del Período</li>
							<li>Los Saldos Iniciales de las Cuentas de Balance Fiscal y Corporativos siempre se mantienen automáticamente iguales</li>
							<li>Antes del Período y Mes de Arranque los Saldos Coporativos de todas las cuentas se inicializan en CERO, y por tanto, no se  pueden sacar reportes Corporativos antes de dicha fecha</li>
						</ul>

				</td>
			</tr>
			<tr>
				<td id="TDOI" align="left" colspan="3" bordercolor="##0033FF" style="border:none">
					<strong>Iniciar Saldos Corporativos otro mes diferente al inicio del Período Corporativo:</strong>
						<ul>
							<li>Si se arranca los Saldos Iniciales Corporativos un mes diferente al inicio de un Período Corporativo se deben cargar los Saldos  Iniciales Corporativos de las Cuentas de Resultados (Ingresos y Gastos), y la  diferencia con respecto a los Saldos Iniciales Fiscales del mismo mes pasan  automáticamente al Saldo Inicial Corportivo de la Cuenta de Utilidad del  Período</li>
							<li>Los Saldos Iniciales de las Cuentas de Balance Fiscal y Corporativos siempre se mantienen automáticamente iguales</li>
							<li>Antes del Período y Mes de Arranque los Saldos Coporativos de todas las cuentas se inicializan en CERO, y por tanto, no se  pueden sacar reportes Corporativos antes de dicha fecha</li>
							<li>Antes del Período y Mes de Arranque los Saldos Coporativos de todas las cuentas se inicializan en CERO, y por tanto, no se  pueden sacar reportes Corporativos antes de dicha fecha</li>
						</ul>
						<ol>
							<li>Indique Mes de Cierre Corporativo, Período y Mes de Arranque </li>
							<li>Exporte los Saldos Iniciales Fiscales de las Cuentas de Resultados</li>
							<li>Modifique en Excel los Saldos Fiscales por los Saldos Corporativos (La diferencia pasa automáticamente al Saldo Corporativo de la Cuenta de Utilidades)</li>
							<li>Elimine la primera Línea de Encabezado y salve el archivo en formato CVS</li>
							<li>Importe los nuevos Saldos Iniciales Corporativos (Asegúrese que sean correctos los valores: Mes de Cierre Corporativo, Período y Mes de Arranque)</li>
						</ol>

				</td>
			</tr>
			<tr>
				<td align="left" colspan="3">&nbsp;</td>
			</tr>
			</cfif>
		</table>
	</form>
	<script language="javascript">
		// TDCF: Cierre Fiscal
		// TDPC: Inicio Periodo Corporativo
		// TDOI: Otro Inicio
		sbEscogerTipo();
		var GvarExportar = false;
		function sbEscogerTipo()
		{
			var LvarMesCierreCorp	= parseInt(document.frmArranque.MesCorporativo.value);
			var LvarPerArrancar		= parseInt(document.frmArranque.PerArrancar.value);
			var LvarMesArrancar		= parseInt(document.frmArranque.MesArrancar.value);
			
			if (LvarMesCierreCorp == #MesCierreFiscal.Pvalor#)
			{
				document.getElementById("TR_btnArranque1").style.display = "";
				document.getElementById("TR_btnArranque2").style.display = "none";
				document.getElementById("TR_btnArranque3").style.display = "none";

				document.getElementById("TDCF").style.border = "solid";
				document.getElementById("TDPC").style.border = "none";
				document.getElementById("TDOI").style.border = "none";
			}
			else if (LvarMesCierreCorp % 12 + 1 == LvarMesArrancar)
			{
				document.getElementById("TR_btnArranque1").style.display = "none";
				document.getElementById("TR_btnArranque2").style.display = "";
				document.getElementById("TR_btnArranque3").style.display = "none";

				document.getElementById("TDCF").style.border = "none";
				document.getElementById("TDPC").style.border = "solid";
				document.getElementById("TDOI").style.border = "none";
			}
			else
			{
				document.getElementById("TR_btnArranque1").style.display = "none";
				document.getElementById("TR_btnArranque2").style.display = "none";
				document.getElementById("TR_btnArranque3").style.display = "";

				document.getElementById("TDCF").style.border = "none";
				document.getElementById("TDPC").style.border = "none";
				document.getElementById("TDOI").style.border = "solid";
			}
		}
	</script>
	<div id="divArrancar" style="display:none; width=800px; background:##FFFFFF; height:150px; border:solid 2px ##666666; text-align:center; position:absolute;
	top:250px; left:250px;">
		<BR><BR><BR>Inicializando Saldos Iniciales Corporativos<BR>
		<img src="wait.gif" />
	</div>
	</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>
