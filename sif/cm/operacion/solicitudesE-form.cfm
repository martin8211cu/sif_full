<cfinclude template="../../Utiles/sifConcat.cfm">
<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!--- Consultas --->
<cfquery name="rsTipoRequisicion" datasource="#session.DSN#">
	select TRcodigo,TRdescripcion
	from TRequisicion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfset LvarEmptyListMsg = "Debe asignar Tipos de Solicitudes de Compra al Centro Funcional">
<cfset LvarSoloArticulo = "">
<cfif url.SC_INV NEQ -1>
	<cfset LvarSoloArticulo = "and (CMTStarticulo = 1 AND CMTSaInventario = 1 AND CMTSconRequisicion = 0 AND CMTSservicio = 0 AND CMTSactivofijo = 0)">
	<cfset LvarEmptyListMsg = "Debe asignar al Centro Funcional un Tipos de Solicitudes de Compra que solo sea para Articulos con Entrada a Almacen">
</cfif>
<cfif modo neq 'ALTA'>
	<cfquery datasource="#session.DSN#" name="rsForm">
		select a.ESidsolicitud,a.ESnumero, a.CFid, b.CFcodigo, b.CFdescripcion, a.CMTScodigo, a.CMSid, a.Mcodigo, a.EStipocambio,
		       a.ESfecha, a.ESobservacion, coalesce(SNcodigo, -1) as SNcodigo, CMElinea, EStotalest, a.ts_rversion, a.TRcodigo, ESlugarentrega
		from ESolicitudCompraCM a
		 inner join CFuncional b
		    on a.Ecodigo = b.Ecodigo
  		   and a.CFid    = b.CFid
		where a.ESidsolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
	</cfquery>

	<cfquery name="dataTS"	 datasource="#session.DSN#">
		select CMTScodigo, CMTSdescripcion, CMTScompradirecta, CMTStarticulo, CMTSaInventario, CMTSconRequisicion,CMTSempleado
		from CMTiposSolicitud b
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CMTScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.CMTScodigo#">
		<cfif url.SC_INV NEQ -1>
			#LvarSoloArticulo#
		</cfif>
	</cfquery>


	<cfquery name="rsMoneda" datasource="#session.DSN#">
		select Mcodigo, Mnombre
		from Monedas
		where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Mcodigo#">
		and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfquery name="rsLineas" datasource="#Session.DSN#">
		select count(1) as total
		from DSolicitudCompraCM
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and ESidsolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
	</cfquery>

	<cfset consecutivo = rsForm.ESnumero>

<cfelse>

	<cfquery name="rs" datasource="#session.DSN#">
		select max(ESnumero) as ESnumero
		from ESolicitudCompraCM
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfset consecutivo = 1>
	<cfif rs.RecordCount gt 0 and len(trim(rs.ESnumero))>
		<cfset consecutivo = rs.ESnumero + 1>
	</cfif>

</cfif>


<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisCFuncional() {
		var params ="";
		params = "?CMSid=<cfoutput>#solicitante#</cfoutput>&form=form1&id=CFid&name=CFcodigo&desc=CFdescripcion";
		popUpWindow("/cfmx/sif/cm/operacion/ConlisCFuncional.cfm"+params,250,200,650,400);
	}

	//Obtiene la descripción con base al código
	function TraeCFuncional(dato) {
		var params ="";
		params = "&CMSid=<cfoutput>#solicitante#</cfoutput>&id=CFid&name=CFcodigo&desc=CFdescripcion";
		if (dato.value != "") {
			document.getElementById("fr").src="/cfmx/sif/cm/operacion/cfuncionalquery.cfm?dato="+dato.value+"&form=form1"+params;
		}
		else{
			document.form1.CFid.value = "";
			document.form1.CFcodigo.value = "";
			document.form1.CFdescripcion.value = "";
		}
		return;
	}

	function CambiaFecha()
	{
		var currentTime = new Date();
        var month = currentTime.getMonth() + 1
		if(month < 10)
		{
			 month = "0"+month;
		}

        var day = currentTime.getDate()
        var year = currentTime.getFullYear()

		var Now = (day + "/" + month + "/" + year);
		var Fecha = document.form1.ESfecha.value;

      if (mayor(Now, Fecha))
	      {
              document.form1.ESfecha.value= Now;
			  alert("La fecha de la solicitud no puede ser menor al día de hoy");
		  }
	  else{

	      }

	}
