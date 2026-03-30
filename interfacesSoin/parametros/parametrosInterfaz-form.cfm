<cfquery name="rsMotor" datasource="sifinterfaces">
	select spFinal
	  from InterfazMotor
	 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>
<cfquery name="rsQuery" datasource="sifinterfaces">
	select NumeroInterfaz, Descripcion, OrigenInterfaz, TipoProcesamiento,
		Componente, Activa, FechaActivacion, FechaActividad, 
		NumeroEjecuciones, Ejecutando
		, TipoRetardo, MinutosRetardo
		, case Activa when 1 then 'Activa' else 'Inactiva' end as ActivaDescripcion
		, case OrigenInterfaz 
			when 'S' then 'SOIN-SIF' 
			else <cfif findNoCase("SOIN",Request.CEnombre)>'EXTERNO'<cfelse>'#Ucase(Request.CEnombre)#'</cfif>
		  end as OrigenInterfazDescripcion
		, case TipoProcesamiento 
			when 'S' then 'Sincrónico' 
			when 'D' then 'Sincrónico Directo' 
			when 'A' then 'Asincrónico'
			else '?????'
		  end as TipoProcesamientoDescripcion
		, case ManejoDatos 
			when 'T' then 'Tablas' 
			when 'V' then 'Variables' 
			else '?????'
		  end as ManejoDatosDescripcion
		, spFinalTipo, spFinal
		, ProcesosPorRequest, eMailErrores
		, MinutosAborto
	from Interfaz
	where NumeroInterfaz = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroInterfaz#">
</cfquery>
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<form action="parametrosInterfaz-sql.cfm" method="post" name="frmParams">
<cfoutput query="rsQuery">
	<input id="NumeroInterfaz" name="NumeroInterfaz" type="hidden" value="#NumeroInterfaz#" />
	<table style="border:1px solid ##CCCCCC" border="0" cellpadding="2" cellspacing="2">
	<tr>
		<td width="20%">
		</td>
		<td width="20%">
		</td>
		<td width="30%">
		</td>
		<td width="20%">
		</td>
	</tr>
	<tr>
		<td valign="middle" align="center" nowrap colspan="4" style="background-color:##E7E7E7">
			<strong>MANTENIMIENTO PARÁMETROS INTERFAZ</strong>
		</td>
	</tr>
	<tr>
		<td valign="middle" align="right" nowrap>
			<strong>N&uacute;mero Interfaz:&nbsp;</strong>
		</td>
		<td valign="middle" align="left" nowrap>
			<strong>#NumeroInterfaz#</strong>
		</td>
	</tr>
	<tr>
		<td valign="middle" align="right" nowrap>
			<strong>Descripci&oacute;n:&nbsp;</strong>
		</td>
		<td valign="middle" align="left" colspan="3">
			<strong>#Descripcion#</strong>
		</td>
	</tr>
	<tr>
		<td valign="middle" align="right" nowrap>
			<strong>Origen:&nbsp;</strong>
		</td>
		<td valign="middle" align="left">
			<strong>#OrigenInterfazDescripcion#</strong>
		</td>
	</tr>
	<tr>
		<td valign="middle" align="right" nowrap>
			<label for="MinutosRetardo" style="cursor:pointer;" onclick="alert(this.title);" 
			title="Tipo de Procesamiento:
- Asincrónico: Procesa los Datos de Entrada N minutos de retardo posterior a su invocación, registra su estado en Cola Procesos y registra su Finalización en Bitácora Procesos
- Sincrónico: Procesa los Datos de Entrada en Línea registrando su resultado en Bitácora Procesos
- Sincrónico Directo: Procesa los Datos de Entrada en Línea sin dejar Bitácora de Proceso"
>
				<strong>Tipo Procesamiento:&nbsp;</strong>
			</label>
		</td><td valign="middle" align="left" nowrap>
			<strong>#TipoProcesamientoDescripcion#</strong>
		</td>
		<td valign="middle" align="right" nowrap>
			<label for="ManejoDatos" style="cursor:pointer;" onclick="alert(this.title);" 
			title="Manejo de Datos:
