<cf_templateheader title="Compras - Objetos del Contrato">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Documentos de la Línea de Solictud'>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td>
				</tr>							
		    </table>					
				<cfif isdefined("url.NotaId")  and not(isdefined("form.NotaId"))>
					<cfset form.NotaId = url.NotaId>					
				<cfelse>				  
				</cfif>	
				<cfquery name="rsEmpresas" datasource="#session.DSN#">
					select e.Ecodigo, e.Edescripcion
					from Empresas e 
					where e.Ecodigo = #session.ecodigo#
	    		</cfquery>			
  				<cfquery name="rsMail" datasource="#session.DSN#">
					select 
					  n.CMNid,
					  n.CMPid,
					  n.CMNtipo,
					  n.CMNnota,
					  n.CMNresp,
					  n.CMNtel,
					  n.CMNemail,
					  n.Usucodigo,
					  n.fechaalta,
					  n.CMTPAid,
					  n.CMNfechaIni,
					  n.CMNdiasDuracion,
					  n.CMNfechaFin,
					  n.CMNestado, 
					  tp.CMTPDescripcion,
					  pc.CMPdescripcion					
					from CMNotas n 
					 inner join CMProcesoCompra pc
					    on n.CMPid = pc. CMPid
					 inner join CMTipoProceso tp
					    on pc.CMTPid = tp.CMTPid	
					where n.CMNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NotaId#">
				</cfquery>
				<!---<cfdump var="#rsMail#">--->

               <cfset texto=
               '<table border="0" width="100%">
			     		<tr>
							<td>
		                        <strong>Sr(a) <cfoutput>#rsMail.CMNresp#</cfoutput>,</strong><br><br>
							</td>
						</tr>
						<tr>
							<td>
								&nbsp;&nbsp;&nbsp;Le informamos que la actividad <strong><cfoutput>#rsMail.CMNtipo#</cfoutput></strong> del proceso de compra <strong><cfoutput>#rsMail.CMPdescripcion#</cfoutput></strong>.<br> Inicia el día: <strong><cfoutput>#LsDateFormat(rsMail.CMNfechaIni,"dd-mm-YYYY")#</cfoutput></strong> 
							</td>
						</tr>
						<tr>
							<td>
							    <cfoutput>#rsMail.CMNnota#</cfoutput>
						    </td>
						</tr>  
						<tr>
							<td>&nbsp;								
						    </td>
						</tr>
						<tr>
							<td>
								<br><br>Empresa:&nbsp;#rsEmpresas.Edescripcion#<br><br>
							</td>
						</tr>
						<tr>
							<td>
								<br>Si este correo ha llegado por equivocaci&oacute;n le solicitamos eliminarlo.
							</td>
						</tr>
			        </table>'>
								<cfif  len(trim(rsMail.CMNemail)) gt 0  and rsMail.recordcount gt 0 > <!---Si viene una direccion de correo, lo envia--->
										<!----- Funcion q inserta los mensajes a enviar   ------>	
											<cftransaction>	 
											<cfinvoke component="sif.Componentes.garantia"
												method="CORREO_GARANTIA"
												remitente="gestion@soin.co.cr"
												destinario="#rsMail.CMNemail#"
												asunto="#rsMail.CMPdescripcion#"
												texto="#texto#"
												usuario="-1"
												returnvariable="LvarId"
											/>
											</cftransaction>			
		                                 <cfoutput>
											 <script language="javascript">
												 alert("El correo  ha sido enviado exitosamente");
												 history.back(-1);
											 </script>
										 </cfoutput>
						    
							   </cfif>					
				
				
<cfoutput>
<script language="javascript">
  alert(Correo Enviado);
 history.back(-1);
</script>
</cfoutput>       
		<cf_web_portlet_end>	
<cf_templatefooter>

