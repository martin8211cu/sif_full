<cfcomponent output="false">

	<cffunction name="ValidaContenido" access="remote" returntype="array" returnformat="json" output="false">

		<cfset errorText = "">
		<cfset datosText = "">
		<cfset unStatus = 1>

		<cfset Local.obj = {status = unStatus,errorTexto= errorText,datosTexto = datosText}>
		<cfquery name="err" datasource="sifcontrol">
			select
				  *
			from IErrores
			where IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#(isdefined('session.IdBitacora') ? session.IdBitacora : 0)#">
		</cfquery>

		<cfif err.RecordCount gt 0>
			<cfset errorText = "El archivo fue cargado con errores, revise el informe de errores">
			<cfset unStatus = 0>
		</cfif>

		<cfquery name="rsDatos" datasource="#session.dsn#">
			select
				NoOrdPago,
				FecGenManual,
				FecPago,
				Referencia
			from
				TESDatosOPImportador
			where IdTransaccion = '#session.idTransaccion#'
		</cfquery>


		<cfif rsDatos.RecordCount eq 0>
			<cfset datosText = "No hay datos para mostrar">
			<cfset unStatus = 0>
		</cfif>

		<cfscript>
			var LOCAL = StructNew();
			LOCAL.Datos = ArrayNew(1);

			ArrayAppend(LOCAL.Datos, unStatus);
			ArrayAppend(LOCAL.Datos, errorText);
			ArrayAppend(LOCAL.Datos, datosText);

			return(LOCAL.Datos);
		</cfscript>
	</cffunction>

	<cffunction name="getListaErr" access="remote" output="true">
		<cfargument name="IdBitacora" type="numeric" />
		<cfif IsDefined('session.IdBitacora') and session.IdBitacora neq 0>
			<cfquery name="eii" datasource="sifcontrol">
				select ib.IBid, ib.IBhash, ib.EIid from IBitacora ib
				where ib.IBid = #session.IdBitacora#
			</cfquery>
			<cfset session.HashB = eii.IBhash>
			<cfquery name="err" datasource="sifcontrol">
				select
					  IBlinea as Linea
					, case IBerror
						when 1 then 'Sobran Columnas'
						when 2 then 'Fecha Incorrecta'
						when 3 then 'Dato Entero'
						when 4 then 'Dato Numerico Erroneo'
						when 5 then 'Faltan Columnas'
						else 'Incorrecto'
					end as TipoError
					, IBcolumna
					, IBdatos
					, IBid
					, IEid
				from IErrores
				where IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.IdBitacora#">
			</cfquery>
			<cfif err.RecordCount gt 0>
				<script type="text/javascript" language="JavaScript" src="/cfmx/commons/js/pLista1.js"></script>
				<table width="70%">
					<tr>
						<div id="miLista" class="animate-bottom">
							<table class="PlistaTable" align="center" border="0" cellspacing="0" cellpadding="0" width="70%">
								<thead>
									<tr>
										<th style="text-indent: 10px" class="tituloListas" align="Right"  height="17"><strong>Linea</strong></th>
										<th style="text-indent: 10px" nowrap class="tituloListas" align="Left" valign="bottom"><strong>Tipo error</strong></th>
										<th style="text-indent: 10px" nowrap class="tituloListas" align="Right" valign="bottom"><strong>Columna</strong></th>
										<th style="padding: 0px 0px 0px 10px;" class="tituloListas" align="Left" valign="bottom"><strong>Descripci&oacute;n</strong></th>
									</tr>
								</thead>
								<cfset currRow = 1>
								<cfset strCLass = "listaNon">
								<cfloop query="err">
									<cfoutput>
										<cfif currRow mod 2 eq 0>
											<cfset strCLass = "listaPar">
										<cfelse>
											<cfset strCLass = "listaNon">
										</cfif>
										<tr class="#strCLass#" onmouseover="this.className='#strCLass#Sel';" onmouseout="this.className='#strCLass#';">
											<td style="text-indent: 10px" align="Right"  height="18" onclick="javascript: return funcProcesar('#err.IBid#','#err.IEid#');">#err.Linea#</td>
											<td style="text-indent: 10px" align="Left"  height="18"  onclick="javascript: return funcProcesar('#err.IBid#','#err.IEid#');">#err.TipoError#</td>
											<td style="text-indent: 10px" align="Right"  height="18"  onclick="javascript: return funcProcesar('#err.IBid#','#err.IEid#');">#err.IBcolumna#</td>
											<td style="padding: 0px 0px 0px 10px;" align="Left"  height="18"  onclick="javascript: return funcProcesar('#err.IBid#','#err.IEid#');">#err.IBdatos#</td>
										</tr>
									</cfoutput>
									<cfset currRow = currRow + 1>
								</cfloop>
								<cfif strCLass eq "listaPar">
									<cfset strCLass = "listaNon">
								</cfif>
								<tr align="center" class="#strCLass#">
									<td colspan="4" align="center"><input name="btnDescargar" class="btnDescargar" value="Descargar" type="button" onclick="funDescargar()">
									<input id="btnRegresar" value="Regresar" type="button" onclick="funRegresar()">
									<input id="unHash" type="hidden" value="<cfoutput>#session.HashB#</cfoutput>"></td>
								</tr>
							</table>
						</div>
					</tr>
				</table>
			</cfif>
		</cfif>

	</cffunction>

</cfcomponent>