- Por Tablas: Los datos de entrada se leen de las tablas IExx, IDxx, ISxx.  Los datos de salida deben guardarse en las tablas OExx, ODxx, OSxx
- Por Variables de Memoria: Los datos de entrada se leen de las variables GvarXML_IE, GvarXML_ID, GvarXML_IS.  Los datos de salida deben guardarse en las variables GvarXML_IE, GvarXML_ID, GvarXML_IS.  Ambos quedan almacenados automáticamente en la tabla InterfazDatosXML.
">
				<strong>Manejo Datos por:&nbsp;</strong>
			</label>
		</td>
		<td valign="middle" align="left" nowrap>
			<strong>#ManejoDatosDescripcion#</strong>
		</td>
	</tr>
	<tr>
	<td>&nbsp;</td>
	</tr>
	<tr>
	<td>&nbsp;</td>
	<td valign="middle" align="left" nowrap>
	<input id="Activa" name="Activa" 
		type="checkbox" 
		label="Activa"
		<cfif Activa>checked</cfif>
		value="#Activa#" />	
	<label for="MinutosRetardo" style="cursor:pointer;" onclick="alert(this.title);" 
			title=
"Ejecución Activa: Si la Interfaz es Externa y está Inactiva, su invocación provocará un Error
Si la Interfaz es Interna y está Inactiva, su invocación será ignarada, y por tanto no generará error">
		<strong>Activa</strong>
	</label>	 
	</td>
	</tr>
	<tr>
	<cfif TipoProcesamiento EQ 'A'>
		<td valign="middle" align="right" nowrap>
			<label for="MinutosRetardo" style="cursor:pointer;" onclick="alert(this.title);" title=
"Tiempo de Retardo entre la invocación a la interfaz y el inicio del procesamiento Asincrónico"
><strong>Tipo Retardo:&nbsp;</strong></label>
		</td>
		<td valign="middle" align="left" nowrap>
			<span style="width:320px;">
			<select name="TipoRetardo" onchange="sbTipoRetardo(this.value);">
				<option value="M" <cfif TipoRetardo EQ "M">selected</cfif>>Activar la cola cada N minutos:</option>
				<option value="H" <cfif TipoRetardo EQ "H">selected</cfif>>Activar la cola únicamente a las:</option>
			</select>
			<cfif trim(MinutosRetardo) EQ "">
				<cfset LvarMinutosRetardo = "0">
			<cfelse>
				<cfset LvarMinutosRetardo = rsQuery.MinutosRetardo>
			</cfif>
			<cfif TipoRetardo EQ "M">
				<input id="MinutosRetardo" name="MinutosRetardo"  
					size="10" maxlength="10" type="text" 
					label="Minutos Retardo"
					onKeyPress="return acceptNum(event)"
						value="#LvarMinutosRetardo#" 
				/>	
				<input type="text" id="MinutosRetardoHH" name="MinutosRetardoHH"  
					size="2" maxlength="2" align="right"
					onKeyPress="return acceptNum(event)"
						value="" style="display:none;"
						onblur="if (this.value == '') this.value='00'; else if (this.value > 23) this.value='23';"
				/><span id="MinutosRetardoHH2p" style="display:none;">:</span><input type="text" id="MinutosRetardoMM" name="MinutosRetardoMM"  
					size="2" maxlength="2" 
					onKeyPress="return acceptNum(event)"
						value="" style="display:none;"
						onblur="if (this.value == '') this.value='00'; else if (this.value > 59) this.value='59';"
				/>
			<cfelse>
				<input id="MinutosRetardo" name="MinutosRetardo"  
					size="10" maxlength="10" type="text" 
					label="Minutos Retardo"
					onKeyPress="return acceptNum(event)"
						value="" style="display:none;"
						onblur="if (this.value == '') this.value='0';"
				/>	
				<input type="text" id="MinutosRetardoHH" name="MinutosRetardoHH"  
					size="2" maxlength="2" align="right"
					onKeyPress="return acceptNum(event)"
						value="#int(LvarMinutosRetardo/60)#" 
						onblur="if (this.value == '') this.value='00'; else if (this.value > 23) this.value='23';"
				/><span id="MinutosRetardoHH2p">:</span><input type="text" id="MinutosRetardoMM" name="MinutosRetardoMM"  
					size="2" maxlength="2" 
					onKeyPress="return acceptNum(event)"
						value="#right("00" & (LvarMinutosRetardo mod 60),2)#" 
						onblur="if (this.value == '') this.value='00'; else if (this.value > 59) this.value='59';"
				/>
			</cfif>
			</span>
			<script language="javascript">
				function sbTipoRetardo(tipo)
				{
					if (tipo == "M")
					{
						document.getElementById("MinutosRetardo").style.display = "";
						document.getElementById("MinutosRetardoHH2p").style.display = "none";
						document.getElementById("MinutosRetardoHH").style.display = "none";
						document.getElementById("MinutosRetardoMM").style.display = "none";
					}
					else
					{
						document.getElementById("MinutosRetardo").style.display = "none";
						document.getElementById("MinutosRetardoHH2p").style.display = "";
						document.getElementById("MinutosRetardoHH").style.display = "";
						document.getElementById("MinutosRetardoMM").style.display = "";
					}
				}
			</script>
		</td>
	<cfelse>
		<td>
			<input type="hidden" id="MinutosRetardo" name="MinutosRetardo" value="">
		</td>
	</cfif>
	</tr>
	<tr>
		<td valign="middle" align="right" nowrap>
			<label for="Componente" style="cursor:pointer;" onclick="alert(this.title);" title="Componente Coldfusion que procesa los Datos de Entrada"><strong>Componente:&nbsp;</strong></label>
		</td>
	</tr>
	<tr>
		<td valign="middle" align="center" nowrap colspan="4">
			<input id="Componente" name="Componente" 
				size="80" maxlength="80" type="text" 
				label="Componente"
				value="#Componente#" />		
		</td>
	</tr>
	<cfif rsQuery.TipoProcesamiento EQ 'A'>
	<tr>
		<td valign="middle" align="right" nowrap>
			<label for="spFinal" style="cursor:pointer;" onclick="alert(this.title);" title=
