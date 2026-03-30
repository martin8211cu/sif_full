<style>
/* Center the loader */
#loader {
  position: absolute;
  left: 46%;
  top: 40%;
  z-index: 1;
  width: 50px;
  height: 50px;
  margin: -24px 0 0 -24px;
  border: 12px solid #f3f3f3;
  border-radius: 70%;
  border-top: 12px solid #3498db;
  width: 150px;
  height: 150px;
  -webkit-animation: spin 2s linear infinite;
  animation: spin 2s linear infinite;
}

@-webkit-keyframes spin {
  0% { -webkit-transform: rotate(0deg); }
  100% { -webkit-transform: rotate(360deg); }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Add animation to "page content" */
.animate-bottom {
  position: relative;
  -webkit-animation-name: animatebottom;
  -webkit-animation-duration: 1s;
  animation-name: animatebottom;
  animation-duration: 1s
}

@-webkit-keyframes animatebottom {
  from { bottom:-100px; opacity:0 }
  to { bottom:0px; opacity:1 }
}

@keyframes animatebottom {
  from{ bottom:-100px; opacity:0 }
  to{ bottom:0; opacity:1 }
}

#myDiv {
  display: none;
  text-align: center;
}
</style>

<cf_templateheader title="Dispara Procesos">
<cf_web_portlet_start titulo="Dispara Procesos">
<cfquery name="rsExt" datasource="sifinterfaces">
	select *
	from SIFLD_Procesos
	where Tipo_Proceso = 1
	AND Activa = 1
</cfquery>
<cfquery name="rsInt" datasource="sifinterfaces">
	select *
	from SIFLD_Procesos
	where Tipo_Proceso = 2
	AND Activa = 1
</cfquery>

<cfset aplicaFiltroSucursal = false>

<cfif isdefined("session.cenombre") AND FindNoCase("PROVEEDORES DE LA CONSTRUCCION",UCase(session.cenombre)) EQ 1>
	<cfset aplicaFiltroSucursal = true>
	<cfquery name="rsGetSucursalInfo" datasource="sifinterfaces">
		SELECT EQUcodigoOrigen, CONCAT(EQUcodigoOrigen, ' - ', EQUdescripcion) AS Sucursal
		FROM SIFLD_Equivalencia
		WHERE CATcodigo = 'SUCURSAL'
		  AND EQUcodigoOrigen NOT IN (13) <!--- Se discrimina la suc 13 porque ya no existe --->
		  AND SIScodigo = 'LD'
		ORDER BY EQUcodigoSIF
	</cfquery>
</cfif>

<cfif isdefined("form.ProcExt") and len(form.ProcExt) and form.ProcExt NEQ -1>

	<!--- Manda Ejecutar la Interfaz Elegida con los Rangos de Fecha deseados --->
	<cfinvoke component="ModuloIntegracion.Componentes.Extraccion.#form.ProcExt#" method="Ejecuta" />
</cfif>
<cfif isdefined("form.ProcInt") and len(form.ProcInt) and form.ProcInt NEQ -1>
	<!--- Manda Ejecutar la Interfaz Elegida con los Rangos de Fecha deseados --->
	<cfinvoke component="ModuloIntegracion.Componentes.#form.ProcInt#" method="Ejecuta">
    	<cfinvokeargument name="Disparo" value="true"/>
    </cfinvoke>
</cfif>

