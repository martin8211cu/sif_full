<cfparam name="modo" default="ALTA">
<cfif isdefined('form.TESAPid')>
	<cfset modo = 'CAMBIO'>
    <cfinvoke component="sif.tesoreria.Componentes.TESAcuerdoPago" method="GetAcuerdoPago" returnvariable="rs">
		<cfinvokeargument name="TESAPid" value="#form.TESAPid#">
	</cfinvoke>
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rs.ts_rversion#" returnvariable="ts"/>
<cfelse>
	<cfinvoke component="sif.tesoreria.Componentes.TESAcuerdoPago" method="fnGetAutorizadores" returnvariable="Autorizador"></cfinvoke>
	<cfset rs.TESAPautorizador1 = Autorizador.TESAPautorizador1>
	<cfset rs.TESAPautorizador2 = Autorizador.TESAPautorizador2> 
</cfif>


	<cfquery name="rsOficinas" datasource="#session.dsn#">
		select 
			Ocodigo,
			Oficodigo,
			Odescripcion 
		from  Oficinas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		order by Oficodigo
	</cfquery>

<cfoutput>
        <table border="0" cellpadding="1" cellspacing="1" width="90%">
             <form name="formAcuerdoPago" action="AcuerdoPago-sql.cfm" method="post">
				<cfif modo EQ 'CAMBIO'>
                    <input type="hidden" name="TESAPid" 	value="#form.TESAPid#"/>
                    <input type="hidden" name="ts_rversion" value="#ts#">
                </cfif>
                <tr>
                    <td>
                        Numero de Acuerdo:
                    </td>
                    <td>
                        <input name="TESAPnumero" tabindex="1" id="TESAPnumero" type="text" value="#rs.TESAPnumero#" <cfif SoloLectura>readonly="yes"</cfif>/>
                    </td>
                    <td>
                        Fecha de Acuerdo:
                    </td>
                    <td>
                        <cf_sifcalendario tabindex="2" form="formAcuerdoPago" name="TASAPfecha" value="#LSDateFormat(rs.TASAPfecha,'DD/MM/YYYY')#"  readonly="#SoloLectura#">				  
                    </td>
                </tr>
                <tr>
                    <td>
                        Primer Autorizador:
                    </td>
                    <td>
                        <input name="TESAPautorizador1" tabindex="3" id="TESAPautorizador1" type="text" value="#rs.TESAPautorizador1#" <cfif SoloLectura>readonly="yes"</cfif>/>
                    </td>   
                    <td>
                        Segundo Autorizador:
                    </td>
                    <td>
                        <input name="TESAPautorizador2" tabindex="4" id="TESAPautorizador2" type="text" value="#rs.TESAPautorizador2#" <cfif SoloLectura>readonly="yes"</cfif>/>
                    </td>
                </tr>
				</cfoutput>	
					 <tr>
						<td>Oficina:</td>
						<td>
						 <select name="Ocodigo" id="Ocodigo">
						 		<option value="" >---Seleccionar---</option>
								<cfif rsOficinas.RecordCount>
									<cfoutput query="rsOficinas">
										<option value="#rsOficinas.Ocodigo#" <cfif modo neq "ALTA" and rsOficinas.Ocodigo  eq rs.Ocodigo> selected="selected" </cfif>>#rsOficinas.Oficodigo#-#rsOficinas.Odescripcion#</option>									
									</cfoutput>
								</cfif>                       
						</select>					                             
						</td>
					 </tr>
					 <cfoutput>	
                <tr>
                    <td colspan="4">
						<cfif Tipo neq 0>
                      <cf_botones modo="Alta" exclude="ALTA,LIMPIAR" include="#BotonesI#" includevalues="#BotonesLabel#">
						<cfelse>
							 <cf_botones modo="#modo#" include="#BotonesI#" includevalues="#BotonesLabel#">
						</cfif>
						<input type="hidden" name="IrA" id="IrA" value="#IrA#" />
                    </td>
                </tr>
            </form>
             <cfif modo EQ 'CAMBIO'>
             	<form name="form1" action="AcuerdoPago-sql.cfm" method="post">
            		<input type="hidden" name="TESAPid" 	value="#form.TESAPid#"/>
					<input type="hidden" name="TESSPidEliminar" 	value=""/>
           			<input type="hidden" name="IrA" id="IrA" value="#IrA#" />
                <tr><td colspan="4" align="center">&nbsp;</td></tr>
                <tr>
                    <td colspan="4" align="center">
                        <strong>Listado de Solicitudes de Pago</strong>
                    </td>
                </tr>
				<cfif Tipo eq 0>
                <tr> 
                    <td colspan="1" align="right">
						<strong>SP.Num.&nbsp;</strong>
					</td>
                    <td colspan="1" align="left">
						  <cf_dbfunction name="OP_concat" returnvariable="_Cat">
                        <cfset Column = "TESSPid,TESSPnumero,coalesce(sn.SNnombrePago, sn.SNnombre, tb.TESBeneficiario, cd.CDCnombre) as Nombre,Miso4217,TESSPtotalPagarOri,TESSPfechaPagar, 
								(c.Pnombre #_Cat# ' ' #_Cat# c.Papellido1 #_Cat# ' ' #_Cat# c.Papellido2) as UsucodigoSolicitud"> 
                         <cf_conlis
                            campos="TESSPid,TESSPnumero,TESSPfechaPagar,Nombre,Miso4217,TESSPtotalPagarOri,UsucodigoSolicitud"
                            desplegables="N,S,S,N,N,N,N"
                            modificables="N,S,N,N,N,N,N"
                            size="0,15,10,3,10,18,0"
                            title="Lista de Solicitudes de Pago"
                            tabla="TESsolicitudPago sol
												inner join Monedas m						on m.Mcodigo = sol.McodigoOri
												inner join Usuario b 						on b.Usucodigo = sol.UsucodigoSolicitud
												inner join DatosPersonales c 				on c.datos_personales = b.datos_personales			
												left outer join SNegocios sn				on sn.SNcodigo = sol.SNcodigoOri and sn.Ecodigo = sol.EcodigoOri
												left outer join TESbeneficiario tb 			on tb.TESBid = sol.TESBid
												left outer join ClientesDetallistasCorp cd 	on cd.CDCcodigo= sol.CDCcodigo
													"
                            columnas="#Column#"
                            filtro="(EcodigoOri = #session.Ecodigo# AND TESAPid is null AND (TESSPestado in (2, 212) OR (TESSPestado=11 AND TESSPtipoDocumento = 10)))"
                            desplegar="TESSPnumero,Nombre,Miso4217,TESSPtotalPagarOri,TESSPfechaPagar,UsucodigoSolicitud"
                            filtrar_por="TESSPnumero;coalesce(sn.SNnombrePago, sn.SNnombre, tb.TESBeneficiario, cd.CDCnombre);Miso4217;TESSPtotalPagarOri;TESSPfechaPagar;(c.Pnombre #_Cat# ' ' #_Cat# c.Papellido1 #_Cat# ' ' #_Cat# c.Papellido2)"
									 filtrar_por_delimiters = ";"
									 width = "850"
									 height = "550"
									 etiquetas="TESSPnumero,Beneficiario,Moneda,Monto,Fecha,Solicitante"
                            formatos="I,V,V,M,D,V"
                            align="left,left,left,right,left,left"
                            asignar="TESSPid,TESSPnumero,TESSPfechaPagar,Nombre,Miso4217,TESSPtotalPagarOri,UsucodigoSolicitud"
                            asignarformatos="S,S,S,S,S,S,S"
                            showEmptyListMsg="true"
                            EmptyListMsg="-- No se encontraron Países --"
                            tabindex="1"
                            form="form1"
                            conexion = "#session.dsn#">	
                    </td>
                 <td colspan="2">
                    <input type="submit" class="BtnGuardar" name="btnALTAD" value="Agregar Solicitud de Pago" onclick="return fnbtnALTAD();" />
                 </td>
               </tr>
			   </cfif>
                <tr>
                    <td colspan="4">
                        <cf_dbfunction name="OP_concat"	returnvariable="_Cat">
                        <cf_dbfunction name="to_char"	args="TESSPid" returnvariable="TESSPid">
                        <cfif Tipo eq 0>
							<cfset borrar 	 = "<input name=''TESSPidBorrar'' value='''#_Cat# #TESSPid# #_Cat#''' type=''image'' src=''../../imagenes/Borrar01_S.gif'' width=''16'' height=''16'' border=''0'' onclick=''javascript:return changeFormActionforDetalles('#_Cat# #TESSPid# #_Cat#');''>">
                      	<cfelse>
							<cfset borrar 	 = "">
						</cfif>
					    <cfset table     = ' TESsolicitudPago sp inner join Monedas m on m.Mcodigo = sp.McodigoOri' >
                        <cfset Column = "sp.TESSPid, sp.TESSPnumero,sp.TESSPfechaPagar,m.Mnombre,sp.TESSPtotalPagarOri, case 
                            when sp.SNcodigoOri is not null then
                             ( select coalesce(sn.SNnombrePago, sn.SNnombre)  
                                from SNegocios sn where sn.Ecodigo = sp.EcodigoOri and sn.SNcodigo = sp.SNcodigoOri)
                                when sp.TESBid is not null then
                            ( select tb.TESBeneficiario 
                                from TESbeneficiario tb where tb.TESBid = sp.TESBid)
                             else
                            ( select cd.CDCnombre 
                                 from ClientesDetallistasCorp cd where cd.CDCcodigo=sp.CDCcodigo)
                            End  Nombre, '#borrar#' as Borrar " > 
                            <cfinvoke component="sif.Componentes.pListas"
                                method			="pLista"
                                returnvariable	="Lvar_ListaD"
                                tabla			="#table#"
                                columnas		="#Column#"
                                desplegar		="TESSPnumero, TESSPfechaPagar,Mnombre,TESSPtotalPagarOri, Nombre, Borrar"
                                etiquetas		="Documento, Fecha, Moneda, Monto Solicitado, Solicitante,"
                                formatos		="S,D,S,M,S,US"
                                filtro			="TESAPid = #form.TESAPid#"
                                incluyeform		="false"
                                align			="left,left,left,left,left,left"
                                keys			="TESSPid"
                                maxrows			="25"
                                showlink		="false"
                                filtrar_automatico="false"
                                mostrar_filtro	="false"
                                formname		="form1"
                                ira				="AcuerdoPago-sql.cfm"
                                showemptylistmsg="true"
                                ajustar			="N"
                                debug			="N"
                                PageIndex		= "2"/>		
                        </form>				
                    </td>
                </tr>
            </cfif>
        </table>
    
</cfoutput>
<cf_qforms form="formAcuerdoPago">
	<cf_qformsRequiredField name="TESAPnumero" 	 		description="Numero de Acuerdo">
	<cf_qformsRequiredField name="TASAPfecha"    		description="Fecha de Acuerdo">
    <cf_qformsRequiredField name="TESAPautorizador1"    description="Primer Autorizador">
    <cf_qformsRequiredField name="TESAPautorizador2"    description="Segundo Autorizador">
    <cf_qformsRequiredField name="Ocodigo"    description="Oficina">
</cf_qforms>
<script language="javascript">
	function funcRegresar()
	{
			objForm.TESAPnumero.required=false;
			objForm.TASAPfecha.required=false;
			objForm.TESAPautorizador1.required=false;
			objForm.TESAPautorizador2.required=false;
	}
	// Cambia el Action del Form
	function changeFormActionforDetalles(TESSPid) {
		if (confirm('¿Desea Eliminar el Registro?')){
		deshabilitarValidacion();
		document.form1.TESSPidEliminar.value = TESSPid;
		document.form1.action = "AcuerdoPago-sql.cfm?BAJAD=true";
		return true;
		}
		return false;
	}
	function fnbtnALTAD()
	{	
		if(document.form1.TESSPid.value == '')
		{
			alert('La Solicutud de Pago es Requerida');
			return false;
		}
		else
		{
		return true;
		}
		
			
	}
	function funcEnviarA(){
		if (confirm('¿Desea Enviar a Aprobar el Registro?'))
			return true;
		return false;
	}
	function funcAprobar(){
		if (confirm('¿Desea Aprobar el Registro?'))
			return true;
		return false;
	}
	function funcRechazar(){
		if (confirm('¿Desea Rechazar el Registro?'))
			return true;
		return false;
	}
	function funcAnular(){
		if (confirm('¿Desea Anular el Registro?'))
			return true;
		return false;
	}
</script>