"El Proceso Final se ejecuta inmediatamente después de terminar con éxito la ejecución del Componente Coldfusion que procesa una Interfaz Asíncrona.
Si el ProcesoFinal reporta algún tipo de Error, el proceso queda en la Cola de Procesos con el fin de corregir el error en el spFinal, pero su reprocesamiento únicamente ejecuta el spFinal, puesto que el proceso de la Interfaz ya terminó con Éxito
- No Ejecutar: pasa directamente a la Bitácora de Procesos
- Default: se ejecuta el proceso definido en Parámetros del Motor
- StoreProcedure: Store Procedure en la Base de Datos del Motor de Interfaces con los parámetros:
	exec spFinal (NumeroInterfaz, IDproceso)
- Coldfusion: se ejecuta el componente Coldfusion indicado, se tienen disponibles las siguientes variables:
	GvarID = ID proceso, GvarNI = Numero Interfaz, GvarCE = Codigo Cliente Empresarial,
	GvarSR = Secuencia Reproceso, GvarMD = ManejoDatos, 
	y para GvarMD='V': GvarXML_OE, GvarXML_OD, GvarXML_OS con los datos de salida
">
				<strong>Tipo Proceso Final:&nbsp;</strong>
			</label>
		</td>
		<td valign="middle" align="left">
			<select name="spFinalTipo" onchange="sbSpFinalTipo(this.value);">
				<option value="N">No ejecutar</option>
				<cfif rsMotor.spFinal NEQ "">
				<option value="D" <cfif rsQuery.spFinalTipo EQ "D">selected</cfif>>Ejecutar Proceso Final Default</option>
				</cfif>
				<option value="S" <cfif rsQuery.spFinalTipo EQ "S">selected</cfif>>Ejecutar Store Procedure Base Datos</option>
				<option value="C" <cfif rsQuery.spFinalTipo EQ "C">selected</cfif>>Ejecutar Componente Coldfusion</option>
			</select>
			<script language="javascript">
				function sbSpFinalTipo(tipo)
				{
					var obj = document.getElementById("spFinal") ;
					if (tipo == 'N')
					{
						obj.disabled = true;
					}
					else if (tipo == 'D')
					{
						obj.disabled = true;
						obj.value = "#rsMotor.spFinal#";
					}
					else if (tipo == 'S')
					{
						obj.disabled = false;
					}
					else if (tipo == 'C')
					{
						obj.disabled = false;
					}
				}
			</script>
		</td>
	</tr>
	<tr>
		<td valign="middle" align="center" nowrap colspan="4">
			<input id="spFinal" name="spFinal" 
				size="80" maxlength="80" type="text" 
				label="spFinal"
			<cfif rsQuery.spFinalTipo EQ "N">
				value=""
				disabled
			<cfelseif rsQuery.spFinalTipo EQ "D">
				value="#rsMotor.spFinal#"
				disabled
			<cfelse>
				value="#rsQuery.spFinal#"
			</cfif>
				 />		
		</td>
	</tr>
	<tr>
		<td valign="middle" align="right" nowrap>
			<label for="ProcesosPorRequest" style="cursor:pointer;" onclick="alert(this.title);" title=