<cfoutput>
<form name="DispProc" id="DispProc" action="Dispara_Procesos_form.cfm" method="post">
	<div id="loader"></div>
	<div id="myForm" class="animate-bottom">
		<h3 align="center"> Procesos de Extraccion </h3>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr> <td colspan="3">&nbsp;  </td>
			</tr>
			<tr valign="top">
				<td align="right"><strong>Fecha desde:</strong></td>
				<td width="50%">
					<cfif isdefined('form.fechaIni') and LEN(TRIM(form.fechaIni))>
						<!--- <cf_sifcalendario name="fechaIni" value="#LSDateFormat(form.fechaIni,'dd/mm/yyyy')#"> --->
						<cf_sifcalendario form="DispProc" name="fechaIni" value="#form.fechaIni#" tabindex="1">
					<cfelse>
						<cfset LvarFecha = createdate(year(now()),month(now()),1)>
						<cf_sifcalendario form="DispProc" value="#DateFormat(LvarFecha, 'dd/mm/yyyy')#" name="fechaIni" tabindex="1">
					</cfif>
			  </td>
			</tr>
			<tr>
				<td align="right"><strong>Fecha hasta: </strong></td>
				<td>
					<cfif isdefined('form.fechaFin') and LEN(TRIM(form.fechaFin))>
						<!--- <cf_sifcalendario name="fechaFin" value="#LSDateFormat(form.fechaFin,'dd/mm/yyyy')#"> --->
						<cf_sifcalendario form="DispProc" name="fechaFin" value="#form.fechaFin#" tabindex="1">
					<cfelse>
						<cf_sifcalendario form="DispProc" value="#DateFormat(Now(),'dd/mm/yyyy')#" name="fechaFin" tabindex="1">
					</cfif>
				</td>
			</tr>
			<tr> <td colspan="3">&nbsp; </td>
			<tr>
				<td align="right">
					<strong> Proceso de Extracción: </strong>
				</td>
				<td colspan="2" align="left">
					<select name="ProcExt" id="ProcExt">
						<option value="-1">(Ninguna...)</option>
		                <cfloop query="rsExt">
	    	                <option value="#rsExt.Proceso#">#rsExt.Descripcion#</option>
		                </cfloop>
					</select>
				</td>
			</tr>
			<cfif isdefined("aplicaFiltroSucursal") and #aplicaFiltroSucursal# eq true>
				<tr> <td colspan="3">&nbsp; </td>
				<tr>
					<td align="right">
						<strong> Sucursal: </strong>
					</td>
					<td colspan="2" align="left">
						<select name="cbo_Sucursal_Ext" id="cbo_Sucursal_Ext">
							<option value="-1">-- Todas --</option>
			                <cfloop query="rsGetSucursalInfo">
		    	                <option value="#rsGetSucursalInfo.EQUcodigoOrigen#">#rsGetSucursalInfo.Sucursal#</option>
			                </cfloop>
						</select>
					</td>
				</tr>
			</cfif>
			<tr> <td colspan="3">&nbsp;  </td>
			<tr>
				<td colspan="3" align="center">
					<input type="button" onclick="ejecutaActionExt()" value="Ejecuta" name="btnExtrac"/>
				</td>
			</tr>
			<tr> <td colspan="3">&nbsp;  </td> </tr>
		</table>
		<hr width="80%" />
		<h3 align="center"> Interfaz SIF - LD </h3>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr> <td colspan="2">&nbsp;  </td> </tr>
			<tr>
				<td width="50%" align="right">
					<strong> Proceso de Interfaz: </strong>			</td>
				<td width="50%" align="left">
					<select name="ProcInt" id="ProcInt">
						<option value="-1">(Ninguna...)</option>
		                <cfloop query="rsInt">
	    	                <option value="#rsInt.Proceso#">#rsInt.Descripcion#</option>
		                </cfloop>
					</select>
			  </td>
			</tr>
			<tr> <td colspan="2">&nbsp;  </td> </tr>
			<tr>
				<td colspan="2" align="center">
					<input type="button" onclick="ejecutaActionProc()" value="Ejecuta" name="btnInter"/>
				</td>
			</tr>
			<tr> <td colspan="2">&nbsp;  </td> </tr>
		</table>
	</div>
</form>
</cfoutput>

<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript" type="text/javascript">
	document.getElementById("loader").style.display = "none";
	document.getElementById("myForm").style.display = "initial";

	function ejecutaActionProc(){
		var procProcesamiento = document.getElementById("ProcInt").value;
		if(procProcesamiento == -1){
			alert('Favor de seleccionar un Proceso de Interfaz!')
		} else {
			<!--- loader --->
			document.getElementById("loader").style.display = "initial";
			document.getElementById("myForm").style.display = "block";
			document.getElementById("DispProc").submit();
		}
	}

	function ejecutaActionExt(){
		var procExtraccion = document.getElementById("ProcExt").value;

		if(procExtraccion == -1){
			alert('Favor de seleccionar un Proceso de Extracción!')
		} else {
			<!--- loader --->
			document.getElementById("loader").style.display = "initial";
			document.getElementById("myForm").style.display = "block";
			document.getElementById("DispProc").submit();
		}
	}
</script>