function mayor(fecha, fecha2)
{
		var xMes=fecha.substring(3, 5);
		var xDia=fecha.substring(0, 2);
		var xAnio=fecha.substring(6,10);
		var yMes=fecha2.substring(3, 5);
		var yDia=fecha2.substring(0, 2);
		var yAnio=fecha2.substring(6,10);
		if (xAnio > yAnio)
		 {
			return(true);
		 }
	 else{
		    if (xAnio == yAnio)
			  {
					  if (xMes > yMes)
						{
						   return(true);
						}
						if (xMes == yMes)
						{
						     if (xDia > yDia)
							 {
							   return(true);
							 }
							 else
							 {
							  return(false);
							 }
						}
						else
						{
						 return(false);
						}
			  }
			  else
			  {
				return(false);
			  }
       }
}

	function traeEspecializacion(){
		cfpk = document.form1.CFid.value;
		cmtscodigo = document.form1.CMTScodigo.value;
		document.getElementById("fr").src="/cfmx/sif/cm/operacion/especializacion-query.cfm?CFid="+cfpk+"&CMTScodigo="+ cmtscodigo +"&form=form1";
	}

	function asignaTC() {
		if (document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {
			formatCurrency(document.form1.TC,4);
			document.form1.EStipocambio.disabled = true;
		}
		else{
			document.form1.EStipocambio.disabled = false;
		}
		var estado = document.form1.EStipocambio.disabled;
		document.form1.EStipocambio.disabled = false;
		document.form1.EStipocambio.value = fm(document.form1.TC.value,4);
		document.form1.EStipocambio.disabled = estado;
	}

	function activaSocio(valor){
		if (valor){
			document.getElementById("SNnumero").disabled = false;
			document.getElementById("SNimagen").disabled = false;
			document.getElementById("SNimagen").style.visibility = 'visible';
		}
		else{
			document.getElementById("SNnumero").value = '';
			document.getElementById("SNnombre").value = '';
			document.getElementById("SNnumero").disabled = true;
			document.getElementById("SNimagen").disabled = true;
			document.getElementById("SNimagen").style.visibility = 'hidden';
		}
	}

	function socio(){
		var compradirecta = document.form1.CMTScompradirecta.value;
		if (compradirecta=='1'){ activaSocio(true); } else{ activaSocio(false); };
	}

	function AsignaValoresTS() {
		socio();
		traeEspecializacion();
		traeRequisicion();
	}

	function traeRequisicion(){
		var LvarTRcodigo 			= document.getElementById("TRcodigo");
		var LvarCMTStarticulo 		= document.form1.CMTStarticulo.value;
		var LvarCMTSconRequisicion 	= document.form1.CMTSconRequisicion.value;
		var LvarCMTSaInventario 	= document.form1.CMTSaInventario.value;
		while (LvarTRcodigo.options.length > 0)
		{
			  LvarTRcodigo.remove(0);
		}

		if (LvarCMTStarticulo != "1")
		{
			var LvarOpt =	document.createElement('option');
			LvarOpt.value	= "";
			LvarOpt.text	= "N/A";
			try
			{
				LvarTRcodigo.add(LvarOpt);
			}
			catch (e)
			{
				LvarTRcodigo.add(LvarOpt, null);
			}
		}
		else
		{
			if (LvarCMTSaInventario == "1")
			{
				var LvarOpt =	document.createElement('option');
				LvarOpt.value	= "";
				LvarOpt.text	= "-- Sin Requisicion --";
				try
				{
					LvarTRcodigo.add(LvarOpt);
				}
				catch (e)
				{
					LvarTRcodigo.add(LvarOpt, null);
				}
			}
			if (LvarCMTSconRequisicion == "1" || LvarCMTSconRequisicion == "2")
			{
				<cfloop query="rsTipoRequisicion">
					<cfoutput>
					{
						var LvarOpt =	document.createElement('option');
						LvarOpt.value	= "#rsTipoRequisicion.TRcodigo#";
						LvarOpt.text	= "#rsTipoRequisicion.TRdescripcion#";
						try
						{
							LvarTRcodigo.add(LvarOpt);
						}
						catch (e)
						{
							LvarTRcodigo.add(LvarOpt, null);
						}
					}
					</cfoutput>
				</cfloop>
			}
		}
		return;
	}

	function FuncReemplzarCadenaE(){
		var mainString = document.form1.ESobservacion.value;
		var replaceStr = " ";
		var delim = "/gi";
		var regexp = eval("/" + '"' + delim);
		document.form1.ESobservacion.value = mainString.replace(regexp,replaceStr);
	}
</script>
<cfoutput>

<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" >
	<tr>
		<td>
			<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" >
				<tr>
					<td align="right" width="40%"><strong>No. Solicitud:&nbsp;</strong><td><cfif modo neq 'ALTA'>#rsForm.ESnumero#<cfelse>#consecutivo#</cfif></td>
					<td align="right" width="8%"><strong>Descripci&oacute;n:</strong>&nbsp;</td>
					<td>
						<input name="ESobservacion" size="57" maxlength="255" onkeyup="FuncReemplzarCadenaE();" value="<cfif modo NEQ 'ALTA'>#HTMLEditFormat(rsForm.ESobservacion)#</cfif>" onfocus="javascript: this.select();" tabindex="1" >
					</td>
					<td align="right" nowrap width="1%"><strong>Fecha:</strong>&nbsp;</td>
					<td nowrap width="100%">
						<cfset fecha = LSDateFormat(Now(),'dd/mm/yyyy') >
						<cfif modo neq 'ALTA'>
							<cfset fecha = LSDateFormat(rsForm.ESfecha,'dd/mm/yyyy') >
						</cfif>
						<cf_sifcalendario value="#fecha#" tabindex="1" name="ESfecha" Function="CambiaFecha();">

					</td>
				</tr>
				<tr>
					<td align="right" nowrap><strong>Centro Funcional:</strong>&nbsp;</td>
				  <td >
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<cfif modo neq 'ALTA'>
									<cfquery name="dataCF" datasource="#session.DSN#">
										select CFcodigo, CFdescripcion
										from CFuncional
										where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFid#">
									</cfquery>
									<td>#dataCF.CFcodigo# - #dataCF.CFdescripcion#</td>
									<input type="hidden" name="CFid" value="#rsForm.CFid#">
								<cfelse>
									<td width="1%">
										<input tabindex="1" type="text" name="CFcodigo" id="CFcodigo" value="<cfif modo neq 'ALTA'>#rsForm.CFcodigo#</cfif>" onblur="javascript: TraeCFuncional(this); " size="10" maxlength="10" onfocus="javascript:this.select();">
										<input type="hidden" name="CFid" value="<cfif modo neq 'ALTA'>#rsForm.CFid#</cfif>" alt="Centro Funcional">									</td>
									<td width="1%" nowrap="nowrap">
										<input type="text" name="CFdescripcion" id="CFdescripcion" disabled value="<cfif modo neq 'ALTA'>#rsForm.CFdescripcion#</cfif>"
											size="30" maxlength="80" tabindex="1"><a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Centros Funcionales" name="CFimagen" width="18" height="14" border="0" align="absmiddle" onclick='javascript: doConlisCFuncional();' /></a>
                                    </td>
								</cfif>
							</tr>
						</table>
					</td>
					<td align="right" nowrap ><strong><cf_translate key="tipoSolicitud">Tipo:&nbsp;</cf_translate></strong></td>
					<td>
						<cfif isdefined("rsLineas") and rsLineas.total gte 0 >
							#dataTS.CMTScodigo# - #dataTS.CMTSdescripcion#
							<input type="hidden" name="CMTScodigo" value="#dataTS.CMTScodigo#">
							<input type="hidden" name="CMTScompradirecta" value="#dataTS.CMTScompradirecta#">
						<cfelse>
							<cf_conlis
								Campos="CMTScodigo, CMTSdescripcion, CMTScompradirecta, CMTStarticulo, CMTSaInventario, CMTSconRequisicion"
								Desplegables="S,S,N,N,N,N"
								Modificables="S,N,N,N,N,N"
								Size="10,43,10"
								tabindex="1"

								Title="Lista de Tipos"
								Tabla="CMTSolicitudCF a
											inner join CMTiposSolicitud b
											on a.Ecodigo=b.Ecodigo
											and a.CMTScodigo=b.CMTScodigo"
								Columnas="a.CFid, b.CMTScodigo, b.CMTSdescripcion, b.CMTScompradirecta, b.CMTStarticulo, b.CMTSaInventario, b.CMTSconRequisicion"
								Filtro=" a.Ecodigo 		= #session.Ecodigo#
									  	  and a.CFid    = $CFid,numeric$
										  #LvarSoloArticulo#"
								Desplegar="CMTScodigo, CMTSdescripcion"
								Etiquetas="Codigo, Descripci&oacute;n"
								filtrar_por="b.CMTScodigo, b.CMTSdescripcion"
								Formatos="S,S"
								Align="left,left"
								form="form1"
								Asignar="CMTScodigo, CMTSdescripcion, CMTScompradirecta, CMTStarticulo, CMTSaInventario, CMTSconRequisicion"
								Asignarformatos="S,S,S,S,S,S"
								Funcion="AsignaValoresTS"
								showEmptyListMsg="true"
								EmptyListMsg="#LvarEmptyListMsg#"
								/>
						</cfif>
					</td>
					<td align="right" nowrap ><strong>Especializaci&oacute;n:&nbsp;</strong></td>
					<td nowrap>

						<cfif isdefined("rsLineas") and rsLineas.total gte 0>
							<cfquery name="dataEspec" datasource="#session.DSN#">
								select
									a.CMEtipo #_Cat#'-'#_Cat#
									case
										when a.CMEtipo = 'A'
											then ((
												select min(Cdescripcion)
												from Clasificaciones b
												where b.Ccodigo = a.Ccodigo
												  and b.Ecodigo = a.Ecodigo
												))
										when a.CMEtipo = 'S'
											then ((
												select min(CCdescripcion)
												from CConceptos c
												where c.CCid = a.CCid
												))
										when CMEtipo = 'F'
											then ((
												select min(ACdescripcion)
												from AClasificacion d
												where d.ACid = a.ACid
												and d.ACcodigo = a.ACcodigo
												and d.Ecodigo = a.Ecodigo
												))
										else
											'NINGUNA'
										end as descripcion

								from CMEspecializacionTSCF a
								where a.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFid#">
								  and a.CMTScodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.CMTScodigo#">
								  and a.CMElinea=<cfif len(trim(rsForm.CMElinea))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CMElinea#"><cfelse>0</cfif>
								  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								order by CMEtipo
							</cfquery>
							<cfif dataEspec.RecordCount gt 0>
								#dataEspec.descripcion#
							<cfelse>
								Ninguna
							</cfif>
							<input type="hidden" name="CMElinea" value="#trim(rsForm.CMElinea)#">

						<cfelse>
							<select tabindex="1" name="CMElinea">
								<option value="">Ninguna</option>
							</select>
						</cfif>
					</td>
				</tr>

				<tr>
					<td align="right" nowrap><strong>Proveedor:</strong>&nbsp;</td>
					<td>
						<cfif modo NEQ "ALTA">
							<cf_sifsociosnegocios2 tabindex="1" SNtiposocio="P" size="30" idquery="#rsForm.SNcodigo#">
						<cfelse>
							<cf_sifsociosnegocios2 tabindex="1" SNtiposocio="P" size="30">
						</cfif>
					</td>

					<td align="right" nowrap><strong>Moneda:</strong>&nbsp;</td>
					<td>
						<cfif modo NEQ "ALTA">
							 <cf_sifmonedas tabindex="1" query="#rsMoneda#" valueTC="#rsForm.EStipocambio#" onChange="asignaTC();" FechaSugTC="#LSDateFormat(rsForm.ESfecha,'DD/MM/YYYY')#">
						 <cfelse>
							 <cf_sifmonedas onChange="asignaTC();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1">
						</cfif>
					</td>
					<td align="right" nowrap><strong>Tipo de Cambio:</strong>&nbsp;</td>
					<td>
						<input tabindex="1" type="text" name="EStipocambio" style="text-align:right"size="18" maxlength="10"
									onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
									onFocus="javascript:this.select();"
									onChange="javascript: fm(this,4);"
									value="<cfif modo NEQ 'CAMBIO'>1.0000<cfelse><cfoutput>#LSNumberFormat(rsForm.EStipocambio,',9.0000')#</cfoutput></cfif>">
					</td>
				</tr>
                <cfif MODO EQ "CAMBIO" and dataTS.CMTScompradirecta eq 1>
                    <tr>
                        <cf_cboFormaPago TESOPFPtipoId="1" TESOPFPid="#rsForm.ESidsolicitud#">
                    </tr>
				</cfif>


			<cf_navegacion name="SC_INV" default="-1">
				<tr>
					<td align="right" nowrap><strong><cf_translate key="tipoRequisicion">Tipo de requisición</cf_translate></strong></td>
					<td>
						<select name="TRcodigo" id="TRcodigo" onchange="MuestraBotones();">
						<cfif modo eq 'ALTA'>
							<option value="">N/A</option>
						<cfelseif dataTS.CMTStarticulo EQ 0>
							<option value="">N/A</option>
						<cfelse>
							<cfif dataTS.CMTSaInventario EQ 1>
								<option value="">-- Sin Requisicion --</option>
							</cfif>
							<cfif dataTS.CMTSconRequisicion NEQ 0>
								<cfloop query="rsTipoRequisicion">
									<option value="#rsTipoRequisicion.TRcodigo#" <cfif modo neq 'ALTA'  and trim(rsTipoRequisicion.TRcodigo) eq trim(rsForm.TRcodigo)>selected</cfif> >#rsTipoRequisicion.TRdescripcion#</option>
								</cfloop>
							</cfif>
						</cfif>
						</select>
					</td>
                    <td><strong>Lugar de Entrega:</strong>&nbsp;
                    </td>
                    <td>
                     <input name="ESlugarentrega" size="57" maxlength="255" value="<cfif modo neq 'ALTA' and len(trim(#rsForm.ESlugarentrega#))>#rsForm.ESlugarentrega# </cfif>"/>
                    </td>
				</tr>

                <cfif modo neq 'ALTA'>
               		<cfif dataTS.CMTSempleado eq 1>
                        <tr>
                            <td width="42%" align="right"><strong>Empleado:</strong></td>
                            <td>
                                <cf_dbfunction name="concat" args="DEapellido1 ,' ',DEapellido2 ,' ',DEnombre" returnvariable="DEnombrecompleto">
                                <cfset ValuesArray=ArrayNew(1)>
                                <cf_conlis
                                    Campos="DEid,DEidentificacion,DEnombrecompleto"
                                    Desplegables="N,S,S"
                                    Modificables="N,S,N"
                                    Size="0,10,40"
                                    Tabindex="1"
                                    ValuesArray="#ValuesArray#"
                                    Title="Lista de Empleados"
                                    Tabla="DatosEmpleado"
                                    Columnas="DEid,DEidentificacion,#DEnombrecompleto# as DEnombrecompleto"
                                    Filtro="Ecodigo = #Session.Ecodigo# order by DEidentificacion,DEnombrecompleto"
                                    Desplegar="DEidentificacion,DEnombrecompleto"
                                    Etiquetas="Identificaci&oacute;n,Nombre"
                                    filtrar_por="DEidentificacion,#DEnombrecompleto#"
                                    Formatos="S,S"
                                    Align="left,left"
                                    Asignar="DEid,DEidentificacion,DEnombrecompleto"
                                    Asignarformatos="I,S,S"
                                    MaxRowsQuery="200"/>
                            </td>
                        </tr>
                      </cfif>
                    </cfif>

				<cfset ts = "">
				<cfif modo neq "ALTA">
					<cfinvoke
						component="sif.Componentes.DButils"
						method="toTimeStamp"
						returnvariable="ts">
						<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
					</cfinvoke>
				</cfif>

				<!--- CAMPOS OCULTOS--->
				<tr><td>
					<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>">
					<input type="hidden" name="CMSid" value="#solicitante#">
					<!--- <input type="hidden" name="CMTScompradirecta" value="<cfif modo neq 'ALTA'>#dataTS.CMTScompradirecta#<cfelse>0</cfif>"> --->
					<input type="hidden" name="_CMElinea" value="<cfif modo neq 'ALTA'>#trim(rsForm.CMElinea)#</cfif>">
					<cfif modo neq 'ALTA'>
						<input type="hidden" name="ESnumero" value="#rsform.ESnumero#">
						<input type="hidden" name="ESidsolicitud" value="#form.ESidsolicitud#">
					</cfif>
				</td></tr>
			</table>
		</td>
	</tr>
</table>
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
</cfoutput>

<script language="javascript1.2" type="text/javascript">
	<cfif modo eq 'ALTA'>
		activaSocio(false);
	</cfif>
		/*traeEspecializacion();
		socio();*/

	asignaTC();
	<cfif modo neq 'ALTA'>
		//tipos(document.form1.CFid.value);
		<cfif isdefined("rsLineas") and rsLineas.total lt 0>traeEspecializacion();</cfif>
		<!--- Inhabilitar el cambio de moneda en modo Cambio --->
		<cfif isdefined("rsLineas") and rsLineas.total GT 0>
		document.form1.Mcodigo.disabled = true;
		</cfif>
		socio();
	</cfif>
</script>