"Numero máximo de procesos que se van a ejecutar en un mismo request.  Al llegar al numero máximo se abre un nuevo request y se sigue con los procesos de la cola (0=Todos los procesos de la cola en un mismo request)"
><strong>Procesos por Request:&nbsp;</strong></label>
		</td>
		<td valign="middle" align="left" nowrap>
			<input id="ProcesosPorRequest" name="ProcesosPorRequest"  
				size="3" maxlength="3" type="text"  align="right"
				value="#rsQuery.ProcesosPorRequest#" 
				label="Procesos por Request"
				onKeyPress="return acceptNum(event)"
					onblur="if (this.value == '') this.value='0';"
			/>	
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<label for="ProcesosPorRequest" style="cursor:pointer;" onclick="alert(this.title);" title=
"Numero de minutos que el motor va a esperar a que un proceso activo termine, si no lo aborta (debe ser un valor mayor a 5 minutos)"
><strong>Abortar proceso despues de N minutos Activo (Dormidos>5 min):&nbsp;</strong></label>
			<input id="MinutosAborto" name="MinutosAborto"  
				size="3" maxlength="3" type="text"  align="right"
				value="#rsQuery.MinutosAborto#" 
				label="Minutos para Abortar Dormidos"
				onKeyPress="return acceptNum(event)"
					onblur="if (this.value == '') this.value='0';"
			/>	
		</td>
	</tr>
	</cfif>
	<tr>
		<td valign="middle" align="right" nowrap>
			<label for="eMailErrores" style="cursor:pointer;" onclick="alert(this.title);" title=
"Persona responsable de la Interfaz, para que le lleguen los correos electrónicos cuando ocurre un Error cuando está encendido los Parámetros del Motor: Finalizacion de Proceso (y todos los errores de ejecucion)"
><strong>eMails para Errores:&nbsp;</strong></label>
		</td>
		<td valign="middle" align="left" nowrap>
			<textarea d="eMailErrores" name="eMailErrores"   rows="3" cols="60" 
				label="eMailErrores"
			 >#rsQuery.eMailErrores#</textarea>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
	<td valign="middle" align="center" nowrap colspan="4">
		<input id="doit" name="doit" 
			value="Actualizar" type="submit" />			
		<input id="cmdEstructura" name="cmdEstructura" 
			value="Estructura Tablas" type="submit" />			
		<input id="Limpiar" title="Limpiar" name="Limpiar" 
			value="Limpiar" type="reset" />
	</td>
	</tr>
	</table>
</cfoutput>
</form>
<script language="javascript" type="text/javascript">
	<!--//
		document.frmParams.Activa.focus();
	//-->
</script>